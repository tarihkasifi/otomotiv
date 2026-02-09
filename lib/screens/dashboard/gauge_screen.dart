// Analog Gösterge Ekranı - Yatay Çoklu Gösterge Paneli
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';
import '../../services/obd_service.dart';

class GaugeScreen extends StatefulWidget {
  const GaugeScreen({super.key});

  @override
  State<GaugeScreen> createState() => _GaugeScreenState();
}

class _GaugeScreenState extends State<GaugeScreen>
    with TickerProviderStateMixin {
  final OBDService _obdService = OBDService();

  // OBD Verileri
  double _speed = 0;
  double _rpm = 0;
  double _coolantTemp = 0;
  double _fuelLevel = 0;
  double _voltage = 0;
  double _throttle = 0;

  Timer? _dataTimer;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    // Yatay moda zorla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Tam ekran modu
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _startDataReading();
  }

  @override
  void dispose() {
    _dataTimer?.cancel();
    // Normal moda geri dön
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _startDataReading() {
    _dataTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (_obdService.isConnected) {
        final data = await _obdService.readFastData();
        if (mounted) {
          setState(() {
            if (data.speed != null) _speed = data.speed!.toDouble();
            if (data.rpm != null) _rpm = data.rpm!.toDouble();
            if (data.coolantTemp != null) _coolantTemp = data.coolantTemp!.toDouble();
            if (data.throttlePosition != null) _throttle = data.throttlePosition!.toDouble();
            if (data.batteryVoltage != null) _voltage = data.batteryVoltage!;
            if (data.fuelLevel != null) _fuelLevel = data.fuelLevel!;
            _isConnected = true;
          });
        }
      } else {
        if (mounted) setState(() => _isConnected = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Carbon fiber metalik arka plan
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              const Color(0xFF2A2A35),
              const Color(0xFF1A1A22),
              const Color(0xFF0D0D12),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Metalik çerçeve efekti
            _buildMetallicFrame(),


            // Ana içerik
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    // Sol göstergeler
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildSmallGauge(
                              'DEVİR',
                              _rpm,
                              8000,
                              'x1000',
                              const Color(0xFF00BFFF),
                              showRedZone: true,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: _buildSmallGauge(
                              'SICAKLIK',
                              _coolantTemp,
                              140,
                              '°C',
                              const Color(0xFFFF6B35),
                              showRedZone: true,
                              redZoneStart: 100,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Orta - Ana Hız Göstergesi
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildMainSpeedometer(),
                      ),
                    ),

                    // Sağ göstergeler
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildSmallGauge(
                              'GAZ',
                              _throttle,
                              100,
                              '%',
                              const Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: _buildSmallGauge(
                              'VOLTAJ',
                              _voltage,
                              16,
                              'V',
                              const Color(0xFFFFEB3B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bağlantı bekleme ekranı (en önde)
            if (!_isConnected)
              Container(
                color: const Color(0xFF0D0D12).withOpacity(0.95),
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

            // Geri butonu (en önde)
            Positioned(
              top: 12,
              left: 12,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text('GERİ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bağlantı durumu göstergesi
            Positioned(
              top: 12,
              right: 12,
              child: SafeArea(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isConnected ? Colors.green : Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: (_isConnected ? Colors.green : Colors.red)
                            .withOpacity(0.6),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetallicFrame() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 3,
          color: Colors.grey[700]!,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[600]!.withOpacity(0.3),
            Colors.grey[800]!.withOpacity(0.1),
            Colors.grey[600]!.withOpacity(0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildMainSpeedometer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: MainSpeedometerPainter(
                speed: _speed,
                maxSpeed: 260,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_speed.toInt()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'monospace',
                        letterSpacing: -2,
                      ),
                    ),
                    const Text(
                      'km/h',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallGauge(
    String label,
    double value,
    double maxValue,
    String unit,
    Color color, {
    bool showRedZone = false,
    double redZoneStart = 0,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: SmallGaugePainter(
                value: value,
                maxValue: maxValue,
                color: color,
                showRedZone: showRedZone,
                redZoneStart: redZoneStart,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label == 'DEVİR'
                          ? '${(value / 1000).toStringAsFixed(1)}'
                          : value.toStringAsFixed(label == 'VOLTAJ' ? 1 : 0),
                      style: TextStyle(
                        color: color,
                        fontSize: size * 0.22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      unit,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: size * 0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: size * 0.09,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Ana Hız Göstergesi Painter
class MainSpeedometerPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  MainSpeedometerPainter({required this.speed, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 15;

    // Dış metalik çerçeve
    _drawMetallicRing(canvas, center, radius + 10, 8);

    // Arka plan daire
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF1A1A25),
          const Color(0xFF0D0D15),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bgPaint);

    // Arc başlangıç ve bitiş açıları
    const startAngle = 135 * math.pi / 180;
    const sweepAngle = 270 * math.pi / 180;

    // Arka plan arc
    final arcBgPaint = Paint()
      ..color = const Color(0xFF333340)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final arcRect = Rect.fromCircle(center: center, radius: radius - 20);
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, arcBgPaint);

    // Aktif arc - gradient
    final speedRatio = (speed / maxSpeed).clamp(0.0, 1.0);
    final activeAngle = sweepAngle * speedRatio;

    if (activeAngle > 0) {
      final arcPaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: const [
            Color(0xFF00FF00),
            Color(0xFFFFFF00),
            Color(0xFFFF6600),
            Color(0xFFFF0000),
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ).createShader(arcRect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(arcRect, startAngle, activeAngle, false, arcPaint);
    }

    // Tick işaretleri ve sayılar
    _drawTicks(canvas, center, radius - 20, startAngle, sweepAngle);

    // İbre
    _drawNeedle(canvas, center, radius - 35, startAngle + activeAngle);
  }

  void _drawMetallicRing(
      Canvas canvas, Offset center, double radius, double width) {
    final ringPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.grey[400]!,
          Colors.grey[700]!,
          Colors.grey[400]!,
          Colors.grey[600]!,
          Colors.grey[400]!,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    canvas.drawCircle(center, radius, ringPaint);
  }

  void _drawTicks(Canvas canvas, Offset center, double radius,
      double startAngle, double sweepAngle) {
    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    final smallTickPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 1;

    for (int i = 0; i <= 26; i++) {
      final angle = startAngle + (sweepAngle / 26) * i;
      final isMajor = i % 2 == 0;
      final innerRadius = isMajor ? radius - 15 : radius - 8;
      final outerRadius = radius;

      final x1 = center.dx + innerRadius * math.cos(angle);
      final y1 = center.dy + innerRadius * math.sin(angle);
      final x2 = center.dx + outerRadius * math.cos(angle);
      final y2 = center.dy + outerRadius * math.sin(angle);

      canvas.drawLine(
          Offset(x1, y1), Offset(x2, y2), isMajor ? tickPaint : smallTickPaint);

      // Sayılar (her 20 km/h)
      if (i % 2 == 0) {
        final textRadius = radius - 30;
        final textX = center.dx + textRadius * math.cos(angle);
        final textY = center.dy + textRadius * math.sin(angle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '${(i * 10)}',
            style: TextStyle(
              color: i >= 22 ? Colors.red[400] : Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(canvas, Offset(textX - 8, textY - 6));
      }
    }
  }

  void _drawNeedle(Canvas canvas, Offset center, double length, double angle) {
    // Gölge
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final shadowEnd = Offset(
      center.dx + length * math.cos(angle) + 2,
      center.dy + length * math.sin(angle) + 2,
    );
    canvas.drawLine(center, shadowEnd, shadowPaint..strokeWidth = 4);

    // Ana ibre
    final needlePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red[900]!, Colors.red],
      ).createShader(
          Rect.fromPoints(center, Offset(center.dx + length, center.dy)))
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + length * math.cos(angle),
      center.dy + length * math.sin(angle),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // Merkez nokta
    final centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.grey[400]!, Colors.grey[800]!],
      ).createShader(Rect.fromCircle(center: center, radius: 12));
    canvas.drawCircle(center, 12, centerPaint);

    canvas.drawCircle(center, 6, Paint()..color = Colors.red[800]!);
  }

  @override
  bool shouldRepaint(covariant MainSpeedometerPainter oldDelegate) {
    return oldDelegate.speed != speed;
  }
}

// Küçük Gösterge Painter
class SmallGaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  final Color color;
  final bool showRedZone;
  final double redZoneStart;

  SmallGaugePainter({
    required this.value,
    required this.maxValue,
    required this.color,
    this.showRedZone = false,
    this.redZoneStart = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Metalik çerçeve
    final ringPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.grey[500]!,
          Colors.grey[700]!,
          Colors.grey[500]!,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 4))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius + 2, ringPaint);

    // Arka plan
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF1F1F2A),
          const Color(0xFF12121A),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bgPaint);

    // Arc parametreleri
    const startAngle = 135 * math.pi / 180;
    const sweepAngle = 270 * math.pi / 180;
    final arcRect = Rect.fromCircle(center: center, radius: radius - 10);

    // Arka plan arc
    final arcBgPaint = Paint()
      ..color = const Color(0xFF333340)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, arcBgPaint);

    // Red zone
    if (showRedZone && redZoneStart > 0) {
      final redStartRatio = redZoneStart / maxValue;
      final redStartAngle = startAngle + sweepAngle * redStartRatio;
      final redSweepAngle = sweepAngle * (1 - redStartRatio);

      final redPaint = Paint()
        ..color = Colors.red.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(arcRect, redStartAngle, redSweepAngle, false, redPaint);
    }

    // Aktif arc
    final valueRatio = (value / maxValue).clamp(0.0, 1.0);
    final activeAngle = sweepAngle * valueRatio;

    if (activeAngle > 0) {
      final arcPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(arcRect, startAngle, activeAngle, false, arcPaint);
    }

    // İbre
    final needleAngle = startAngle + activeAngle;
    final needleLength = radius - 20;

    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // Merkez nokta
    canvas.drawCircle(center, 5, Paint()..color = Colors.grey[600]!);
    canvas.drawCircle(center, 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant SmallGaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
