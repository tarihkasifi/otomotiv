// OBD-II Bluetooth Bağlantı Ekranı
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

import '../services/obd_service.dart';
import '../services/gemini_service.dart';
import '../data/obd_codes.dart';
import '../providers/vehicle_provider.dart';
import '../widgets/diagnosis_result_view.dart';
import '../utils/responsive.dart';

class OBDConnectionScreen extends StatefulWidget {
  const OBDConnectionScreen({super.key});

  @override
  State<OBDConnectionScreen> createState() => _OBDConnectionScreenState();
}

class _OBDConnectionScreenState extends State<OBDConnectionScreen> {
  final OBDService _obdService = OBDService();
  final GeminiService _geminiService = GeminiService();

  List<BluetoothDevice> _pairedDevices = [];
  List<BluetoothDiscoveryResult> _discoveredDevices = [];
  List<fbp.ScanResult> _bleDevices = [];
  StreamSubscription<BluetoothDiscoveryResult>? _discoverySubscription;
  StreamSubscription<fbp.ScanResult>? _bleScanSubscription;
  StreamSubscription<OBDConnectionState>? _connectionSubscription;

  bool _isScanning = false;
  bool _isLoading = false;
  bool _isReadingDTCs = false;
  OBDConnectionState _connectionState = OBDConnectionState.disconnected;

  List<DTCCode> _dtcCodes = [];
  VehicleData? _liveData;
  DiagnosisResult? _analysisResult;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // İzinleri kontrol et
    await _checkPermissions();

    // Bağlantı durumunu dinle
    _connectionSubscription = _obdService.connectionState.listen((state) {
      setState(() => _connectionState = state);
    });

