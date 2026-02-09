// Araç Bilgi Ekranı - VIN Tespiti ve Oturum İstatistikleri
import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/obd_service.dart';
import '../../services/vehicle_image_service.dart';
import '../../utils/responsive.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final OBDService _obdService = OBDService();

  // Araç bilgileri
  String _vehicleName = 'Tespit Ediliyor...';
  String _vinCode = 'Okunuyor...';
  String? _vehicleLogoUrl;
  String _year = '---';
  String _manufacturer = '---';

  // Oturum istatistikleri
  DateTime? _sessionStart;
  Timer? _sessionTimer;
  int _sessionSeconds = 0;
  double _totalDistance = 0;
  double _maxSpeed = 0;
  double _avgSpeedSum = 0;
  int _avgSpeedCount = 0;
  int _lastSpeed = 0;

  // Canlı veri
  Timer? _dataTimer;
  bool _isDetecting = true;

  @override
  void initState() {
    super.initState();
    _startSession();
    _detectVehicle();
    _startLiveStats();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _dataTimer?.cancel();
    super.dispose();
  }

  void _startSession() {
    _sessionStart = DateTime.now();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _sessionSeconds++;
        });
      }
    });
  }

  Future<void> _detectVehicle() async {
    if (!_obdService.isConnected) {
      setState(() {
        _vehicleName = 'OBD Bağlı Değil';
        _vinCode = '---';
        _isDetecting = false;
      });
      return;
    }

    // VIN oku
    String? vin;
    try {
      vin = await _obdService.getVin();
    } catch (e) {
      // VIN okunamadı
    }

    // Araç bilgilerini al
    final deviceName = _obdService.connectedDeviceName;
    final imageResult = await VehicleImageService.getVehicleImage(vin, deviceName);

    if (mounted) {
      setState(() {
        _isDetecting = false;
        _vinCode = vin ?? 'Okunamadı';

        if (imageResult.manufacturer != null) {
          _vehicleName = imageResult.displayName;
          _manufacturer = imageResult.manufacturer!;
          _vehicleLogoUrl = imageResult.logoUrl;

          // VIN'den yıl çıkar (10. karakter)
          if (vin != null && vin.length >= 10) {
            _year = _decodeVinYear(vin[9]);
          }
        } else {
          _vehicleName = 'OBD Bağlı Araç';
          _manufacturer = deviceName ?? '---';
        }
      });
    }
  }

  String _decodeVinYear(String char) {
    const yearMap = {
      'A': 2010, 'B': 2011, 'C': 2012, 'D': 2013,
      'E': 2014, 'F': 2015, 'G': 2016, 'H': 2017,
      'J': 2018, 'K': 2019, 'L': 2020, 'M': 2021,
      'N': 2022, 'P': 2023, 'R': 2024, 'S': 2025,
      'T': 2026, 'V': 2027, 'W': 2028, 'X': 2029,
      'Y': 2030, '1': 2031, '2': 2032, '3': 2033,
      '4': 2034, '5': 2035, '6': 2036, '7': 2037,
      '8': 2038, '9': 2039,
    };

    final year = yearMap[char.toUpperCase()];
    if (year != null) {
      // 30 yıllık döngü kontrolü
      // Eğer yıl gelecekteyse (örn: şu an 2026 iken 2035 çıkarsa),
      // bu aslında bir önceki döngüdür (2005)
      final currentYear = DateTime.now().year;
      if (year > currentYear + 1) {
        return (year - 30).toString();
      }
      return year.toString();
    }
    return '---';
  }

  void _startLiveStats() {
    _dataTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
      if (_obdService.isConnected) {
        try {
          final data = await _obdService.readFastData();
          if (mounted && data.speed != null) {
            setState(() {
              final speed = data.speed!;
              _lastSpeed = speed;

              // Mesafe hesapla (hız × zaman)
              _totalDistance += (speed / 3600) * 2; // 2 saniyede gidilen km

              // Max hız
              if (speed > _maxSpeed) _maxSpeed = speed.toDouble();

              // Ortalama hız
              if (speed > 0) {
                _avgSpeedSum += speed;
                _avgSpeedCount++;
              }
            });
          }
        } catch (_) {}
      }
    });
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours}sa ${minutes}dk';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ARAÇ', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
        actions: [
          if (_obdService.isConnected)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.cyan),
              onPressed: () {
                setState(() => _isDetecting = true);
                _detectVehicle();
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: DesktopContentWrapper(
            child: Column(
              children: [
                // Araç görseli
                _buildVehicleImage(),
                const SizedBox(height: 24),

                // Araç bilgileri
                _buildInfoSection('ARAÇ BİLGİLERİ', [
                  _buildInfoRow(
                      'Marka / Model', _vehicleName, Icons.directions_car),
                  _buildInfoRow('VIN', _vinCode, Icons.qr_code,
                      valueColor: _vinCode == 'Okunamadı'
                          ? Colors.orange
                          : Colors.white),
                  _buildInfoRow('Yıl', _year, Icons.calendar_today),
                  _buildInfoRow('Üretici', _manufacturer, Icons.factory),
                ]),
                const SizedBox(height: 16),

                // Bağlantı bilgileri
                _buildInfoSection('BAĞLANTI', [
                  _buildInfoRow(
                    'OBD Durumu',
                    _obdService.isConnected ? 'Bağlı' : 'Bağlı Değil',
                    Icons.bluetooth,
                    valueColor:
                        _obdService.isConnected ? Colors.green : Colors.red,
                  ),
                  _buildInfoRow('Protokol', 'OBD-II (AUTO)', Icons.settings_ethernet),
                  _buildInfoRow(
                      'Cihaz',
                      _obdService.connectedDeviceName,
                      Icons.device_hub),
                ]),
                const SizedBox(height: 16),

                // İstatistikler
                _buildStatsSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleImage() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.2),
            const Color(0xFF1A1A2E),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: _isDetecting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.cyan),
                  SizedBox(height: 12),
                  Text(
                    'Araç Tespit Ediliyor...',
                    style: TextStyle(color: Colors.cyan, fontSize: 14),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_obdService.isConnected)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/araba.png',
                          height: 90,
                          width: 140,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.directions_car,
                              size: 70,
                              color: Colors.blue.withOpacity(0.5),
                            );
                          },
                        ),
                        if (_vehicleLogoUrl != null)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A2E),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                              ),
                              child: Image.network(
                                _vehicleLogoUrl!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.verified, color: Colors.cyan, size: 16);
                                },
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    Icon(
                      Icons.directions_car,
                      size: 70,
                      color: Colors.blue.withOpacity(0.5),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _vehicleName,
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_vinCode != 'Okunamadı' && _vinCode != '---')
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _vinCode,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                          letterSpacing: 1,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[400])),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final avgSpeed = _avgSpeedCount > 0 ? (_avgSpeedSum / _avgSpeedCount) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OTURUM İSTATİSTİKLERİ',
            style:
                TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      'MESAFE',
                      _totalDistance < 1
                          ? '${(_totalDistance * 1000).toInt()}'
                          : _totalDistance.toStringAsFixed(1),
                      _totalDistance < 1 ? 'm' : 'km',
                      Colors.cyan)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildStatCard(
                      'SÜRE',
                      _formatDuration(_sessionSeconds),
                      '',
                      Colors.green)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildStatCard('ORT HIZ',
                      '${avgSpeed.toInt()}', 'km/h', Colors.orange)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('MAX HIZ',
                      '${_maxSpeed.toInt()}', 'km/h', Colors.red)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildStatCard('ANLİK HIZ',
                      '$_lastSpeed', 'km/h', Colors.blue)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildStatCard('OKUMA',
                      '$_avgSpeedCount', 'adet', Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (unit.isNotEmpty)
            Text(unit, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 9)),
        ],
      ),
    );
  }
}
