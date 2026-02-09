// Yarışlar Ekranı - Lap Timer
import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/obd_service.dart';
import '../../utils/responsive.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  final OBDService _obdService = OBDService();

  bool _isRacing = false;
  int _lapCount = 0;
  List<Duration> _lapTimes = [];
  Duration _currentLapTime = Duration.zero;
  Duration _totalTime = Duration.zero;
  Timer? _raceTimer;

  double _speed = 0;
  double _rpm = 0;
  Timer? _dataTimer;

  @override
  void initState() {
    super.initState();
    _startDataReading();
  }

  @override
  void dispose() {
    _raceTimer?.cancel();
    _dataTimer?.cancel();
    super.dispose();
  }

  void _startDataReading() {
    _dataTimer =
        Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      if (_obdService.isConnected) {
        final data = await _obdService.readLiveData();
        if (mounted) {
          setState(() {
            _speed = (data.speed ?? 0).toDouble();
            _rpm = (data.rpm ?? 0).toDouble();
          });
        }
      }
    });
  }

  void _startRace() {
    setState(() {
      _isRacing = true;
      _lapCount = 0;
      _lapTimes.clear();
      _currentLapTime = Duration.zero;
      _totalTime = Duration.zero;
    });

    _raceTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentLapTime += const Duration(milliseconds: 10);
          _totalTime += const Duration(milliseconds: 10);
        });
      }
    });
  }

  void _recordLap() {
    if (!_isRacing) return;

    setState(() {
      _lapTimes.add(_currentLapTime);
      _lapCount++;
      _currentLapTime = Duration.zero;
    });
  }

  void _stopRace() {
    _raceTimer?.cancel();

    if (_currentLapTime > Duration.zero) {
      setState(() {
        _lapTimes.add(_currentLapTime);
        _lapCount++;
      });
    }

    setState(() {
      _isRacing = false;
    });
  }

  void _resetRace() {
    _raceTimer?.cancel();
    setState(() {
      _isRacing = false;
      _lapCount = 0;
      _lapTimes.clear();
      _currentLapTime = Duration.zero;
      _totalTime = Duration.zero;
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final milliseconds =
        (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$milliseconds';
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
        title: const Text('YARIŞLAR', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetRace,
          ),
        ],
      ),
      body: DesktopContentWrapper(
        child: Column(
          children: [
            // Canlı hız
            _buildSpeedDisplay(),

            // Timer
            _buildTimerDisplay(),

            // Kontroller
            _buildControls(),

            // Turlar listesi
            Expanded(child: _buildLapsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedDisplay() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _isRacing
                ? Colors.red.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            const Color(0xFF1A1A2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isRacing
              ? Colors.red.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                '${_speed.toInt()}',
                style: TextStyle(
                  color: _isRacing ? Colors.red : Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              const Text('km/h', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Container(width: 1, height: 60, color: Colors.grey[700]),
          Column(
            children: [
              Text(
                '${_rpm.toInt()}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              const Text('RPM', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isRacing ? Colors.green : Colors.grey[700]!,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Toplam süre
          Text(
            _formatDuration(_totalTime),
            style: TextStyle(
              color: _isRacing ? Colors.green : Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w200,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          const Text('TOPLAM SÜRE',
              style: TextStyle(color: Colors.grey, letterSpacing: 2)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    _formatDuration(_currentLapTime),
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const Text('Mevcut Tur',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$_lapCount',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Tur Sayısı',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isRacing ? _stopRace : _startRace,
              icon: Icon(_isRacing ? Icons.stop : Icons.play_arrow),
              label: Text(_isRacing ? 'DURDUR' : 'BAŞLAT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRacing ? Colors.red : Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isRacing ? _recordLap : null,
              icon: const Icon(Icons.flag),
              label: const Text('TUR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLapsList() {
    if (_lapTimes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag, size: 60, color: Colors.grey[700]),
            const SizedBox(height: 16),
            Text(
              'Henüz tur kaydedilmedi',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    // En iyi tur
    final bestLapIndex = _lapTimes
        .asMap()
        .entries
        .reduce(
          (a, b) => a.value < b.value ? a : b,
        )
        .key;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _lapTimes.length,
      itemBuilder: (context, index) {
        final lapTime = _lapTimes[index];
        final isBest = index == bestLapIndex && _lapTimes.length > 1;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isBest
                ? Colors.green.withOpacity(0.2)
                : const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isBest ? Colors.green : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isBest ? Colors.green : Colors.grey[700],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tur ${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    if (isBest)
                      const Text(
                        '🏆 En İyi Tur',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                  ],
                ),
              ),
              Text(
                _formatDuration(lapTime),
                style: TextStyle(
                  color: isBest ? Colors.green : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
