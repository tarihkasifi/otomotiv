// Cihaz Geçmişi Servisi - Kalıcı Kayıt
// Uygulama kaldırılsa bile veriler korunur (harici depolamada saklanır)
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DeviceHistory {
  final String deviceName;
  final String deviceAddress;
  final String? vehicleName;
  final String? vin;
  final String? manufacturer;
  final DateTime firstConnected;
  final DateTime lastConnected;
  final int connectionCount;
  final double totalDistance; // km
  final int totalSessionSeconds;

  DeviceHistory({
    required this.deviceName,
    required this.deviceAddress,
    this.vehicleName,
    this.vin,
    this.manufacturer,
    required this.firstConnected,
    required this.lastConnected,
    this.connectionCount = 1,
    this.totalDistance = 0,
    this.totalSessionSeconds = 0,
  });

  Map<String, dynamic> toJson() => {
        'deviceName': deviceName,
        'deviceAddress': deviceAddress,
        'vehicleName': vehicleName,
        'vin': vin,
        'manufacturer': manufacturer,
        'firstConnected': firstConnected.toIso8601String(),
        'lastConnected': lastConnected.toIso8601String(),
        'connectionCount': connectionCount,
        'totalDistance': totalDistance,
        'totalSessionSeconds': totalSessionSeconds,
      };

  factory DeviceHistory.fromJson(Map<String, dynamic> json) => DeviceHistory(
        deviceName: json['deviceName'] ?? '',
        deviceAddress: json['deviceAddress'] ?? '',
        vehicleName: json['vehicleName'],
        vin: json['vin'],
        manufacturer: json['manufacturer'],
        firstConnected: DateTime.parse(json['firstConnected']),
        lastConnected: DateTime.parse(json['lastConnected']),
        connectionCount: json['connectionCount'] ?? 1,
        totalDistance: (json['totalDistance'] ?? 0).toDouble(),
        totalSessionSeconds: json['totalSessionSeconds'] ?? 0,
      );

  DeviceHistory copyWith({
    String? vehicleName,
    String? vin,
    String? manufacturer,
    DateTime? lastConnected,
    int? connectionCount,
    double? totalDistance,
    int? totalSessionSeconds,
  }) =>
      DeviceHistory(
        deviceName: deviceName,
        deviceAddress: deviceAddress,
        vehicleName: vehicleName ?? this.vehicleName,
        vin: vin ?? this.vin,
        manufacturer: manufacturer ?? this.manufacturer,
        firstConnected: firstConnected,
        lastConnected: lastConnected ?? this.lastConnected,
        connectionCount: connectionCount ?? this.connectionCount,
        totalDistance: totalDistance ?? this.totalDistance,
        totalSessionSeconds: totalSessionSeconds ?? this.totalSessionSeconds,
      );
}

class DeviceHistoryService {
  static const String _fileName = 'eray_auto_device_history.json';
  static List<DeviceHistory> _cache = [];
  static bool _initialized = false;

  /// Harici depolamada kalıcı dosya yolu al
  static Future<File> _getFile() async {
    // Harici depolama kullan (uygulama kaldırılsa bile kalır)
    Directory? dir;
    try {
      dir = await getExternalStorageDirectory();
    } catch (_) {}

    // Harici depolama yoksa dahili depolamada sakla
    dir ??= await getApplicationDocumentsDirectory();

    // Uygulamaya özel klasör oluştur (harici depolamada)
    final appDir = Directory('${dir.parent.parent.parent.parent.path}/ErayAuto');
    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }

    return File('${appDir.path}/$_fileName');
  }

  /// Tüm geçmişi yükle
  static Future<List<DeviceHistory>> loadHistory() async {
    if (_initialized) return _cache;

    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(content);
        _cache = jsonList.map((e) => DeviceHistory.fromJson(e)).toList();
      }
    } catch (e) {
      print('📋 [History] Yükleme hatası: $e');
      _cache = [];
    }

    _initialized = true;
    return _cache;
  }

  /// Geçmişi kaydet
  static Future<void> _save() async {
    try {
      final file = await _getFile();
      final jsonList = _cache.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
      print('📋 [History] ${_cache.length} cihaz kaydedildi');
    } catch (e) {
      print('📋 [History] Kaydetme hatası: $e');
    }
  }

  /// Yeni bağlantı kaydet veya mevcut kaydı güncelle
  static Future<void> recordConnection({
    required String deviceName,
    required String deviceAddress,
    String? vehicleName,
    String? vin,
    String? manufacturer,
  }) async {
    await loadHistory(); // cache'i yükle

    final existingIndex =
        _cache.indexWhere((h) => h.deviceAddress == deviceAddress);

    if (existingIndex >= 0) {
      // Mevcut kaydı güncelle
      final existing = _cache[existingIndex];
      _cache[existingIndex] = existing.copyWith(
        vehicleName: vehicleName ?? existing.vehicleName,
        vin: vin ?? existing.vin,
        manufacturer: manufacturer ?? existing.manufacturer,
        lastConnected: DateTime.now(),
        connectionCount: existing.connectionCount + 1,
      );
      print('📋 [History] Güncellendi: $deviceName (${existing.connectionCount + 1}. bağlantı)');
    } else {
      // Yeni kayıt
      _cache.add(DeviceHistory(
        deviceName: deviceName,
        deviceAddress: deviceAddress,
        vehicleName: vehicleName,
        vin: vin,
        manufacturer: manufacturer,
        firstConnected: DateTime.now(),
        lastConnected: DateTime.now(),
      ));
      print('📋 [History] Yeni kayıt: $deviceName');
    }

    await _save();
  }

  /// Oturum verilerini güncelle
  static Future<void> updateSessionData({
    required String deviceAddress,
    double distanceKm = 0,
    int sessionSeconds = 0,
  }) async {
    await loadHistory();

    final existingIndex =
        _cache.indexWhere((h) => h.deviceAddress == deviceAddress);

    if (existingIndex >= 0) {
      final existing = _cache[existingIndex];
      _cache[existingIndex] = existing.copyWith(
        totalDistance: existing.totalDistance + distanceKm,
        totalSessionSeconds: existing.totalSessionSeconds + sessionSeconds,
      );
      await _save();
    }
  }

  /// Belirli bir cihaz geçmişini sil
  static Future<void> deleteDevice(String deviceAddress) async {
    await loadHistory();
    _cache.removeWhere((h) => h.deviceAddress == deviceAddress);
    await _save();
  }

  /// Tüm geçmişi sil
  static Future<void> clearAll() async {
    _cache.clear();
    _initialized = true;
    await _save();
  }

  /// Son bağlanan cihazı al
  static Future<DeviceHistory?> getLastConnected() async {
    final history = await loadHistory();
    if (history.isEmpty) return null;
    history.sort((a, b) => b.lastConnected.compareTo(a.lastConnected));
    return history.first;
  }
}
