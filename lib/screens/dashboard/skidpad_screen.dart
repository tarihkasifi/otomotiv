// Kayma Padi Ekranı - G-Force Göstergesi
import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../services/obd_service.dart';

class SkidpadScreen extends StatefulWidget {
  const SkidpadScreen({super.key});

  @override
  State<SkidpadScreen> createState() => _SkidpadScreenState();
}

class _SkidpadScreenState extends State<SkidpadScreen> {
  final OBDService _obdService = OBDService();

  double _lateralG = 0;
  double _longitudinalG = 0;
  double _maxLateralG = 0;
  double _maxLongitudinalG = 0;

  Timer? _dataTimer;

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
    _dataTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      // Demo: Simüle edilmiş G-force değerleri
      // Gerçek uygulamada ivmeölçer sensöründen okunur
      if (mounted) {
        setState(() {
          // Simülasyon için rastgele değerler
          // Gerçek uygulama için accelerometer paketini kullanın
        });
      }
    });
  }

  void _resetMax() {
    setState(() {
      _maxLateralG = 0;
      _maxLongitudinalG = 0;
    });
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
        title: const Text('G-FORCE', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetMax,
          ),
        ],
      ),
      body: DesktopContentWrapper(
        child: Column(
          children: [
            // G-Force göstergesi
            Expanded(
              flex: 3,
              child: Center(
                child: _buildGForceDisplay(),
              ),
            ),

            // Değerler
            _buildGForceValues(),

            // Açıklama
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildGForceDisplay() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF0D0D1A),
          ],
        ),
        border: Border.all(color: Colors.grey[700]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: CustomPaint(
        painter: GForcePainter(
          lateralG: _lateralG,
          longitudinalG: _longitudinalG,
        ),
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.cyan.withOpacity(0.2),
              border: Border.all(color: Colors.cyan, width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getTotalG().toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'g',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getTotalG() {
    return math.sqrt(_lateralG * _lateralG + _longitudinalG * _longitudinalG);
  }

  Widget _buildGForceValues() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              child:
                  _buildGCard('YANAL', _lateralG, _maxLateralG, Colors.cyan)),
          const SizedBox(width: 16),
          Expanded(
              child: _buildGCard('BOYLAMSAL', _longitudinalG, _maxLongitudinalG,
                  Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildGCard(String label, double current, double max, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.grey, fontSize: 12, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          Text(
            '${current.toStringAsFixed(2)} g',
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('MAX: ',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(
                '${max.toStringAsFixed(2)} g',
                style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'G-force değerleri telefonun ivmeölçer sensöründen okunur. Telefonu araca sabit şekilde monte edin.',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// G-Force Painter
class GForcePainter extends CustomPainter {
  final double lateralG;
  final double longitudinalG;

  GForcePainter({required this.lateralG, required this.longitudinalG});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Grid çizgileri
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    // Yatay ve dikey çizgiler
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      gridPaint,
    );

    // Çemberler
    final circlePaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double i = 0.25; i <= 1.0; i += 0.25) {
      canvas.drawCircle(center, radius * i, circlePaint);
    }

    // G-force noktası
    final maxG = 2.0; // Maksimum gösterilebilir G
    final x = center.dx + (lateralG / maxG) * radius;
    final y = center.dy - (longitudinalG / maxG) * radius;

    // Çizgi
    final linePaint = Paint()
      ..color = Colors.cyan.withOpacity(0.5)
      ..strokeWidth = 2;
    canvas.drawLine(center, Offset(x, y), linePaint);

    // Nokta
    final dotPaint = Paint()..color = Colors.cyan;
    canvas.drawCircle(Offset(x, y), 10, dotPaint);

    // İç nokta
    final innerDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(x, y), 4, innerDotPaint);

    // Etiketler
    final textStyle = TextStyle(color: Colors.grey[600], fontSize: 10);

    _drawText(
        canvas, 'L', Offset(center.dx - radius - 15, center.dy - 5), textStyle);
    _drawText(
        canvas, 'R', Offset(center.dx + radius + 5, center.dy - 5), textStyle);
    _drawText(canvas, 'İVME', Offset(center.dx - 15, center.dy - radius - 15),
        textStyle);
    _drawText(canvas, 'FREN', Offset(center.dx - 15, center.dy + radius + 5),
        textStyle);
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant GForcePainter oldDelegate) {
    return oldDelegate.lateralG != lateralG ||
        oldDelegate.longitudinalG != longitudinalG;
  }
}
