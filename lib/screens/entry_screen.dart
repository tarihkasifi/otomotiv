// Premium Giriş Ekranı - Login
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/responsive.dart';
import '../services/sound_service.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  // Login credentials
  static const String _adminUsername = 'admin';
  static const String _adminPassword = '1234';

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _showLoginDialog() {
    final usernameController = TextEditingController(text: 'admin');
    final passwordController = TextEditingController(text: '1234');
    bool obscurePassword = true;
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: const Color(0xFF0D0D1A),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(28),
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withOpacity(0.2),
                          Colors.orange.withOpacity(0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child:
                        const Icon(Icons.person, color: Colors.orange, size: 40),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Üye Girişi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kayıtlı kullanıcı bilgilerinizi girin',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  // Username field
                  TextField(
                    controller: usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.grey[400]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          setDialogState(
                              () => obscurePassword = !obscurePassword);
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),

                  // Error message
                  if (errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        SoundService().playClick();
                        final username = usernameController.text.trim();
                        final password = passwordController.text;

                        if (username.isEmpty || password.isEmpty) {
                          setDialogState(() {
                            errorMessage = 'Lütfen tüm alanları doldurun';
                          });
                          return;
                        }

                        if (username == _adminUsername &&
                            password == _adminPassword) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/dashboard-a');
                        } else {
                          setDialogState(() {
                            errorMessage = 'Kullanıcı adı veya şifre hatalı';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 8,
                        shadowColor: Colors.orange.withOpacity(0.4),
                      ),
                      child: const Text(
                        'GİRİŞ YAP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Cancel button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'İptal',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      math.cos(_backgroundController.value * 2 * math.pi),
                      math.sin(_backgroundController.value * 2 * math.pi),
                    ),
                    end: Alignment(
                      -math.cos(_backgroundController.value * 2 * math.pi),
                      -math.sin(_backgroundController.value * 2 * math.pi),
                    ),
                    colors: const [
                      Color(0xFF0A0A12),
                      Color(0xFF0D1B2A),
                      Color(0xFF1B263B),
                      Color(0xFF0D1B2A),
                      Color(0xFF0A0A12),
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  ),
                ),
              );
            },
          ),

          // Floating orbs
          ..._buildFloatingOrbs(),

          // Grid overlay
          CustomPaint(
            size: Size.infinite,
            painter: _GridPainter(),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top car image area
                Expanded(
                  flex: 4,
                  child: _buildCarImageSection(),
                ),

                // Bottom buttons area
                Expanded(
                  flex: 5,
                  child: _buildButtonsSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarImageSection() {
    return Stack(
      children: [
        // Car image container
        Container(
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset:
                    Offset(0, 5 * math.sin(_floatController.value * math.pi)),
                child: Image.asset(
                  'assets/images/araba.png',
                  fit: BoxFit.contain,
                  height: double.infinity,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF00D4FF), Color(0xFFFF6B35)],
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.directions_car,
                          size: 120,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Responsive.padding(24)),
      child: Column(
        children: [
          // Title
          _buildTitle(),
          const SizedBox(height: 40),

          // Kayıtlı Kullanıcı Button (requires login)
          _buildPremiumButton(
            title: 'Kayıtlı Kullanıcı',
            subtitle: 'Üye girişi ile tam erişim',
            icon: _build3DUserIcon(),
            gradientColors: [
              const Color(0xFFFF6B35),
              const Color(0xFFFF8C61),
              const Color(0xFFFFAA85),
            ],
            onTap: _showLoginDialog,
          ),


          const SizedBox(height: 32),

          // Footer Buttons (About & Support)
          _buildFooterButtons(),

          const SizedBox(height: 16),

          // Version info
          Text(
            'v1.0.0 • Premium Edition',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingOrbs() {
    return [
      AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Positioned(
            top: 100 + 30 * math.sin(_floatController.value * math.pi),
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF6B35).withOpacity(0.3),
                    const Color(0xFFFF6B35).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
      AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Positioned(
            bottom: 50 + 40 * math.cos(_floatController.value * math.pi),
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00D4FF).withOpacity(0.25),
                    const Color(0xFF00D4FF).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ];
  }

  Widget _buildTitle() {
    return Column(
      children: [
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)],
          ).createShader(bounds),
          child: SizedBox.shrink(), // Eray Auto text removed
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyan.withOpacity(0.3)),
          ),
          child: Text(
            'ARAÇ TEŞHİS SİSTEMİ',
            style: TextStyle(
              fontSize: Responsive.fontSize(14),
              color: Colors.cyan,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Hoş Geldiniz',
          style: TextStyle(
            fontSize: Responsive.fontSize(15),
            color: Colors.grey[500],
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: _showAboutDialog,
          icon: Icon(Icons.info_outline, color: Colors.grey[400], size: 18),
          label: Text(
            'Hakkımızda',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
        const SizedBox(width: 20),
        TextButton.icon(
          onPressed: _showSupportDialog,
          icon: Icon(Icons.support_agent, color: Colors.grey[400], size: 18),
          label: Text(
            'Destek Al',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      ],
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D0D1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info, color: Colors.blue, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hakkımızda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bu uygulama Hüseyin AŞİR tarafından geliştirilmiştir.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Yapay Zeka destekli araç arıza tespit sistemi, OBD-II bağlantısı ile aracınızın verilerini anlık olarak okur ve olası arızaları analiz eder.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tamam'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D0D1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_in_talk,
                    color: Colors.green, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Destek Al',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Geliştiriciyi Arayın',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: const SelectableText(
                  // Copyable text
                  '0532 784 84 82',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tamam'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _build3DUserIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8C61), Color(0xFFFF6B35), Color(0xFFE55A2B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.person_pin, size: 28, color: Colors.white),
    );
  }



  Widget _buildPremiumButton({
    required String title,
    required String subtitle,
    required Widget icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            SoundService().playClick();
            onTap();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A1A2E).withOpacity(0.9),
                  const Color(0xFF16162A).withOpacity(0.95),
                ],
              ),
              border: Border.all(
                color: gradientColors[0]
                    .withOpacity(0.3 + 0.1 * _pulseController.value),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0]
                      .withOpacity(0.15 * _pulseController.value),
                  blurRadius: 20,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [gradientColors[0], gradientColors[1]],
                        ).createShader(bounds),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: gradientColors[0].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.arrow_forward_ios,
                      color: gradientColors[0], size: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.03)
      ..strokeWidth = 0.5;

    const spacing = 50.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
