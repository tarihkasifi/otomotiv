// OBD-II Bluetooth Servis Katmanı - ELM327 Protokolü (Classic + BLE)
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

/// OBD-II bağlantı durumu
enum OBDConnectionState {
  disconnected,
  connecting,
  connected,
  initializing,
  ready,
  error,
}

/// Arıza kodu modeli
class DTCCode {
  final String code;
  final String? description;

  DTCCode({required this.code, this.description});

  @override
  String toString() => code;
}

/// Canlı araç verisi
class VehicleData {
  final int? rpm;
  final int? speed;
  final int? coolantTemp;
  final double? throttlePosition;
  final double? engineLoad;
  final double? fuelLevel;
  final double? batteryVoltage;
  final int? intakeTemp;
  final double? maf;
  final double? timingAdvance;
  final int? fuelPressure;
  final int? fuelRailPressure; // PID 23 - Yakıt rayı basıncı (direkt enjeksiyon)
  final int? oilTemp; // PID 5C - Yağ sıcaklığı
  final DateTime timestamp;

  VehicleData({
    this.rpm,
    this.speed,
    this.coolantTemp,
    this.throttlePosition,
    this.engineLoad,
    this.fuelLevel,
    this.batteryVoltage,
    this.intakeTemp,
    this.maf,
    this.timingAdvance,
    this.fuelPressure,
    this.fuelRailPressure,
    this.oilTemp,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// ELM327 tabanlı OBD-II servis sınıfı
class OBDService {
  static final OBDService _instance = OBDService._internal();
  factory OBDService() => _instance;
  OBDService._internal();

  /// Bluetooth destekli platform mi?
  static bool get _isMobilePlatform {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  FlutterBluetoothSerial? get _bluetooth =>
      _isMobilePlatform ? FlutterBluetoothSerial.instance : null;
  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;

  // BLE bağlantı alanları
  bool _isBLE = false;
  fbp.BluetoothDevice? _bleDevice;
  fbp.BluetoothCharacteristic? _bleWriteChar;
  fbp.BluetoothCharacteristic? _bleNotifyChar;
  StreamSubscription? _bleNotifySubscription;

  final _connectionStateController =
      StreamController<OBDConnectionState>.broadcast();
  Stream<OBDConnectionState> get connectionState =>
      _connectionStateController.stream;

  OBDConnectionState _currentState = OBDConnectionState.disconnected;
  OBDConnectionState get currentState => _currentState;

  String _lastError = '';
  String get lastError => _lastError;

  final StringBuffer _responseBuffer = StringBuffer();

  // Mutex - eşzamanlı komut gönderimini önle
  bool _isCommandBusy = false;

  // Aktif okuma kontrolü
  bool _isReadingData = false;

  // NO DATA dönen PID'leri hatırla - sonraki okumalarda atla
  final Set<String> _unsupportedPids = {};

  // Desteklenen PID'ler
  Set<String> _supportedPids = {};

  void _setState(OBDConnectionState state) {
    _currentState = state;
    _connectionStateController.add(state);
  }

  /// Bluetooth durumunu kontrol et
  Future<bool> isBluetoothEnabled() async {
    if (!_isMobilePlatform) return false;
    return await _bluetooth!.isEnabled ?? false;
  }

  /// Bluetooth'u aç
  Future<bool> enableBluetooth() async {
    if (!_isMobilePlatform) return false;
    return await _bluetooth!.requestEnable() ?? false;
  }

  /// Eşleşmiş cihazları getir
  Future<List<BluetoothDevice>> getPairedDevices() async {
    if (!_isMobilePlatform) return [];
    try {
      return await _bluetooth!.getBondedDevices();
    } catch (e) {
      _lastError = 'Eşleşmiş cihazlar alınamadı: $e';
      return [];
    }
  }

  /// Yakındaki cihazları tara
  Stream<BluetoothDiscoveryResult> scanDevices() {
    if (!_isMobilePlatform) return const Stream.empty();
    return _bluetooth!.startDiscovery();
  }

  /// Taramayı durdur
  Future<void> stopScan() async {
    if (!_isMobilePlatform) return;
    await _bluetooth!.cancelDiscovery();
    await fbp.FlutterBluePlus.stopScan();
  }

  /// BLE OBD cihazları tara (Mucar BT200 vb.)
  Stream<fbp.ScanResult> scanBLEDevices() {
    if (!_isMobilePlatform) return const Stream.empty();
    fbp.FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    return fbp.FlutterBluePlus.scanResults.expand((list) => list);
  }

  /// BLE cihaza bağlan
  Future<bool> connectBLE(fbp.BluetoothDevice device, {int maxRetries = 3}) async {
    if (!_isMobilePlatform) {
      _lastError = 'Bluetooth bu platformda desteklenmiyor';
      _setState(OBDConnectionState.error);
      return false;
    }

    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        _setState(OBDConnectionState.connecting);
        await disconnect();
        await Future.delayed(const Duration(milliseconds: 500));

        print('📶 [BLE] Bağlanıyor: ${device.platformName}...');
        await device.connect(timeout: const Duration(seconds: 15));
        
        // Servisleri keşfet
        final services = await device.discoverServices();
        print('📶 [BLE] ${services.length} servis bulundu');

        // OBD servis UUID'lerini ara (FFF0, FFE0 ve diğer yaygın UUID'ler)
        fbp.BluetoothCharacteristic? writeChar;
        fbp.BluetoothCharacteristic? notifyChar;

        for (final service in services) {
          final uuid = service.uuid.toString().toUpperCase();
          print('📶 [BLE] Servis: $uuid');
          
          for (final char in service.characteristics) {
            final cUuid = char.uuid.toString().toUpperCase();
            final props = char.properties;
            print('📶 [BLE]   Char: $cUuid write=${props.write || props.writeWithoutResponse} notify=${props.notify}');
            
            if (props.write || props.writeWithoutResponse) {
              writeChar ??= char;
            }
            if (props.notify || props.indicate) {
              notifyChar ??= char;
            }
          }
        }

        if (writeChar == null || notifyChar == null) {
          _lastError = 'BLE OBD karakteristikleri bulunamadı.\\nBu cihaz OBD ELM327 desteklemiyor olabilir.';
          await device.disconnect();
          _setState(OBDConnectionState.error);
          return false;
        }

        _isBLE = true;
        _bleDevice = device;
        _bleWriteChar = writeChar;
        _bleNotifyChar = notifyChar;
        _unsupportedPids.clear();

        // Notify dinlemeyi başlat
        await notifyChar.setNotifyValue(true);
        _bleNotifySubscription = notifyChar.onValueReceived.listen((value) {
          _responseBuffer.write(utf8.decode(value, allowMalformed: true));
        });

        _setState(OBDConnectionState.connected);
        print('✅ [BLE] Bağlandı, ELM327 başlatılıyor...');

        // ELM327 başlat
        final initialized = await _initializeELM327();
        if (initialized) {
          _setState(OBDConnectionState.ready);
          return true;
        } else {
          retryCount++;
          if (retryCount < maxRetries) {
            await disconnect();
            await Future.delayed(const Duration(seconds: 1));
            continue;
          }
          _setState(OBDConnectionState.error);
          return false;
        }
      } catch (e) {
        retryCount++;
        _lastError = 'BLE bağlantı hatası: $e';
        print('❌ [BLE] Hata: $e');
        if (retryCount < maxRetries) {
          await disconnect();
          await Future.delayed(Duration(seconds: retryCount + 1));
          continue;
        }
        _setState(OBDConnectionState.error);
        return false;
      }
    }
    return false;
  }

  /// Cihaza bağlan (retry mekanizmalı)
  Future<bool> connect(BluetoothDevice device, {int maxRetries = 3}) async {
    if (!_isMobilePlatform) {
      _lastError = 'Bluetooth bu platformda desteklenmiyor';
      _setState(OBDConnectionState.error);
      return false;
    }
    _unsupportedPids.clear();
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        _setState(OBDConnectionState.connecting);

        // Mevcut bağlantıyı kapat ve biraz bekle
        await disconnect();
        await Future.delayed(const Duration(milliseconds: 500));

        // Yeni bağlantı oluştur (kısa gecikme ile)
        await Future.delayed(const Duration(milliseconds: 300));

        _connection =
            await BluetoothConnection.toAddress(device.address).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception('Bağlantı zaman aşımı');
          },
        );

        _connectedDevice = device;

        if (_connection?.isConnected ?? false) {
          _setState(OBDConnectionState.connected);

          // Veri dinleyicisi kur
          _connection!.input?.listen(
            _onDataReceived,
            onDone: () {
              _setState(OBDConnectionState.disconnected);
            },
            onError: (error) {
              _lastError = 'Bağlantı hatası: $error';
              _setState(OBDConnectionState.error);
            },
          );

          // ELM327 başlat
          final initialized = await _initializeELM327();
          if (initialized) {
            _setState(OBDConnectionState.ready);
            return true;
          } else {
            // ELM327 başlatma başarısız, tekrar dene
            retryCount++;
            if (retryCount < maxRetries) {
              await disconnect();
              await Future.delayed(const Duration(seconds: 1));
              continue;
            }
            _setState(OBDConnectionState.error);
            return false;
          }
        }

        _setState(OBDConnectionState.error);
        _lastError = 'Bağlantı kurulamadı';
        return false;
      } catch (e) {
        retryCount++;
        final errorMsg = e.toString();

        // Hata türüne göre özel mesaj
        if (errorMsg.contains('socket might closed') ||
            errorMsg.contains('read failed')) {
          _lastError = 'Bağlantı hatası: OBD cihazı meşgul olabilir.\n\n'
              'Çözüm önerileri:\n'
              '1. OBD cihazını araçtan çıkarıp tekrar takın\n'
              '2. Bluetooth ayarlarından cihazı kaldırıp yeniden eşleştirin\n'
              '3. Telefonu yeniden başlatın\n'
              '4. Başka bir OBD uygulaması açıksa kapatın';
        } else if (errorMsg.contains('timeout') ||
            errorMsg.contains('zaman aşımı')) {
          _lastError = 'Bağlantı zaman aşımı: OBD cihazı yanıt vermiyor.\n\n'
              'Araç kontağı açık mı kontrol edin.';
        } else {
          _lastError = 'Bağlantı hatası: $e';
        }

        if (retryCount < maxRetries) {
          // Retry öncesi bekle
          await disconnect();
          await Future.delayed(Duration(seconds: retryCount + 1));
          continue;
        }

        _setState(OBDConnectionState.error);
        return false;
      }
    }

    return false;
  }

  /// Bağlantıyı kes (Classic + BLE)
  Future<void> disconnect() async {
    try {
      _isReadingData = false;
      _isCommandBusy = false;

      // BLE bağlantısı kapat
      if (_isBLE) {
        await _bleNotifySubscription?.cancel();
        _bleNotifySubscription = null;
        try { await _bleDevice?.disconnect(); } catch (_) {}
        _bleDevice = null;
        _bleWriteChar = null;
        _bleNotifyChar = null;
        _isBLE = false;
      }

      // Classic bağlantı kapat
      await _connection?.close();
      _connection = null;
      _connectedDevice = null;
      _supportedPids.clear();
      _setState(OBDConnectionState.disconnected);
    } catch (e) {
      _lastError = 'Bağlantı kapatma hatası: $e';
    }
  }

  /// ELM327 başlatma sekansı (kontak açıkken de çalışır)
  Future<bool> _initializeELM327() async {
    _setState(OBDConnectionState.initializing);
    print('🔧 [OBD] Başlatma başladı... (BLE: $_isBLE)');

    try {
      // Buffer temizle
      _responseBuffer.clear();
      if (_isBLE) {
        // BLE: boş komut gönder
        try {
          await _bleWriteChar!.write(
            utf8.encode('\r'),
            withoutResponse: _bleWriteChar!.properties.writeWithoutResponse,
          );
        } catch (_) {}
      } else {
        // Classic Bluetooth
        _connection!.output.add(Uint8List.fromList(utf8.encode('\r')));
        await _connection!.output.allSent;
      }
      await Future.delayed(Duration(milliseconds: _isBLE ? 800 : 500));
      _responseBuffer.clear();
      print('🔧 [OBD] Buffer temizlendi');

      // Reset
      final atzResp = await _sendCommand('ATZ', maxWaitMs: 4000);
      print('🔧 [OBD] ATZ yanıt: "$atzResp"');
      await Future.delayed(Duration(milliseconds: _isBLE ? 1500 : 1000));
      _responseBuffer.clear();

      // Echo off - 3 deneme (BLE cihazlar için toleranslı)
      bool echoOk = false;
      for (int i = 0; i < 3; i++) {
        final echoOff = await _sendCommand('ATE0', maxWaitMs: 2000);
        print('🔧 [OBD] ATE0 deneme ${i + 1}: "$echoOff"');
        // OK, ATE0, veya boş yanıt (bazı BLE cihazlar boş döner) kabul
        if (echoOff.contains('OK') || echoOff.contains('ATE0') ||
            echoOff.contains('E0') || echoOff.isEmpty ||
            (!echoOff.contains('ERROR') && !echoOff.contains('?'))) {
          echoOk = true;
          break;
        }
        await Future.delayed(const Duration(milliseconds: 500));
        _responseBuffer.clear();
      }
      if (!echoOk) {
        // BLE için yine de devam et - bazı cihazlar echo komutunu desteklemez
        if (_isBLE) {
          print('⚠️ [OBD] BLE: Echo kapatılamadı ama devam ediliyor');
        } else {
          print('❌ [OBD] Echo kapatılamadı');
          _lastError = 'ELM327 echo kapatılamadı';
          return false;
        }
      }

      // Temel AT ayarları - hızlı sıralı gönderim
      await _sendCommand('ATL0');
      await Future.delayed(Duration(milliseconds: _isBLE ? 150 : 100));
      await _sendCommand('ATS1');
      await Future.delayed(Duration(milliseconds: _isBLE ? 150 : 100));
      await _sendCommand('ATH0');
      await Future.delayed(Duration(milliseconds: _isBLE ? 150 : 100));
      await _sendCommand('ATAT2');
      await Future.delayed(Duration(milliseconds: _isBLE ? 150 : 100));
      await _sendCommand('ATST32');
      await Future.delayed(Duration(milliseconds: _isBLE ? 150 : 100));
      print('🔧 [OBD] AT ayarları tamam');

      // Auto protocol
      final protocol = await _sendCommand('ATSP0');
      print('🔧 [OBD] ATSP0 yanıt: "$protocol"');
      if (!protocol.contains('OK') && !protocol.contains('SP0')) {
        final retry = await _sendCommand('ATSP0');
        print('🔧 [OBD] ATSP0 retry: "$retry"');
        if (!retry.contains('OK') && !retry.contains('SP0')) {
          _lastError = 'Protokol ayarlanamadı';
          return false;
        }
      }

      // Test connection - 0100 (3 deneme)
      String pids = '';
      bool pidOk = false;
      for (int i = 0; i < 3; i++) {
        final waitMs = 2000 + (i * 1500);
        pids = await _sendCommand('0100', maxWaitMs: waitMs);
        print('🔧 [OBD] 0100 deneme ${i + 1} (${waitMs}ms): "$pids"');
        if (!pids.contains('ERROR') &&
            !pids.contains('UNABLE') &&
            !pids.contains('NO DATA') &&
            !pids.contains('?') &&
            (pids.contains('41 00') || pids.contains('4100'))) {
          pidOk = true;
          break;
        }
        await Future.delayed(const Duration(milliseconds: 500));
        _responseBuffer.clear();
      }

      if (!pidOk) {
        print('❌ [OBD] PID 0100 başarısız');
        _lastError = 'Araç bağlantısı kurulamadı.\n\n'
            'Olası nedenler:\n'
            '1. Kontağı IG (ON) konumuna getirin\n'
            '2. OBD cihazını çıkarıp tekrar takın\n'
            '3. Bluetooth\'u kapatıp açın';
        return false;
      }

      // Desteklenen PID'leri parse et
      _parseSupportedPids(pids);
      print('🔧 [OBD] PID\'ler parse edildi: ${_supportedPids.length} adet');

      // Motor çalışıyor mu kontrol et (RPM > 0 olmalı)
      final rpmResponse = await _sendCommand('010C', maxWaitMs: 2000);
      print('🔧 [OBD] RPM yanıt: "$rpmResponse"');
      final rpmBytes = _extractDataBytes(rpmResponse, '410C');
      int rpm = 0;
      if (rpmBytes.length >= 2) {
        final a = int.tryParse(rpmBytes[0], radix: 16) ?? 0;
        final b = int.tryParse(rpmBytes[1], radix: 16) ?? 0;
        rpm = ((a * 256) + b) ~/ 4;
      }
      print('🔧 [OBD] RPM değeri: $rpm');

      if (rpm <= 0) {
        _lastError = 'Motor çalışmıyor!\n\n'
            'Aracın motorunu çalıştırın ve tekrar bağlanın.\n'
            'OBD sistemi sadece motor çalışırken kullanılabilir.';
        _setState(OBDConnectionState.disconnected);
        return false;
      }

      print('✅ [OBD] Başlatma başarılı! RPM: $rpm');
      return true;
    } catch (e) {
      print('❌ [OBD] Başlatma hatası: $e');
      _lastError = 'ELM327 başlatma hatası: $e';
      return false;
    }
  }

  /// Desteklenen PID'leri parse et (0100 yanıtından)
  void _parseSupportedPids(String response) {
    _supportedPids.clear();
    try {
      final bytes = _extractDataBytes(response, '4100');
      if (bytes.length >= 4) {
        // 4 byte = 32 PID (01-20)
        for (int byteIdx = 0; byteIdx < bytes.length && byteIdx < 4; byteIdx++) {
          final byteVal = int.tryParse(bytes[byteIdx], radix: 16) ?? 0;
          for (int bit = 7; bit >= 0; bit--) {
            if ((byteVal >> bit) & 1 == 1) {
              final pid = (byteIdx * 8) + (7 - bit) + 1;
              _supportedPids.add(pid.toRadixString(16).toUpperCase().padLeft(2, '0'));
            }
          }
        }
      }
    } catch (e) {
      // PID parse hatası - varsayılan olarak hepsini dene
    }
  }

  /// PID destekleniyor mu?
  bool isPidSupported(String pid) {
    if (_supportedPids.isEmpty) return true; // Bilinmiyorsa dene
    return _supportedPids.contains(pid.toUpperCase());
  }

  void _onDataReceived(Uint8List data) {
    _responseBuffer.write(utf8.decode(data, allowMalformed: true));
  }

  /// Komut gönder ve yanıt al (mutex korumalı, Classic + BLE)
  Future<String> _sendCommand(String command, {int maxWaitMs = 500}) async {
    // Bağlantı kontrolü
    if (_isBLE) {
      if (_bleWriteChar == null) return 'ERROR: BLE not connected';
    } else {
      if (_connection == null || !(_connection!.isConnected)) {
        return 'ERROR: Not connected';
      }
    }

    // Mutex - önceki komut bitmesini bekle (max 1.5 saniye)
    int waitCount = 0;
    while (_isCommandBusy && waitCount < 30) {
      await Future.delayed(const Duration(milliseconds: 50));
      waitCount++;
    }
    if (_isCommandBusy) {
      _isCommandBusy = false;
    }

    _isCommandBusy = true;
    _responseBuffer.clear();

    try {
      // Komutu gönder
      if (_isBLE) {
        // BLE üzerinden gönder
        await _bleWriteChar!.write(
          utf8.encode('$command\r'),
          withoutResponse: _bleWriteChar!.properties.writeWithoutResponse,
        );
      } else {
        // Classic Bluetooth üzerinden gönder
        _connection!.output.add(Uint8List.fromList(utf8.encode('$command\r')));
        await _connection!.output.allSent;
      }

      // Yanıt bekle - minimum süre
      await Future.delayed(const Duration(milliseconds: 20));

      // Prompt karakteri ('>') bekle - timeout ile
      final maxAttempts = maxWaitMs ~/ 25;
      int attempts = 0;
      while (!_responseBuffer.toString().contains('>') && attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 25));
        attempts++;
      }

      String response = _responseBuffer.toString();

      // Temizlik
      response = response
          .replaceAll('>', '')
          .replaceAll('\r\n', ' ')
          .replaceAll('\r', ' ')
          .replaceAll('\n', ' ')
          .trim();

      // Echo varsa kaldır (komut kendisi yanıtta olabilir)
      if (response.startsWith(command)) {
        response = response.substring(command.length).trim();
      }

      return response;
    } catch (e) {
      return 'ERROR: $e';
    } finally {
      _isCommandBusy = false;
    }
  }

  /// Arıza kodlarını oku (Mode 03)
  Future<List<DTCCode>> readDTCs() async {
    if (!isConnected) {
      return [];
    }

    try {
      final response = await _sendCommand('03');

      if (response.contains('NO DATA') || response.contains('ERROR')) {
        return [];
      }

      return _parseDTCs(response);
    } catch (e) {
      _lastError = 'Arıza kodu okuma hatası: $e';
      return [];
    }
  }

  /// DTC yanıtını parse et
  List<DTCCode> _parseDTCs(String response) {
    final codes = <DTCCode>[];

    // Hex karakterleri temizle ve parse et
    final cleanResponse = response.replaceAll(' ', '').replaceAll('43', '');

    if (cleanResponse.isEmpty || cleanResponse == '0000') {
      return codes;
    }

    // Her 4 karakter bir DTC kodu
    for (int i = 0; i + 4 <= cleanResponse.length; i += 4) {
      final dtcBytes = cleanResponse.substring(i, i + 4);
      if (dtcBytes == '0000') continue;

      final code = _decodeDTC(dtcBytes);
      if (code.isNotEmpty) {
        codes.add(DTCCode(code: code));
      }
    }

    return codes;
  }

  /// DTC baytlarını kod formatına çevir
  String _decodeDTC(String bytes) {
    if (bytes.length < 4) return '';

    final firstNibble = int.tryParse(bytes[0], radix: 16) ?? 0;

    // İlk karakter: P, C, B, U
    final prefixes = ['P', 'C', 'B', 'U'];
    final prefix = prefixes[(firstNibble >> 2) & 0x03];

    // Geri kalan karakterler
    final secondChar = (firstNibble & 0x03).toString();
    final rest = bytes.substring(1);

    return '$prefix$secondChar$rest';
  }

  /// Arıza kodlarını temizle (Mode 04)
  Future<bool> clearDTCs() async {
    if (!isConnected) {
      return false;
    }

    try {
      final response = await _sendCommand('04');
      return response.contains('44') || response.contains('OK');
    } catch (e) {
      _lastError = 'Arıza kodu temizleme hatası: $e';
      return false;
    }
  }

  /// VIN numarasını oku (Mode 09, PID 02)
  /// _sendCommand kullanır - mutex ile korunur
  Future<String?> getVin() async {
    if (!isConnected) {
      return null;
    }

    try {
      // VIN yanıtı uzun sürer - 6 saniye timeout
      final response = await _sendCommand('0902', maxWaitMs: 6000);

      if (response.contains('NO DATA') ||
          response.contains('ERROR') ||
          response.contains('UNABLE') ||
          response.contains('?')) {
        return null;
      }

      // VIN baytlarını çıkar
      final vinBytes = <int>[];

      // Tüm satırları parse et
      final lines = response.split(RegExp(r'[\r\n]+'));

      for (final line in lines) {
        final cleanLine = line.trim();
        if (cleanLine.isEmpty) continue;

        String dataSection = cleanLine;

        // "49 02 XX" header'ı kaldır (XX = satır numarası)
        dataSection = dataSection.replaceAll(RegExp(r'49\s*02\s*[0-9A-Fa-f]{2}\s*'), '');

        // ISO 15765-4 format: "014\n" veya "0: 49 02 01" prefix kaldır
        dataSection = dataSection.replaceAll(RegExp(r'^\d+:\s*'), '');
        dataSection = dataSection.replaceAll(RegExp(r'^0[1-2][0-9A-Fa-f]\s*'), '');

        // Kalan hex baytlarını çıkar
        final parts = dataSection.trim().split(RegExp(r'\s+'));
        for (final part in parts) {
          final trimmed = part.trim();
          if (trimmed.length == 2 && RegExp(r'^[0-9A-Fa-f]{2}$').hasMatch(trimmed)) {
            final byte = int.parse(trimmed, radix: 16);
            // Yazdırılabilir ASCII (VIN karakterleri: 0-9, A-Z)
            if (byte >= 0x30 && byte <= 0x5A) {
              vinBytes.add(byte);
            }
          }
        }
      }

      // Boşluksuz format dene
      if (vinBytes.isEmpty) {
        final clean = response.replaceAll(RegExp(r'\s+'), '').toUpperCase();
        final idx = clean.indexOf('4902');
        if (idx >= 0) {
          String data = clean.substring(idx);
          data = data.replaceAll(RegExp(r'4902[0-9A-F]{2}'), '');
          for (int i = 0; i + 2 <= data.length; i += 2) {
            final byte = int.tryParse(data.substring(i, i + 2), radix: 16) ?? 0;
            if (byte >= 0x30 && byte <= 0x5A) {
              vinBytes.add(byte);
            }
          }
        }
      }

      if (vinBytes.length >= 11) {
        final vin = String.fromCharCodes(vinBytes);
        if (RegExp(r'^[A-HJ-NPR-Z0-9]+$').hasMatch(vin)) {
          return vin;
        }
      }

      return null;
    } catch (e) {
      _lastError = 'VIN okuma hatası: $e';
      return null;
    }
  }

  /// Hızlı canlı veri oku (temel PID'ler + voltaj + yakıt)
  /// Dashboard ve gösterge ekranları için (~2-3 saniye)
  /// Desteklenmeyen PID'ler otomatik atlanır
  /// Dashboard için ultra hızlı veri okuma (sadece 4 temel PID)
  /// RPM, Hız, Su Sıcaklığı, Gaz Kelebeği - toplam ~1s
  Future<VehicleData> readDashboardData() async {
    if (!isConnected) return VehicleData();
    if (_isReadingData) return VehicleData();
    _isReadingData = true;

    int? rpm;
    int? speed;
    int? coolantTemp;
    double? throttlePosition;

    try {
      // RPM (PID 0C)
      final r1 = await _sendCommand('010C', maxWaitMs: 400);
      rpm = _parseRPM(r1);

      // Hız (PID 0D)
      final r2 = await _sendCommand('010D', maxWaitMs: 400);
      speed = _parseSpeed(r2);

      // Soğutma suyu sıcaklığı (PID 05)
      final r3 = await _sendCommand('0105', maxWaitMs: 400);
      coolantTemp = _parseCoolantTemp(r3);

      // Gaz kelebeği (PID 11)
      final r4 = await _sendCommand('0111', maxWaitMs: 400);
      throttlePosition = _parseThrottlePosition(r4);
    } catch (e) {
      _lastError = 'Dashboard veri okuma hatası: $e';
    } finally {
      _isReadingData = false;
    }

    return VehicleData(
      rpm: rpm,
      speed: speed,
      coolantTemp: coolantTemp,
      throttlePosition: throttlePosition,
    );
  }

  /// Tüm verileri oku (slow cycle - detaylı veriler için)
  Future<VehicleData> readFastData() async {
    if (!isConnected) {
      print('⚠️ [OBD] readFastData: bağlı değil');
      return VehicleData();
    }

    if (_isReadingData) return VehicleData();
    _isReadingData = true;

    int? rpm;
    int? speed;
    int? coolantTemp;
    double? throttlePosition;
    double? batteryVoltage;
    double? fuelLevel;
    int? fuelPressure;
    int? oilTemp;

    try {
      // RPM (PID 0C) - her zaman oku
      try {
        final r = await _sendCommand('010C');
        rpm = _parseRPM(r);
      } catch (_) {}

      // Hız (PID 0D) - her zaman oku
      try {
        final r = await _sendCommand('010D');
        speed = _parseSpeed(r);
      } catch (_) {}

      // Soğutma suyu sıcaklığı (PID 05)
      try {
        final r = await _sendCommand('0105');
        coolantTemp = _parseCoolantTemp(r);
      } catch (_) {}

      // Gaz kelebeği (PID 11)
      try {
        final r = await _sendCommand('0111');
        throttlePosition = _parseThrottlePosition(r);
      } catch (_) {}

      // Akü voltajı (AT komutu - her zaman desteklenir)
      try {
        final r = await _sendCommand('ATRV');
        batteryVoltage = _parseBatteryVoltage(r);
      } catch (_) {}

      // Yakıt seviyesi (PID 2F) - desteklenmiyorsa atla
      if (!_unsupportedPids.contains('012F')) {
        try {
          final r = await _sendCommand('012F');
          fuelLevel = _parseFuelLevel(r);
          if (r.contains('NO DATA')) _unsupportedPids.add('012F');
        } catch (_) {}
      }

      // Yakıt basıncı - PID 0A, yoksa PID 23
      if (!_unsupportedPids.contains('010A')) {
        try {
          final r = await _sendCommand('010A');
          fuelPressure = _parseFuelPressure(r);
          if (r.contains('NO DATA')) _unsupportedPids.add('010A');
        } catch (_) {}
      }
      if ((fuelPressure == null || fuelPressure == 0) && !_unsupportedPids.contains('0123')) {
        try {
          final r = await _sendCommand('0123');
          final railP = _parseFuelRailPressure(r);
          if (railP != null) fuelPressure = railP;
          if (r.contains('NO DATA')) _unsupportedPids.add('0123');
        } catch (_) {}
      }

      // Yağ sıcaklığı (PID 5C) - desteklenmiyorsa atla
      if (!_unsupportedPids.contains('015C')) {
        try {
          final r = await _sendCommand('015C');
          oilTemp = _parseOilTemp(r);
          if (r.contains('NO DATA')) _unsupportedPids.add('015C');
        } catch (_) {}
      }

      print('📊 [OBD] FastData: RPM=$rpm Hız=$speed Sıcaklık=$coolantTemp Gaz=$throttlePosition Voltaj=$batteryVoltage Yakıt=$fuelLevel Basınç=$fuelPressure Yağ=$oilTemp (Atlanan: ${_unsupportedPids.length})');
    } catch (e) {
      _lastError = 'Hızlı veri okuma hatası: $e';
    } finally {
      _isReadingData = false;
    }

    return VehicleData(
      rpm: rpm,
      speed: speed,
      coolantTemp: coolantTemp,
      throttlePosition: throttlePosition,
      batteryVoltage: batteryVoltage,
      fuelLevel: fuelLevel,
      fuelPressure: fuelPressure,
      oilTemp: oilTemp,
    );
  }

  /// Canlı veri oku (genişletilmiş - tüm PID'ler)
  /// Veri grid ekranı için - desteklenmeyen PID'ler otomatik atlanır
  Future<VehicleData> readLiveData() async {
    if (!isConnected) {
      return VehicleData();
    }

    if (_isReadingData) {
      return VehicleData();
    }

    _isReadingData = true;

    int? rpm;
    int? speed;
    int? coolantTemp;
    double? throttlePosition;
    double? engineLoad;
    double? fuelLevel;
    double? batteryVoltage;
    int? intakeTemp;
    double? maf;
    double? timingAdvance;
    int? fuelPressure;
    int? fuelRailPressure;
    int? oilTemp;

    try {
      // RPM (PID 0C)
      try {
        final r = await _sendCommand('010C');
        rpm = _parseRPM(r);
      } catch (_) {}

      // Hız (PID 0D)
      try {
        final r = await _sendCommand('010D');
        speed = _parseSpeed(r);
      } catch (_) {}

      // Soğutma suyu sıcaklığı (PID 05)
      try {
        final r = await _sendCommand('0105');
        coolantTemp = _parseCoolantTemp(r);
      } catch (_) {}

      // Gaz kelebeği (PID 11)
      try {
        final r = await _sendCommand('0111');
        throttlePosition = _parseThrottlePosition(r);
      } catch (_) {}

      // Motor yükü (PID 04)
      try {
        final r = await _sendCommand('0104');
        engineLoad = _parseEngineLoad(r);
      } catch (_) {}

      // Yakıt seviyesi (PID 2F)
      if (!_unsupportedPids.contains('012F')) {
        try {
          final r = await _sendCommand('012F');
          fuelLevel = _parseFuelLevel(r);
          if (r.contains('NO DATA')) _unsupportedPids.add('012F');
        } catch (_) {}
      }

      // Akü voltajı
      try {
        final r = await _sendCommand('ATRV');
        batteryVoltage = _parseBatteryVoltage(r);
      } catch (_) {}

      // Emiş havası sıcaklığı (PID 0F)
      if (!_unsupportedPids.contains('010F')) {
        try {
          final r = await _sendCommand('010F');
          intakeTemp = _parseIntakeTemp(r);
          if (r.contains('NO DATA')) _unsupportedPids.add('010F');
        } catch (_) {}
      }

      // MAF (PID 10)
      if (!_unsupportedPids.contains('0110')) {
        try {
          final r = await _sendCommand('0110');
          maf = _parseMAF(r);
          if (r.contains('NO DATA')) _unsupportedPids.add('0110');
        } catch (_) {}
      }

      // Ateşleme zamanlaması (PID 0E)
      if (!_unsupportedPids.contains('010E')) {
        try {
          final r = await _sendCommand('010E');
          timingAdvance = _parseTimingAdvance(r);
          if (r.contains('NO DATA')) _unsupportedPids.add('010E');
        } catch (_) {}
      }

      // Yakıt basıncı (PID 0A)
      if (!_unsupportedPids.contains('010A')) {
        try {
          final r = await _sendCommand('010A');
          fuelPressure = _parseFuelPressure(r);
          if (r.contains('NO DATA')) _unsupportedPids.add('010A');
        } catch (_) {}
      }

      // Yakıt rayı basıncı (PID 23) 
      if (!_unsupportedPids.contains('0123')) {
        try {
          final r = await _sendCommand('0123');
          fuelRailPressure = _parseFuelRailPressure(r);
          if ((fuelPressure == null || fuelPressure == 0) && fuelRailPressure != null) {
            fuelPressure = fuelRailPressure;
          }
          if (r.contains('NO DATA')) _unsupportedPids.add('0123');
        } catch (_) {}
      }

      // Yağ sıcaklığı (PID 5C)
      if (!_unsupportedPids.contains('015C')) {
        try {
          final r = await _sendCommand('015C');
          oilTemp = _parseOilTemp(r);
          if (r.contains('NO DATA')) _unsupportedPids.add('015C');
        } catch (_) {}
      }

      print('📊 [LIVE] RPM=$rpm Hız=$speed Sıcaklık=$coolantTemp Gaz=$throttlePosition Yük=$engineLoad Yakıt=$fuelLevel Voltaj=$batteryVoltage Emiş=$intakeTemp MAF=$maf Basınç=$fuelPressure Yağ=$oilTemp (Atlanan: ${_unsupportedPids.length})');
    } catch (e) {
      _lastError = 'Canlı veri okuma hatası: $e';
    } finally {
      _isReadingData = false;
    }

    return VehicleData(
      rpm: rpm,
      speed: speed,
      coolantTemp: coolantTemp,
      throttlePosition: throttlePosition,
      engineLoad: engineLoad,
      fuelLevel: fuelLevel,
      batteryVoltage: batteryVoltage,
      intakeTemp: intakeTemp,
      maf: maf,
      timingAdvance: timingAdvance,
      fuelPressure: fuelPressure,
      fuelRailPressure: fuelRailPressure,
      oilTemp: oilTemp,
    );
  }

  // ==================== PID Parsers ====================

  int? _parseRPM(String response) {
    final bytes = _extractDataBytes(response, '410C');
    if (bytes.length >= 2) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      final b = int.tryParse(bytes[1], radix: 16) ?? 0;
      return ((a * 256) + b) ~/ 4;
    }
    return null;
  }

  int? _parseSpeed(String response) {
    final bytes = _extractDataBytes(response, '410D');
    if (bytes.isNotEmpty) {
      return int.tryParse(bytes[0], radix: 16);
    }
    return null;
  }

  int? _parseCoolantTemp(String response) {
    final bytes = _extractDataBytes(response, '4105');
    if (bytes.isNotEmpty) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      return a - 40;
    }
    return null;
  }

  double? _parseThrottlePosition(String response) {
    final bytes = _extractDataBytes(response, '4111');
    if (bytes.isNotEmpty) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      return (a * 100) / 255;
    }
    return null;
  }

  double? _parseEngineLoad(String response) {
    final bytes = _extractDataBytes(response, '4104');
    if (bytes.isNotEmpty) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      return (a * 100) / 255;
    }
    return null;
  }

  /// Yakıt seviyesi parse (PID 2F) - %
  double? _parseFuelLevel(String response) {
    if (response.contains('NO DATA') || response.contains('ERROR')) return null;
    final bytes = _extractDataBytes(response, '412F');
    if (bytes.isNotEmpty) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      return (a * 100) / 255;
    }
    return null;
  }

  /// Akü voltajı parse (ATRV komutu) - V
  double? _parseBatteryVoltage(String response) {
    if (response.contains('ERROR') || response.contains('NO DATA')) return null;
    // ATRV yanıtı: "12.6V", "12.6", "ATRV\r12.6V" gibi formatlarda gelebilir
    // Regex ile sayıyı bul
    final match = RegExp(r'(\d{1,2}\.\d{1,2})').firstMatch(response);
    if (match != null) {
      final voltage = double.tryParse(match.group(1)!);
      print('🔋 [OBD] Voltaj parse: raw="$response" → $voltage V');
      return voltage;
    }
    print('🔋 [OBD] Voltaj parse başarısız: raw="$response"');
    return null;
  }

  /// Emiş havası sıcaklığı parse (PID 0F) - °C
  int? _parseIntakeTemp(String response) {
    if (response.contains('NO DATA') || response.contains('ERROR')) return null;
    final bytes = _extractDataBytes(response, '410F');
    if (bytes.isNotEmpty) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      return a - 40;
    }
    return null;
  }

  /// MAF hava akış hızı parse (PID 10) - g/s
  double? _parseMAF(String response) {
    if (response.contains('NO DATA') || response.contains('ERROR')) return null;
    final bytes = _extractDataBytes(response, '4110');
    if (bytes.length >= 2) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      final b = int.tryParse(bytes[1], radix: 16) ?? 0;
      return ((a * 256) + b) / 100;
    }
    return null;
  }

  /// Ateşleme zamanlaması parse (PID 0E) - derece
  double? _parseTimingAdvance(String response) {
    if (response.contains('NO DATA') || response.contains('ERROR')) return null;
    final bytes = _extractDataBytes(response, '410E');
    if (bytes.isNotEmpty) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      return (a / 2) - 64;
    }
    return null;
  }

  /// Yakıt basıncı parse (PID 0A) - kPa
  int? _parseFuelPressure(String response) {
    if (response.contains('NO DATA') || response.contains('ERROR')) return null;
    final bytes = _extractDataBytes(response, '410A');
    if (bytes.isNotEmpty) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      return a * 3;
    }
    return null;
  }

  /// Yakıt rayı basıncı parse (PID 23) - kPa
  /// 2015+ direkt enjeksiyonlu araçlar için (yüksek basınç)
  /// Formül: 10 * (256 * A + B)
  int? _parseFuelRailPressure(String response) {
    if (response.contains('NO DATA') || response.contains('ERROR')) return null;
    final bytes = _extractDataBytes(response, '4123');
    if (bytes.length >= 2) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      final b = int.tryParse(bytes[1], radix: 16) ?? 0;
      return 10 * ((a * 256) + b);
    }
    return null;
  }

  /// Yağ sıcaklığı parse (PID 5C) - °C
  /// Formül: A - 40
  int? _parseOilTemp(String response) {
    if (response.contains('NO DATA') || response.contains('ERROR')) return null;
    final bytes = _extractDataBytes(response, '415C');
    if (bytes.isNotEmpty) {
      final a = int.tryParse(bytes[0], radix: 16) ?? 0;
      return a - 40;
    }
    return null;
  }

  /// Yanıttan veri baytlarını çıkar
  /// Hem boşluklu ("41 0C 1A 2B") hem boşluksuz ("410C1A2B") formatı destekler
  List<String> _extractDataBytes(String response, String prefix) {
    // Önce boşluklu formatı dene
    final spacedPrefix = '${prefix.substring(0, 2)} ${prefix.substring(2)}';
    
    // Boşluklu format kontrolü
    if (response.contains(spacedPrefix)) {
      final idx = response.indexOf(spacedPrefix);
      final afterPrefix = response.substring(idx + spacedPrefix.length).trim();
      final parts = afterPrefix.split(' ');
      final bytes = <String>[];
      for (final part in parts) {
        final trimmed = part.trim();
        if (trimmed.length == 2 && RegExp(r'^[0-9A-Fa-f]{2}$').hasMatch(trimmed)) {
          bytes.add(trimmed);
        } else {
          break; // Geçersiz byte bulunca dur
        }
      }
      if (bytes.isNotEmpty) return bytes;
    }

    // Boşluksuz format
    final clean = response.replaceAll(' ', '').toUpperCase();
    final upperPrefix = prefix.toUpperCase();
    final idx = clean.indexOf(upperPrefix);
    if (idx >= 0 && clean.length > idx + upperPrefix.length) {
      final data = clean.substring(idx + upperPrefix.length);
      final bytes = <String>[];
      for (int i = 0; i + 2 <= data.length; i += 2) {
        final byte = data.substring(i, i + 2);
        if (RegExp(r'^[0-9A-Fa-f]{2}$').hasMatch(byte)) {
          bytes.add(byte);
        } else {
          break;
        }
      }
      return bytes;
    }
    return [];
  }

  /// Bağlı cihaz bilgisi (Classic)
  BluetoothDevice? get connectedDevice => _connectedDevice;

  /// Bağlı cihaz adı (Classic + BLE uyumlu)
  String get connectedDeviceName {
    if (_isBLE && _bleDevice != null) {
      return _bleDevice!.platformName.isNotEmpty ? _bleDevice!.platformName : 'BLE Cihaz';
    }
    return _connectedDevice?.name ?? _connectedDevice?.address ?? 'Bilinmeyen';
  }

  /// Bağlı cihaz adresi (Classic + BLE uyumlu)
  String get connectedDeviceAddress {
    if (_isBLE && _bleDevice != null) {
      return _bleDevice!.remoteId.toString();
    }
    return _connectedDevice?.address ?? '';
  }

  /// Bağlı mı? (Classic + BLE)
  bool get isConnected {
    if (_isBLE) {
      return _bleWriteChar != null &&
          (_currentState == OBDConnectionState.ready ||
           _currentState == OBDConnectionState.connected ||
           _currentState == OBDConnectionState.initializing);
    }
    return (_connection?.isConnected ?? false) &&
        (_currentState == OBDConnectionState.ready ||
         _currentState == OBDConnectionState.connected ||
         _currentState == OBDConnectionState.initializing);
  }

  /// BLE bağlantısı mı?
  bool get isBLEConnection => _isBLE;

  /// Desteklenen PID setini getir
  Set<String> get supportedPids => _supportedPids;

  /// Dispose
  void dispose() {
    disconnect();
    _connectionStateController.close();
  }
}