    // Eşleşmiş cihazları yükle
    await _loadPairedDevices();
  }

  Future<void> _checkPermissions() async {
    // İzinler yalnızca mobil platformda gerekli
    try {
      if (!Platform.isAndroid && !Platform.isIOS) return;
    } catch (_) {
      return;
    }
    final bluetoothConnect = await Permission.bluetoothConnect.request();
    final bluetoothScan = await Permission.bluetoothScan.request();
    await Permission.locationWhenInUse.request();

    if (!bluetoothConnect.isGranted || !bluetoothScan.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bluetooth izinleri gerekli'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _loadPairedDevices() async {
    setState(() => _isLoading = true);

    final enabled = await _obdService.isBluetoothEnabled();
    if (!enabled) {
      await _obdService.enableBluetooth();
    }

    final devices = await _obdService.getPairedDevices();

    setState(() {
      _pairedDevices = devices;
      _isLoading = false;
    });
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _discoveredDevices.clear();
      _bleDevices.clear();
    });

    // Classic Bluetooth tarama
    _discoverySubscription = _obdService.scanDevices().listen(
      (result) {
        final name = result.device.name?.toLowerCase() ?? '';
        if (name.contains('obd') ||
            name.contains('elm') ||
            name.contains('obdii') ||
            name.isNotEmpty) {
          setState(() {
            if (!_discoveredDevices
                .any((d) => d.device.address == result.device.address)) {
              _discoveredDevices.add(result);
            }
          });
        }
      },
      onDone: () {
        if (_bleScanSubscription == null) {
          setState(() => _isScanning = false);
        }
      },
    );

    // BLE tarama (Mucar BT200 vb.)
    _bleScanSubscription = _obdService.scanBLEDevices().listen(
      (result) {
        final name = result.device.platformName.toLowerCase();
        if (name.contains('obd') ||
            name.contains('elm') ||
            name.contains('mucar') ||
            name.contains('bt') ||
            name.contains('vgate') ||
            name.contains('icar') ||
            name.isNotEmpty) {
          setState(() {
            if (!_bleDevices.any((d) => d.device.remoteId == result.device.remoteId)) {
              _bleDevices.add(result);
            }
          });
        }
      },
    );

    // 12 saniye sonra taramayı durdur
    Future.delayed(const Duration(seconds: 12), () {
      if (_isScanning) {
        _stopScan();
      }
    });
  }

  void _stopScan() {
    _discoverySubscription?.cancel();
    _bleScanSubscription?.cancel();
    _bleScanSubscription = null;
    _obdService.stopScan();
    setState(() => _isScanning = false);
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() => _isLoading = true);

    final success = await _obdService.connect(device);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('✅ ${device.name ?? device.address} bağlantısı başarılı!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Detaylı hata dialogu göster
        _showConnectionErrorDialog(device.name ?? device.address);
      }
    }
  }

  void _showConnectionErrorDialog(String deviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.error_outline, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text('Hata', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bağlantı hatası:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _obdService.lastError,
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Çözüm Önerileri:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTip('1. Araç kontağının açık olduğundan emin olun'),
                    _buildTip('2. OBD cihazını çıkarıp tekrar takın'),
                    _buildTip(
                        '3. Bluetooth ayarlarından cihazı kaldırıp yeniden eşleştirin'),
                    _buildTip('4. Başka OBD uygulaması açıksa kapatın'),
                    _buildTip('5. Telefonu yeniden başlatın'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _connectToDevice(BluetoothDevice(
                name: deviceName,
                address: _obdService.connectedDeviceAddress,
              ));
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[300], fontSize: 12),
      ),
    );
  }

  Future<void> _disconnect() async {
    await _obdService.disconnect();
    setState(() {
      _dtcCodes.clear();
      _liveData = null;
      _analysisResult = null;
    });
  }

  Future<void> _readDTCs() async {
    setState(() {
      _isReadingDTCs = true;
      _analysisResult = null;
    });

    final codes = await _obdService.readDTCs();

    setState(() {
      _dtcCodes = codes;
      _isReadingDTCs = false;
    });

    if (codes.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Arıza kodu bulunamadı!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _clearDTCs() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Arıza Kodlarını Sil'),
        content: const Text(
            'Tüm arıza kodları silinecek ve check engine lambası sıfırlanacak.\n\n'
            'Bu işlem geri alınamaz. Devam etmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);

      final success = await _obdService.clearDTCs();

      setState(() => _isLoading = false);

      if (success) {
        setState(() => _dtcCodes.clear());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Arıza kodları temizlendi!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  Future<void> _readLiveData() async {
    setState(() => _isLoading = true);

    final data = await _obdService.readLiveData();

    setState(() {
      _liveData = data;
      _isLoading = false;
    });
  }

  Future<void> _analyzeDTCs() async {
    if (_dtcCodes.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // İlk kodu analiz et
      final code = _dtcCodes.first.code;

      // Veritabanından açıklama bul
      final dbCode = obdCodes.where((c) => c.code == code).firstOrNull;
      final description = dbCode?.description ?? 'Bilinmeyen kod';

      // Bilinmeyen araç için varsayılan VehicleInfo oluştur
      final unknownVehicle = VehicleInfo(
        brand: 'Bilinmeyen',
        model: 'Araç',
        fuelType: 'Bilinmeyen',
      );

      final result = await _geminiService.analyzeOBDCode(
        unknownVehicle,
        code,
        description,
      );

      setState(() {
        _analysisResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analiz hatası: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// BLE cihaza bağlan
  Future<void> _connectToBLEDevice(fbp.BluetoothDevice device) async {
    setState(() => _isLoading = true);

    final success = await _obdService.connectBLE(device);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${device.platformName} BLE bağlantısı başarılı!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showConnectionErrorDialog(device.platformName);
      }
    }
  }

  @override
  void dispose() {
    _discoverySubscription?.cancel();
    _bleScanSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔌 OBD-II Bağlantısı'),
        actions: [
          if (_connectionState == OBDConnectionState.ready)
            IconButton(
              onPressed: _readLiveData,
              icon: const Icon(Icons.speed),
              tooltip: 'Canlı Veri',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: DesktopContentWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConnectionStatus(),
                    const SizedBox(height: 24),
                    if (_connectionState == OBDConnectionState.ready) ...[
                      _buildConnectedActions(),
                      const SizedBox(height: 24),
                      if (_liveData != null) _buildLiveDataCard(),
                      if (_dtcCodes.isNotEmpty) ...[
                        _buildDTCList(),
                        const SizedBox(height: 16),
                      ],
                      if (_analysisResult != null)
                        DiagnosisResultView(result: _analysisResult!),
                    ] else ...[
                      _buildDeviceList(),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildConnectionStatus() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (_connectionState) {
      case OBDConnectionState.disconnected:
        statusColor = Colors.grey;
        statusText = 'Bağlı Değil';
        statusIcon = Icons.bluetooth_disabled;
        break;
      case OBDConnectionState.connecting:
        statusColor = Colors.orange;
        statusText = 'Bağlanıyor...';
        statusIcon = Icons.bluetooth_searching;
        break;
      case OBDConnectionState.connected:
        statusColor = Colors.blue;
        statusText = 'Bağlandı';
        statusIcon = Icons.bluetooth_connected;
        break;
      case OBDConnectionState.initializing:
        statusColor = Colors.amber;
        statusText = 'Başlatılıyor...';
        statusIcon = Icons.settings;
        break;
      case OBDConnectionState.ready:
        statusColor = Colors.green;
        statusText = 'Hazır';
        statusIcon = Icons.check_circle;
        break;
      case OBDConnectionState.error:
        statusColor = Colors.red;
        statusText = 'Hata';
        statusIcon = Icons.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                if (_obdService.connectedDevice != null || _obdService.isBLEConnection)
                  Text(
                    _obdService.connectedDeviceName,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                if (_connectionState == OBDConnectionState.error)
                  Text(
                    _obdService.lastError,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
              ],
            ),
          ),
          if (_connectionState == OBDConnectionState.ready)
            ElevatedButton.icon(
              onPressed: _disconnect,
              icon: const Icon(Icons.link_off),
              label: const Text('Kes'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildConnectedActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔧 İşlemler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isReadingDTCs ? null : _readDTCs,
                    icon: _isReadingDTCs
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label:
                        Text(_isReadingDTCs ? 'Okunuyor...' : 'Arıza Kodu Oku'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _dtcCodes.isEmpty ? null : _clearDTCs,
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Kodları Sil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            if (_dtcCodes.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _analyzeDTCs,
                  icon: const Icon(Icons.psychology),
                  label: const Text('AI ile Analiz Et'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLiveDataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📊 Canlı Veriler',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: _readLiveData,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDataTile('RPM', '${_liveData?.rpm ?? '-'}', Icons.speed),
                _buildDataTile('Hız', '${_liveData?.speed ?? '-'} km/h',
                    Icons.directions_car),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildDataTile('Sıcaklık', '${_liveData?.coolantTemp ?? '-'}°C',
                    Icons.thermostat),
                _buildDataTile(
                    'Motor Yükü',
                    '${_liveData?.engineLoad?.toStringAsFixed(1) ?? '-'}%',
                    Icons.engineering),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTile(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDTCList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚠️ Arıza Kodları (${_dtcCodes.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...(_dtcCodes.map((code) {
              // Veritabanından açıklama bul
              final dbCode =
                  obdCodes.where((c) => c.code == code.code).firstOrNull;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        code.code,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dbCode?.description ?? 'Bilinmeyen kod',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ),
                  ],
                ),
              );
            })),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eşleşmiş cihazlar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '📱 Eşleşmiş Cihazlar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: _loadPairedDevices,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_pairedDevices.isEmpty)
          _buildEmptyState('Eşleşmiş OBD cihazı bulunamadı')
        else
          ...(_pairedDevices.map((device) => _buildDeviceTile(device))),

        const SizedBox(height: 24),

        // Tarama
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '🔍 Yakındaki Cihazlar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: _isScanning ? _stopScan : _startScan,
              icon: Icon(_isScanning ? Icons.stop : Icons.search),
              label: Text(_isScanning ? 'Durdur' : 'Tara'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_isScanning) const LinearProgressIndicator(),

        // Classic Bluetooth cihazlar
        ...(_discoveredDevices
            .map((result) => _buildDeviceTile(result.device, result.rssi))),

        // BLE cihazlar
        ...(_bleDevices.map((result) => _buildBLEDeviceTile(result))),

        if (_discoveredDevices.isEmpty && _bleDevices.isEmpty && !_isScanning)
          _buildEmptyState('Yakında cihaz bulunamadı. Taramayı başlatın.'),
      ],
    );
  }

  Widget _buildBLEDeviceTile(fbp.ScanResult result) {
    final name = result.device.platformName;
    final isOBD = name.toLowerCase().contains('obd') ||
        name.toLowerCase().contains('elm') ||
        name.toLowerCase().contains('mucar');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isOBD ? Colors.cyan.withOpacity(0.1) : Colors.purple.withOpacity(0.05),
      child: ListTile(
        leading: Icon(
          Icons.bluetooth_searching,
          color: isOBD ? Colors.cyan : Colors.purple[300],
        ),
        title: Row(
          children: [
            Expanded(child: Text(name.isEmpty ? 'BLE Cihaz' : name)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('BLE', style: TextStyle(fontSize: 10, color: Colors.cyan)),
            ),
          ],
        ),
        subtitle: Text(
          '${result.device.remoteId} | RSSI: ${result.rssi} dBm',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: ElevatedButton(
          onPressed: () => _connectToBLEDevice(result.device),
          child: const Text('Bağlan'),
        ),
      ),
    );
  }

  Widget _buildDeviceTile(BluetoothDevice device, [int? rssi]) {
    final isOBD = (device.name?.toLowerCase() ?? '').contains('obd') ||
        (device.name?.toLowerCase() ?? '').contains('elm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isOBD ? Colors.blue.withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(
          Icons.bluetooth,
          color: isOBD ? Colors.blue : Colors.grey,
        ),
        title: Text(device.name ?? 'Bilinmeyen Cihaz'),
        subtitle: Text(
          device.address + (rssi != null ? ' (${rssi}dBm)' : ''),
          style: TextStyle(color: Colors.grey[500]),
        ),
        trailing: ElevatedButton(
          onPressed: _connectionState == OBDConnectionState.connecting
              ? null
              : () => _connectToDevice(device),
          child: const Text('Bağlan'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[500]),
        textAlign: TextAlign.center,
      ),
    );
  }
}
