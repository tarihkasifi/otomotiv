// Veri Grid Ekranı - Tüm OBD Parametreleri
import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/obd_service.dart';
import '../../utils/responsive.dart';

class DataGridScreen extends StatefulWidget {
  const DataGridScreen({super.key});

  @override
  State<DataGridScreen> createState() => _DataGridScreenState();
}

class _DataGridScreenState extends State<DataGridScreen> {
  final OBDService _obdService = OBDService();
  Timer? _dataTimer;
  bool _isConnected = false;

  // Tüm veriler
  Map<String, dynamic> _data = {
    'speed': 0,
    'rpm': 0,
    'coolantTemp': 0,
    'throttle': 0.0,
    'engineLoad': 0.0,
    'fuelLevel': 0.0,
    'intakeTemp': 0,
    'maf': 0.0,
    'timing': 0.0,
    'fuelPressure': 0,
    'batteryVoltage': 0.0,
    'oilTemp': 0,
  };

  @override
  void initState() {
    super.initState();
    _startDataReading();
  }

  @override
  void dispose() {
    _dataTimer?.cancel();
    super.dispose();
  }

  void _startDataReading() {
    _dataTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (_obdService.isConnected) {
        final data = await _obdService.readLiveData();
        if (mounted) {
          setState(() {
            _isConnected = true;
            if (data.speed != null) _data['speed'] = data.speed!;
            if (data.rpm != null) _data['rpm'] = data.rpm!;
            if (data.coolantTemp != null) _data['coolantTemp'] = data.coolantTemp!;
            if (data.throttlePosition != null) _data['throttle'] = data.throttlePosition!;
            if (data.engineLoad != null) _data['engineLoad'] = data.engineLoad!;
            if (data.fuelLevel != null) _data['fuelLevel'] = data.fuelLevel!;
            if (data.intakeTemp != null) _data['intakeTemp'] = data.intakeTemp!;
            if (data.maf != null) _data['maf'] = data.maf!;
            if (data.timingAdvance != null) _data['timing'] = data.timingAdvance!;
            if (data.fuelPressure != null) _data['fuelPressure'] = data.fuelPressure!;
            if (data.batteryVoltage != null) _data['batteryVoltage'] = data.batteryVoltage!;
            if (data.oilTemp != null) _data['oilTemp'] = data.oilTemp!;
          });
        }
      } else {
        if (mounted) setState(() => _isConnected = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final isSmall = Responsive.isSmallScreen;
    final crossAxisCount = Responsive.isDesktop ? 4 : (Responsive.isTablet ? 4 : (isSmall ? 2 : (Responsive.screenWidth > 500 ? 3 : 2)));
    final aspectRatio = Responsive.isDesktop ? 1.5 : (Responsive.isTablet ? 1.4 : (isSmall ? 1.1 : 1.3));
    final gridSpacing = Responsive.padding(isSmall ? 8 : 12);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('VERİ GRİDİ',
            style: TextStyle(letterSpacing: 2, fontSize: isSmall ? 14 : 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _obdService.isConnected
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_disabled,
              color: _obdService.isConnected ? Colors.green : Colors.red,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isSmall ? 8 : 12),
              child: GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: gridSpacing,
            mainAxisSpacing: gridSpacing,
            childAspectRatio: aspectRatio,
            children: [
              _buildDataTile('HIZ', '${_data['speed']}', 'km/h', Icons.speed,
                  Colors.cyan, isSmall),
              _buildDataTile('DEVİR', '${_data['rpm']}', 'RPM',
                  Icons.rotate_right, Colors.green, isSmall),
              _buildDataTile(
                  'MOTOR SICAKLIK',
                  '${_data['coolantTemp']}',
                  '°C',
                  Icons.thermostat,
                  (_data['coolantTemp'] as int) > 100
                      ? Colors.red
                      : Colors.orange,
                  isSmall),
              _buildDataTile(
                  'GAZ KELEBEK',
                  '${(_data['throttle'] as double).toInt()}',
                  '%',
                  Icons.linear_scale,
                  Colors.purple,
                  isSmall),
              _buildDataTile(
                  'MOTOR YÜKÜ',
                  '${(_data['engineLoad'] as double).toInt()}',
                  '%',
                  Icons.trending_up,
                  Colors.blue,
                  isSmall),
              _buildDataTile(
                  'YAKIT SEVİYE',
                  '${(_data['fuelLevel'] as double).toInt()}',
                  '%',
                  Icons.local_gas_station,
                  Colors.amber,
                  isSmall),
              _buildDataTile('EMİŞ SICAKLIK', '${_data['intakeTemp']}', '°C',
                  Icons.air, Colors.teal, isSmall),
              _buildDataTile(
                  'HAVA AKIŞ',
                  '${(_data['maf'] as double).toStringAsFixed(1)}',
                  'g/s',
                  Icons.waves,
                  Colors.indigo,
                  isSmall),
              _buildDataTile(
                  'ATEŞLEME',
                  '${(_data['timing'] as double).toStringAsFixed(1)}',
                  '°',
                  Icons.flash_on,
                  Colors.yellow,
                  isSmall),
              _buildDataTile('YAKIT BASINÇ', '${_data['fuelPressure']}', 'kPa',
                  Icons.compress, Colors.pink, isSmall),
              _buildDataTile(
                  'AKÜ VOLTAJ',
                  '${(_data['batteryVoltage'] as double).toStringAsFixed(1)}',
                  'V',
                  Icons.battery_charging_full,
                  Colors.lime,
                  isSmall),
              _buildDataTile('YAĞ SICAKLIK', '${_data['oilTemp']}', '°C',
                  Icons.opacity, Colors.brown, isSmall),
            ],
          ),
            ),
          ),

          // Bağlantı bekleme ekranı
          if (!_isConnected)
            Container(
              color: const Color(0xFF0A0A15).withOpacity(0.85),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.bluetooth_searching,
                          color: Colors.cyan, size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Veri bekleniyor...',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'OBD cihazına bağlanınca veriler otomatik görünecektir',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.cyan, strokeWidth: 2),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataTile(String label, String value, String unit, IconData icon,
      Color color, bool isSmall) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            const Color(0xFF1A1A2E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 8 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: isSmall ? 16 : 20),
                SizedBox(width: isSmall ? 4 : 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isSmall ? 9 : 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: isSmall ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  SizedBox(width: isSmall ? 2 : 4),
                  Padding(
                    padding: EdgeInsets.only(bottom: isSmall ? 2 : 4),
                    child: Text(
                      unit,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: isSmall ? 10 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
