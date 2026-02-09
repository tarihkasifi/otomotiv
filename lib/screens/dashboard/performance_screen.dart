// Performans Ekranı - 0-100, 0-200, 1/4 Mile
import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/obd_service.dart';
import '../../utils/responsive.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  final OBDService _obdService = OBDService();

  double _speed = 0;
  double _rpm = 0;
  double _gForce = 0;

  // Performance test
  bool _isTestRunning = false;
  String _testType = '';
  double _testTime = 0;
  Timer? _testTimer;
  Timer? _dataTimer;

  // Records
  double _best0to100 = 0;
  double _best0to200 = 0;
  double _bestQuarterMile = 0;

  @override
  void initState() {
    super.initState();
    _startDataReading();
  }

  @override
  void dispose() {
    _testTimer?.cancel();
    _dataTimer?.cancel();
    super.dispose();
  }

  void _startDataReading() {
    _dataTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (_obdService.isConnected) {
        final data = await _obdService.readLiveData();
        if (mounted) {
          setState(() {
            _speed = (data.speed ?? 0).toDouble();
            _rpm = (data.rpm ?? 0).toDouble();
          });

          // Test kontrolü
          if (_isTestRunning) {
            _checkTestCompletion();
          }
        }
      }
    });
  }

  void _startTest(String type) {
    if (_speed > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Test için araç durmalı!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isTestRunning = true;
      _testType = type;
      _testTime = 0;
    });

    _testTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _testTime += 0.01;
        });
      }
    });
  }

  void _checkTestCompletion() {
    double targetSpeed = 0;

    switch (_testType) {
      case '0-100':
        targetSpeed = 100;
        break;
      case '0-200':
        targetSpeed = 200;
        break;
      case 'quarter':
        // 402 metre - basitleştirilmiş
        targetSpeed = 160;
        break;
    }

    if (_speed >= targetSpeed) {
      _stopTest();
    }
  }

  void _stopTest() {
    _testTimer?.cancel();

    setState(() {
      _isTestRunning = false;

      // Rekor kontrolü
      switch (_testType) {
        case '0-100':
          if (_best0to100 == 0 || _testTime < _best0to100) {
            _best0to100 = _testTime;
          }
          break;
        case '0-200':
          if (_best0to200 == 0 || _testTime < _best0to200) {
            _best0to200 = _testTime;
          }
          break;
        case 'quarter':
          if (_bestQuarterMile == 0 || _testTime < _bestQuarterMile) {
            _bestQuarterMile = _testTime;
          }
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('✅ $_testType Tamamlandı: ${_testTime.toStringAsFixed(2)}s'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('PERFORMANS',
            style: TextStyle(letterSpacing: 2, fontSize: isSmall ? 14 : 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: DesktopContentWrapper(
            child: Column(
              children: [
                // Canlı hız
                _buildSpeedDisplay(isSmall),

                // G-Force göstergesi
                _buildGForceDisplay(isSmall),

                // Test butonları
                _buildTestButtons(isSmall),

                // Rekorlar
                _buildRecords(isSmall),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedDisplay(bool isSmall) {
    final speedFontSize = isSmall ? 56.0 : 80.0;
    final timeFontSize = isSmall ? 28.0 : 36.0;

    return Container(
      margin: EdgeInsets.all(isSmall ? 10 : 16),
      padding: EdgeInsets.all(isSmall ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF0D0D1A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isTestRunning ? Colors.green : const Color(0xFF333355),
          width: 2,
        ),
        boxShadow: [
          if (_isTestRunning)
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
        ],
      ),
      child: Column(
        children: [
          if (_isTestRunning)
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 12 : 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_testType TEST',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: isSmall ? 12 : 14),
              ),
            ),
          SizedBox(height: isSmall ? 10 : 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_speed.toInt()}',
                  style: TextStyle(
                    color: _isTestRunning ? Colors.green : Colors.white,
                    fontSize: speedFontSize,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'monospace',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: isSmall ? 10 : 16),
                  child: Text(
                    ' km/h',
                    style: TextStyle(
                        color: Colors.grey, fontSize: isSmall ? 18 : 24),
                  ),
                ),
              ],
            ),
          ),
          if (_isTestRunning)
            Text(
              '${_testTime.toStringAsFixed(2)} s',
              style: TextStyle(
                color: Colors.green,
                fontSize: timeFontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGForceDisplay(bool isSmall) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isSmall ? 10 : 16),
      padding: EdgeInsets.all(isSmall ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              child: _buildGForceItem('İVME', '+${_gForce.toStringAsFixed(2)}',
                  'g', Colors.cyan, isSmall)),
          Container(
              width: 1, height: isSmall ? 30 : 40, color: Colors.grey[700]),
          Flexible(
              child: _buildGForceItem(
                  'RPM', '${_rpm.toInt()}', '', Colors.green, isSmall)),
          Container(
              width: 1, height: isSmall ? 30 : 40, color: Colors.grey[700]),
          Flexible(
              child:
                  _buildGForceItem('GÜÇ', '---', 'hp', Colors.orange, isSmall)),
        ],
      ),
    );
  }

  Widget _buildGForceItem(
      String label, String value, String unit, Color color, bool isSmall) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: isSmall ? 18 : 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (unit.isNotEmpty)
              Text(
                ' $unit',
                style: TextStyle(
                    color: Colors.grey[500], fontSize: isSmall ? 10 : 12),
              ),
          ],
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: isSmall ? 9 : 11),
        ),
      ],
    );
  }

  Widget _buildTestButtons(bool isSmall) {
    return Padding(
      padding: EdgeInsets.all(isSmall ? 10 : 16),
      child: Column(
        children: [
          Text(
            'TEST SEÇİN',
            style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2,
                fontSize: isSmall ? 12 : 14),
          ),
          SizedBox(height: isSmall ? 10 : 16),
          Row(
            children: [
              Expanded(
                  child: _buildTestButton(
                      '0-100', '0-100 km/h', Colors.green, isSmall)),
              SizedBox(width: isSmall ? 8 : 12),
              Expanded(
                  child: _buildTestButton(
                      '0-200', '0-200 km/h', Colors.orange, isSmall)),
            ],
          ),
          SizedBox(height: isSmall ? 8 : 12),
          Row(
            children: [
              Expanded(
                  child: _buildTestButton(
                      'quarter', '1/4 Mile', Colors.red, isSmall)),
              SizedBox(width: isSmall ? 8 : 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isTestRunning ? _stopTest : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: EdgeInsets.symmetric(vertical: isSmall ? 14 : 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('İPTAL',
                      style: TextStyle(fontSize: isSmall ? 14 : 18)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton(
      String type, String label, Color color, bool isSmall) {
    final isActive = _isTestRunning && _testType == type;
    return ElevatedButton(
      onPressed: _isTestRunning ? null : () => _startTest(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? color : color.withOpacity(0.2),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: isSmall ? 14 : 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: 2),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label,
            style: TextStyle(
                fontSize: isSmall ? 14 : 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildRecords(bool isSmall) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 12 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Column(
        children: [
          Text(
            '🏆 EN İYİ REKORLAR',
            style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: isSmall ? 12 : 14),
          ),
          SizedBox(height: isSmall ? 8 : 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRecordItem('0-100', _best0to100, isSmall),
              _buildRecordItem('0-200', _best0to200, isSmall),
              _buildRecordItem('1/4 Mi', _bestQuarterMile, isSmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(String label, double time, bool isSmall) {
    return Column(
      children: [
        Text(
          time > 0 ? '${time.toStringAsFixed(2)}s' : '---',
          style: TextStyle(
            color: Colors.amber,
            fontSize: isSmall ? 16 : 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        Text(label,
            style: TextStyle(
                color: Colors.grey[500], fontSize: isSmall ? 10 : 12)),
      ],
    );
  }
}
