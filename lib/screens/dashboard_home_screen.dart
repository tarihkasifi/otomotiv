// A Girişi - Dashboard Ana Ekranı
// Modern Teknolojik Tasarım - Araç Tarama Animasyonu
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';

import '../services/obd_service.dart';
import '../services/vehicle_image_service.dart';
import '../services/device_history_service.dart';
import '../services/sound_service.dart';
import '../utils/responsive.dart';
import 'dashboard/gauge_screen.dart';
import 'dashboard/performance_screen.dart';
import 'dashboard/data_grid_screen.dart';
import 'dashboard/diagnostics_screen.dart';
import 'dashboard/vehicle_info_screen.dart';
import 'dashboard/settings_screen.dart';
import 'dashboard/race_screen.dart';
import 'dashboard/code_analysis_screen.dart';
import 'dashboard/how_it_works_screen.dart';
import 'dashboard/diagnostics_history_screen.dart';
import '../services/shortcut_handler_service.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen>
    with TickerProviderStateMixin {
  final OBDService _obdService = OBDService();

  // Canlı veriler
  double _speed = 0;
  double _rpm = 0;
  double _coolantTemp = 0;
  double _throttle = 0;

  // Araç bilgisi
  String _vehicleName = 'Araç Bekleniyor';
  String _connectionStatus = 'Bağlantı Yok';
  String? _vehicleLogoUrl;

  bool _isConnected = false;
  bool _isConnecting = false;
  bool _isScanning = false;

  Timer? _liveDataTimer;
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  StreamSubscription<OBDConnectionState>? _connectionSubscription;

  @override
  void initState() {
    super.initState();

    // Tarama animasyonu
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Pulse animasyonu
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Glow animasyonu
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _checkPermissions();
    _listenConnectionState();

    // İlk girişte OBD kurulum rehberini göster
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOBDSetupGuideIfNeeded();
      // Kısayol kontrolü
      ShortcutHandlerService.checkAndHandle(context);
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _liveDataTimer?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _showOBDSetupGuideIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenGuide = prefs.getBool('has_seen_obd_guide') ?? false;
    if (!hasSeenGuide && mounted) {
      await prefs.setBool('has_seen_obd_guide', true);
      _showOBDSetupGuide();
    } else {
      // Rehber zaten görüldüyse güncelleme kontrolü yap
      _checkForUpdates();
    }
  }

  void _checkForUpdates() {
    // Simüle edilmiş güncelleme kontrolü
    // Gerçek senaryoda burada Firebase Remote Config veya API çağrısı yapılır
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Örnek güncelleme duyurusu (Test için aktif)
        _showUpdateDialog(
          'Güncelleme Yayında! v1.0.2',
          '• Anasayfa tasarımı yenilendi\n• Veri ekranı görünürlüğü artırıldı\n• Performans iyileştirmeleri yapıldı',
        );
      }
    });
  }

  void _showUpdateDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.cyan.withOpacity(0.5), width: 2)),
        title: Row(
          children: [
            const Icon(Icons.new_releases, color: Colors.cyan),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('HARİKA',
                style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }


  void _showOBDSetupGuide() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0D1117),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.cyan.withOpacity(0.3)),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Başlık
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.bluetooth_connected,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'OBD Bağlantı Rehberi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Aracınıza bağlanmak için aşağıdaki adımları takip edin',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  // Adım 1
                  _buildGuideStep(
                    stepNumber: 1,
                    icon: Icons.power,
                    color: Colors.orange,
                    title: 'OBD Cihazını Takın',
                    description:
                        'OBD-II cihazınızı aracınızın OBD portuna takın. '
                        'Port genellikle direksiyon altında, sürücü tarafında yer alır.',
                  ),
                  const SizedBox(height: 14),

                  // Adım 2
                  _buildGuideStep(
                    stepNumber: 2,
                    icon: Icons.key,
                    color: Colors.amber,
                    title: 'Kontağı Açın',
                    description:
                        'Aracınızın kontağını açık (ON) konumuna getirin. '
                        'OBD cihazındaki LED ışığının yandığından emin olun.',
                  ),
                  const SizedBox(height: 14),

                  // Adım 3
                  _buildGuideStep(
                    stepNumber: 3,
                    icon: Icons.bluetooth_searching,
                    color: Colors.blue,
                    title: 'Bluetooth Eşleştirmesi',
                    description:
                        'Telefonunuzun Bluetooth ayarlarına gidin ve OBD cihazını eşleştirin. '
                        'Cihaz genellikle "OBDII" veya "ELM327" adıyla görünür. '
                        'Şifre sorulursa "1234" veya "0000" girin.',
                  ),
                  const SizedBox(height: 14),

                  // Adım 4
                  _buildGuideStep(
                    stepNumber: 4,
                    icon: Icons.directions_car,
                    color: Colors.green,
                    title: 'Aracı Çalıştırın ve Bağlanın',
                    description:
                        'Aracınızı çalıştırın, ardından bu sayfanın altındaki '
                        '"OBD CİHAZINA BAĞLAN" butonuna dokunun.',
                  ),
                  const SizedBox(height: 24),

                  // Uyarı notu
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.amber[600], size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'İlk bağlantıda cihaz algılanması birkaç saniye sürebilir. '
                            'Bağlantı sağlandıktan sonra araç bilgileri otomatik olarak okunacaktır.',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Anladım butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        SoundService().playClick();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5FF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'ANLADIM, BAŞLAYALIM!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuideStep({
    required int stepNumber,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _checkPermissions() async {
    // İzinler yalnızca mobil platformda gerekli
    try {
      if (!Platform.isAndroid && !Platform.isIOS) return;
    } catch (_) {
      return;
    }
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.locationWhenInUse.request();
  }

  void _listenConnectionState() {
    _connectionSubscription = _obdService.connectionState.listen((state) {
      setState(() {
        switch (state) {
          case OBDConnectionState.disconnected:
            _connectionStatus = 'Bağlantı Yok';
            _isConnected = false;
            _isConnecting = false;
            break;
          case OBDConnectionState.connecting:
            _connectionStatus = 'Bağlanıyor...';
            _isConnecting = true;
            break;
          case OBDConnectionState.connected:
            _connectionStatus = 'Bağlandı';
            break;
          case OBDConnectionState.initializing:
            _connectionStatus = 'ELM327 Başlatılıyor...';
            break;
          case OBDConnectionState.ready:
            _connectionStatus = 'Hazır';
            _isConnected = true;
            _isConnecting = false;
            _startLiveDataReading();
            _detectVehicle();
            break;
          case OBDConnectionState.error:
            _connectionStatus = 'Hata';
            _isConnected = false;
            _isConnecting = false;
            break;
        }
      });
    });
  }

  Future<void> _autoConnectToHHOBD() async {
    setState(() {
      _isScanning = true;
      _connectionStatus = 'OBD Aranıyor...';
    });

    try {
      final enabled = await _obdService.isBluetoothEnabled();
      if (!enabled) {
        await _obdService.enableBluetooth();
      }

      final pairedDevices = await _obdService.getPairedDevices();

      BluetoothDevice? obdDevice;
      for (final device in pairedDevices) {
        final name = device.name?.toLowerCase() ?? '';
        if (name.contains('hhobd') ||
            name.contains('obd') ||
            name.contains('elm') ||
            name.contains('v2.1') ||
            name.contains('obdii')) {
          obdDevice = device;
          break;
        }
      }

      if (obdDevice != null) {
        setState(() {
          _connectionStatus = '${obdDevice!.name} bağlanıyor...';
          _isScanning = false;
        });

        final success = await _obdService.connect(obdDevice);

        if (!success && mounted) {
          _showErrorDialog('Bağlantı başarısız', _obdService.lastError);
        }
      } else {
        setState(() {
          _isScanning = false;
          _connectionStatus = 'OBD bulunamadı';
        });

        if (mounted) {
          _showDeviceListDialog(pairedDevices);
        }
      }
    } catch (e) {
      setState(() {
        _isScanning = false;
        _connectionStatus = 'Hata: $e';
      });
    }
  }

  void _showDeviceListDialog(List<BluetoothDevice> devices) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.bluetooth, color: Colors.cyan[400]),
            const SizedBox(width: 8),
            const Text('OBD Cihazı Seçin',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: devices.isEmpty
              ? const Text(
                  'Eşleşmiş cihaz bulunamadı.\n\nLütfen önce Bluetooth ayarlarından OBD cihazını eşleştirin.',
                  style: TextStyle(color: Colors.grey),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D1A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                      ),
                      child: ListTile(
                        leading:
                            const Icon(Icons.bluetooth, color: Colors.cyan),
                        title: Text(device.name ?? 'Bilinmeyen',
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(device.address,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 11)),
                        onTap: () {
                          SoundService().playClick();
                          Navigator.pop(context);
                          _connectToDevice(device);
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
      _connectionStatus = '${device.name} bağlanıyor...';
    });

    final success = await _obdService.connect(device);

    if (mounted) {
      if (success) {
        setState(() {
          _isConnected = true;
          _isConnecting = false;
          _connectionStatus = 'Bağlı';
        });
        _detectVehicle();
      } else {
        setState(() {
          _isConnecting = false;
          _connectionStatus = 'Bağlantı başarısız';
        });
        _showErrorDialog('Bağlantı başarısız', _obdService.lastError);
      }
    }
  }

  void _showConnectionProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConnectionProgressDialog(
        obdService: _obdService,
        onComplete: () {
          if (mounted) {
            setState(() {
              _isConnected = true;
              _connectionStatus = 'Bağlı';
            });
            _detectVehicle();
          }
        },
        onError: () {
          if (mounted) {
            setState(() {
              _isConnected = false;
              _isConnecting = false;
              _isScanning = false;
              _connectionStatus = 'Bağlantı başarısız';
            });
          }
        },
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat', style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }

  Future<void> _detectVehicle() async {
    // Hemen başla, bekleme yok
    if (mounted && _isConnected) {
      // VIN'den araç bilgisi al
      String? vin;
      try {
        vin = await _obdService.getVin();
      } catch (e) {
        // VIN okunamadı
      }

      // Araç görseli ve bilgisini al
      final deviceName = _obdService.connectedDeviceName;
      final imageResult = await VehicleImageService.getVehicleImage(vin, deviceName);

      setState(() {
        if (imageResult.manufacturer != null) {
          _vehicleName = imageResult.displayName;
          _vehicleLogoUrl = imageResult.logoUrl;
        } else {
          _vehicleName = 'OBD Bağlı Araç';
          _vehicleLogoUrl = null;
        }
      });

      // Cihaz geçmişine kaydet
      DeviceHistoryService.recordConnection(
        deviceName: _obdService.connectedDeviceName,
        deviceAddress: _obdService.connectedDeviceAddress,
        vehicleName: imageResult.manufacturer != null ? imageResult.displayName : null,
        vin: vin,
        manufacturer: imageResult.manufacturer,
      );
    }
  }

  void _startLiveDataReading() {
    _liveDataTimer?.cancel();

    // İlk veriyi hemen oku (gecikme yok)
    _readFastDataOnce();

    // Sonra her 1 saniyede bir oku
    _liveDataTimer =
        Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (!_isConnected) {
        timer.cancel();
        return;
      }
      await _readFastDataOnce();
    });
  }

  Future<void> _readFastDataOnce() async {
    if (!_isConnected) return;
    try {
      final data = await _obdService.readDashboardData();
      if (mounted) {
        setState(() {
          if (data.speed != null) _speed = data.speed!.toDouble();
          if (data.rpm != null) _rpm = data.rpm!.toDouble();
          if (data.coolantTemp != null) _coolantTemp = data.coolantTemp!.toDouble();
          if (data.throttlePosition != null) _throttle = data.throttlePosition!;
        });
      }
    } catch (e) {
      // Okuma hatası
    }
  }

  Future<void> _disconnect() async {
    _liveDataTimer?.cancel();
    await _obdService.disconnect();

    setState(() {
      _speed = 0;
      _rpm = 0;
      _coolantTemp = 0;
      _throttle = 0;
      _vehicleName = 'Araç Bekleniyor';
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A12) : const Color(0xFFF5F5F7),
      body: Stack(
        children: [
          // Arka plan gradient ve grid efekti
          _buildBackground(isDark),

          // Ana içerik
          SafeArea(
            child: Column(
              children: [
                // Üst bar
                _buildTopBar(isDark),

                // Ana içerik
                Expanded(
                  child: SingleChildScrollView(
                    padding: Responsive.horizontalPadding,
                    child: DesktopContentWrapper(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          // Araç tarama görselil
                          _buildCarScanVisualization(isDark),

                          const SizedBox(height: 24),

                          // Menü grid
                          _buildMenuGrid(isDark),

                          const SizedBox(height: 24),

                          // Bağlantı butonu
                          _buildConnectionButton(),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isDark) {
    return Stack(
      children: [
        // Gradient arka plan
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const [
                      Color(0xFF0D1117),
                      Color(0xFF0A0A12),
                      Color(0xFF050508),
                    ]
                  : const [
                      Color(0xFFFFFFFF),
                      Color(0xFFF7F7F8),
                      Color(0xFFF0F0F2),
                    ],
            ),
          ),
        ),

        // Grid pattern
        CustomPaint(
          size: Size.infinite,
          painter: GridPatternPainter(),
        ),

        // Glow efekti
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    Colors.cyan.withOpacity(0.08 * _glowController.value),
                    Colors.transparent,
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Geri butonu
          GestureDetector(
            onTap: () {
              SoundService().playClick();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1)),
              ),
              child: Icon(Icons.arrow_back_ios_new,
                  color: isDark ? Colors.white70 : Colors.black54, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ARAÇ ARIZA TESPİT',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _connectionStatus,
                  style: TextStyle(
                    color: _isConnected ? Colors.green : Colors.grey,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Spacer(),

          // Bağlantı durumu indikatörü
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isConnected
                      ? Colors.green
                      : (_isConnecting ? Colors.orange : Colors.red),
                  boxShadow: [
                    BoxShadow(
                      color: (_isConnected ? Colors.green : Colors.red)
                          .withOpacity(0.5 * _pulseController.value),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),

          // Ayarlar
          GestureDetector(
            onTap: () {
              SoundService().playClick();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.settings, color: Colors.grey, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarScanVisualization(bool isDark) {
    return Container(
      height: Responsive.scanAreaHeight,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D0D1A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.radius(20)),
        border: Border.all(
            color:
                isDark ? Colors.cyan.withOpacity(0.2) : Colors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.cyan.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Araç silüeti/logo ve tarama animasyonu
          Center(
            child: _isConnected
                ? _buildVehicleImage()
                : AnimatedBuilder(
                    animation: _scanController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(Responsive.scanPainterWidth, Responsive.scanPainterHeight),
                        painter: CarScanPainter(
                          scanProgress: _scanController.value,
                          isConnected: _isConnected,
                        ),
                      );
                    },
                  ),
          ),

          // Köşe süslemeleri
          Positioned(
            top: 12,
            left: 12,
            child: _buildCornerDecoration(),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Transform.scale(scaleX: -1, child: _buildCornerDecoration()),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Transform.scale(scaleY: -1, child: _buildCornerDecoration()),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Transform.scale(
                scaleX: -1, scaleY: -1, child: _buildCornerDecoration()),
          ),

          // Araç adı
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _vehicleName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isConnected ? Colors.cyan : Colors.grey,
                    fontSize: Responsive.fontSize(14),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                if (_isConnected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.withOpacity(0.5)),
                    ),
                    child: const Text(
                      'BAĞLI',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Araç görseli
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.2 * _glowController.value),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/araba.png',
                width: Responsive.vehicleImageWidth,
                height: Responsive.vehicleImageHeight,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.directions_car,
                    size: 80,
                    color: Colors.cyan.withOpacity(0.5),
                  );
                },
              ),
            );
          },
        ),
        // Marka logosu badge (VIN tanınırsa)
        if (_vehicleLogoUrl != null)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Image.network(
                _vehicleLogoUrl!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.verified, color: Colors.cyan, size: 20);
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCornerDecoration() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: CornerPainter(color: Colors.cyan.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildPairDeviceButton() {
    return GestureDetector(
      onTap: () {
        SoundService().playClick();
        _showBluetoothPairingDialog();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.15),
              Colors.cyan.withOpacity(0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2979FF), Color(0xFF00B0FF)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.bluetooth_searching,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cihazı Eşleştir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Bluetooth ile OBD cihazınızı bağlayın',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: Colors.blue[300], size: 16),
          ],
        ),
      ),
    );
  }

  void _showBluetoothPairingDialog() {
    List<BluetoothDevice> pairedDevices = [];
    List<BluetoothDiscoveryResult> discoveredDevices = [];
    List<fbp.ScanResult> bleDevices = [];
    bool scanning = true;
    StreamSubscription<BluetoothDiscoveryResult>? classicSub;
    StreamSubscription<fbp.ScanResult>? bleSub;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Taramayı başlat
            if (scanning) {
              scanning = false;

              // 1. Eşleşmiş cihazları hemen göster
              _obdService.getPairedDevices().then((paired) {
                if (mounted) {
                  setDialogState(() => pairedDevices = paired);
                }
              });

              // 2. Classic Bluetooth tarama
              classicSub?.cancel();
              classicSub = _obdService.scanDevices().listen((result) {
                final name = result.device.name?.toLowerCase() ?? '';
                if (name.isNotEmpty) {
                  if (mounted) {
                    setDialogState(() {
                      if (!discoveredDevices.any((d) => d.device.address == result.device.address) &&
                          !pairedDevices.any((d) => d.address == result.device.address)) {
                        discoveredDevices.add(result);
                      }
                    });
                  }
                }
              });

              // 3. BLE tarama
              bleSub?.cancel();
              bleSub = _obdService.scanBLEDevices().listen((result) {
                final name = result.device.platformName;
                if (name.isNotEmpty) {
                  if (mounted) {
                    setDialogState(() {
                      if (!bleDevices.any((d) => d.device.remoteId == result.device.remoteId)) {
                        bleDevices.add(result);
                      }
                    });
                  }
                }
              });

              // 10 saniye sonra taramayı durdur
              Future.delayed(const Duration(seconds: 10), () {
                classicSub?.cancel();
                bleSub?.cancel();
                _obdService.stopScan();
              });
            }

            final totalDevices = pairedDevices.length + discoveredDevices.length + bleDevices.length;

            return Dialog(
              backgroundColor: const Color(0xFF0D1117),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Başlık
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.bluetooth_searching,
                              color: Colors.blue, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bluetooth Cihazları',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text('Eşleşmiş ve yakındaki cihazlar',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            classicSub?.cancel();
                            bleSub?.cancel();
                            _obdService.stopScan();
                            Navigator.pop(dialogContext);
                          },
                          icon: const Icon(Icons.close,
                              color: Colors.grey, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.grey, height: 1),
                    const SizedBox(height: 12),

                    // Tarama göstergesi
                    const LinearProgressIndicator(minHeight: 2),
                    const SizedBox(height: 12),

                    // Cihaz listesi
                    if (totalDevices == 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                  color: Colors.blue, strokeWidth: 2),
                            ),
                            const SizedBox(height: 16),
                            Text('Cihazlar taranıyor...',
                              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('OBD cihazınızın açık olduğundan emin olun',
                              style: TextStyle(color: Colors.grey[700], fontSize: 11)),
                          ],
                        ),
                      )
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 350),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            // Eşleşmiş cihazlar
                            if (pairedDevices.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text('📱 Eşleşmiş',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              ...pairedDevices.map((device) => _buildPairingDeviceTile(
                                name: device.name ?? 'Bilinmeyen',
                                address: device.address,
                                isBLE: false,
                                onTap: () {
                                  SoundService().playClick();
                                  classicSub?.cancel();
                                  bleSub?.cancel();
                                  _obdService.stopScan();
                                  Navigator.pop(dialogContext);
                                  _connectToDevice(device);
                                },
                              )),
                            ],

                            // Keşfedilen Classic cihazlar
                            if (discoveredDevices.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 4),
                                child: Text('🔍 Yakındaki',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              ...discoveredDevices.map((result) => _buildPairingDeviceTile(
                                name: result.device.name ?? 'Bilinmeyen',
                                address: result.device.address,
                                rssi: result.rssi,
                                isBLE: false,
                                onTap: () {
                                  SoundService().playClick();
                                  classicSub?.cancel();
                                  bleSub?.cancel();
                                  _obdService.stopScan();
                                  Navigator.pop(dialogContext);
                                  _connectToDevice(result.device);
                                },
                              )),
                            ],

                            // BLE cihazlar
                            if (bleDevices.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 4),
                                child: Text('📶 BLE Cihazlar',
                                  style: TextStyle(color: Colors.cyan[300], fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              ...bleDevices.map((result) => _buildPairingDeviceTile(
                                name: result.device.platformName.isEmpty ? 'BLE Cihaz' : result.device.platformName,
                                address: result.device.remoteId.toString(),
                                rssi: result.rssi,
                                isBLE: true,
                                onTap: () {
                                  SoundService().playClick();
                                  classicSub?.cancel();
                                  bleSub?.cancel();
                                  _obdService.stopScan();
                                  Navigator.pop(dialogContext);
                                  _connectToBLEDevice(result.device);
                                },
                              )),
                            ],
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Yeniden tara butonu
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          SoundService().playClick();
                          classicSub?.cancel();
                          bleSub?.cancel();
                          _obdService.stopScan();
                          setDialogState(() {
                            pairedDevices = [];
                            discoveredDevices = [];
                            bleDevices = [];
                            scanning = true;
                          });
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Yeniden Tara'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: BorderSide(
                              color: Colors.blue.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPairingDeviceTile({
    required String name,
    required String address,
    int? rssi,
    required bool isBLE,
    required VoidCallback onTap,
  }) {
    final isOBD = name.toUpperCase().contains('OBD') ||
        name.toUpperCase().contains('ELM') ||
        name.toUpperCase().contains('MUCAR');

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (isOBD ? Colors.green : (isBLE ? Colors.cyan : Colors.blue)).withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isOBD ? Icons.directions_car : (isBLE ? Icons.bluetooth_searching : Icons.bluetooth),
          color: isOBD ? Colors.green : (isBLE ? Colors.cyan : Colors.blue),
          size: 18,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(name,
              style: TextStyle(
                color: isOBD ? Colors.green[300] : Colors.white,
                fontSize: 14,
                fontWeight: isOBD ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (isBLE)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('BLE', style: TextStyle(fontSize: 9, color: Colors.cyan, fontWeight: FontWeight.bold)),
            ),
          if (isOBD && !isBLE)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('OBD', style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      subtitle: Text(
        rssi != null ? '$address | $rssi dBm' : address,
        style: TextStyle(color: Colors.grey[600], fontSize: 11),
      ),
      onTap: onTap,
    );
  }

  Future<void> _connectToBLEDevice(fbp.BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
      _connectionStatus = '${device.platformName} BLE bağlanıyor...';
    });

    _showConnectionProgressDialog();

    final success = await _obdService.connectBLE(device);

    // İlerleme dialogunu kapat
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    if (mounted) {
      if (success) {
        setState(() {
          _isConnected = true;
          _isConnecting = false;
          _connectionStatus = 'Bağlı (BLE)';
        });
        _detectVehicle();
      } else {
        setState(() {
          _isConnecting = false;
          _connectionStatus = 'BLE bağlantı başarısız';
        });
        _showErrorDialog('BLE Bağlantı Başarısız', _obdService.lastError);
      }
    }
  }


  Widget _buildMenuGrid(bool isDark) {
    final menuItems = [
      {
        'icon': Icons.speed,
        'label': 'Gösterge\nPaneli',
        'colors': [const Color(0xFF00E5FF), const Color(0xFF0096C7)], // Cyan
        'screen': const GaugeScreen()
      },
      {
        'icon': Icons.bolt,
        'label': 'Performans',
        'colors': [const Color(0xFFFF6B35), const Color(0xFFE55A2B)], // Orange
        'screen': const PerformanceScreen()
      },
      {
        'icon': Icons.grid_view,
        'label': 'Veri Gridi',
        'colors': [const Color(0xFF00FF87), const Color(0xFF00B359)], // Green
        'screen': const DataGridScreen()
      },
      {
        'icon': Icons.build_circle,
        'label': 'Arıza\nTespit',
        'colors': [const Color(0xFFFF3D00), const Color(0xFFBF360C)], // Red
        'screen': const DiagnosticsScreen()
      },
      {
        'icon': Icons.info,
        'label': 'Araç\nBilgisi',
        'colors': [const Color(0xFFAA00FF), const Color(0xFF6200EA)], // Purple
        'screen': const VehicleInfoScreen()
      },
      {
        'icon': Icons.sports_score,
        'label': 'Yarış',
        'colors': [const Color(0xFFFFD600), const Color(0xFFFFAB00)], // Amber
        'screen': const RaceScreen()
      },
      {
        'icon': Icons.psychology,
        'label': 'Kod\nAnaliz',
        'colors': [const Color(0xFF00E5FF), const Color(0xFF2979FF)], // AI Blue
        'screen': const CodeAnalysisScreen()
      },
      {
        'icon': Icons.help_outline,
        'label': 'Nasıl\nÇalışır?',
        'colors': [const Color(0xFF26A69A), const Color(0xFF00897B)], // Teal
        'screen': const HowItWorksScreen()
      },
      {
        'icon': Icons.history,
        'label': 'Teşhis\nGeçmişi',
        'colors': [const Color(0xFFE040FB), const Color(0xFFAA00FF)], // Pink
        'screen': const DiagnosticsHistoryScreen()
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.menuColumns,
        crossAxisSpacing: Responsive.padding(16),
        mainAxisSpacing: Responsive.padding(16),
        childAspectRatio: Responsive.isTablet ? 1.1 : 0.9,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _build3DMenuItem(
          item['icon'] as IconData,
          item['label'] as String,
          item['colors'] as List<Color>,
          item['screen'] as Widget,
          isDark,
        );
      },
    );
  }

  Widget _build3DMenuItem(IconData icon, String label, List<Color> colors,
      Widget screen, bool isDark) {
    return GestureDetector(
      onTap: () {
        SoundService().playClick();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141420) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark ? colors[0].withOpacity(0.2) : Colors.grey[300]!,
              width: 1),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? colors[0].withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3D Icon Container
            Container(
              width: Responsive.size(50),
              height: Responsive.size(50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 0,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glossy effect
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 25,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Icon(icon, color: Colors.white, size: Responsive.iconSize(28)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[800],
                fontSize: Responsive.fontSize(12),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionButton() {
    return GestureDetector(
      onTap: () {
        SoundService().playClick();
        if (_isConnected) {
          _disconnect();
        } else if (!_isConnecting && !_isScanning) {
          _showConnectionProgressDialog();
        }
      },
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final color = _isConnected ? Colors.green : Colors.cyan;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2 * _pulseController.value),
                  blurRadius: 15,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isConnecting || _isScanning)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.cyan),
                  )
                else
                  Icon(
                    _isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                    color: color,
                  ),
                const SizedBox(width: 12),
                Text(
                  _isConnected
                      ? 'BAĞLI - Bağlantıyı Kes'
                      : (_isConnecting || _isScanning
                          ? 'BAĞLANIYOR...'
                          : 'OBD CİHAZINA BAĞLAN'),
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Grid pattern painter
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.03)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

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

// Car scan animation painter
class CarScanPainter extends CustomPainter {
  final double scanProgress;
  final bool isConnected;

  CarScanPainter({required this.scanProgress, required this.isConnected});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Araç silüeti - basit şekil
    final carPath = Path();

    // Araç gövdesi
    final carWidth = size.width * 0.7;
    final carHeight = size.height * 0.35;
    final carLeft = centerX - carWidth / 2;
    final carTop = centerY - carHeight / 2;

    // Gövde
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(carLeft, carTop, carWidth, carHeight),
      const Radius.circular(15),
    );

    // Kabin kısmı
    final cabinWidth = carWidth * 0.5;
    final cabinHeight = carHeight * 0.7;
    final cabinLeft = centerX - cabinWidth / 2 + 10;
    final cabinTop = carTop - cabinHeight + 10;

    final cabinRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(cabinLeft, cabinTop, cabinWidth, cabinHeight),
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
    );

    // Araç çizimi - neon efektli
    final carPaint = Paint()
      ..color = isConnected
          ? Colors.cyan.withOpacity(0.3)
          : Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(bodyRect, carPaint);
    canvas.drawRRect(cabinRect, carPaint);

    // Kenar çizgileri
    final strokePaint = Paint()
      ..color = isConnected ? Colors.cyan : Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(bodyRect, strokePaint);
    canvas.drawRRect(cabinRect, strokePaint);

    // Tekerlekler
    final wheelRadius = 15.0;
    final wheelPaint = Paint()
      ..color = isConnected
          ? Colors.cyan.withOpacity(0.5)
          : Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(carLeft + 40, carTop + carHeight), wheelRadius, wheelPaint);
    canvas.drawCircle(Offset(carLeft + carWidth - 40, carTop + carHeight),
        wheelRadius, wheelPaint);

    // Tarama çizgisi
    final scanY = size.height * scanProgress;
    final scanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.cyan.withOpacity(0.8),
          Colors.cyan,
          Colors.cyan.withOpacity(0.8),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, scanY - 2, size.width, 4))
      ..strokeWidth = 3;

    canvas.drawLine(Offset(0, scanY), Offset(size.width, scanY), scanPaint);

    // Tarama izi
    final trailPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.cyan.withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, math.max(0, scanY - 50), size.width, 50));

    canvas.drawRect(
        Rect.fromLTWH(0, math.max(0, scanY - 50), size.width, 50), trailPaint);

    // Veri noktaları (bağlıyken)
    if (isConnected) {
      final dotPaint = Paint()..color = Colors.green;
      final random = math.Random(42);
      for (int i = 0; i < 8; i++) {
        final x = carLeft + random.nextDouble() * carWidth;
        final y = carTop + random.nextDouble() * carHeight;
        canvas.drawCircle(Offset(x, y), 3, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CarScanPainter oldDelegate) {
    return oldDelegate.scanProgress != scanProgress ||
        oldDelegate.isConnected != isConnected;
  }
}

// Köşe dekorasyon painter
class CornerPainter extends CustomPainter {
  final Color color;

  CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Bağlantı ilerleme dialogu
class ConnectionProgressDialog extends StatefulWidget {
  final OBDService obdService;
  final VoidCallback onComplete;
  final VoidCallback onError;

  const ConnectionProgressDialog({
    super.key,
    required this.obdService,
    required this.onComplete,
    required this.onError,
  });

  @override
  State<ConnectionProgressDialog> createState() =>
      _ConnectionProgressDialogState();
}

class _ConnectionProgressDialogState extends State<ConnectionProgressDialog>
    with TickerProviderStateMixin {
  int _currentStep = 0; // 0: searching, 1: found, 2: reading, 3: complete
  String _statusMessage = 'Cihaz aranıyor...';
  bool _hasError = false;
  String? _errorMessage;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _startConnectionProcess();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startConnectionProcess() async {
    // Adım 1: Cihaz Aranıyor
    setState(() {
      _currentStep = 0;
      _statusMessage = 'Bluetooth cihazları taranıyor...';
    });

    try {
      final enabled = await widget.obdService.isBluetoothEnabled();
      if (!enabled) {
        await widget.obdService.enableBluetooth();
      }

      await Future.delayed(const Duration(milliseconds: 800));
      final pairedDevices = await widget.obdService.getPairedDevices();

      BluetoothDevice? obdDevice;
      for (final device in pairedDevices) {
        final name = device.name?.toLowerCase() ?? '';
        if (name.contains('hhobd') ||
            name.contains('obd') ||
            name.contains('elm') ||
            name.contains('v2.1') ||
            name.contains('obdii')) {
          obdDevice = device;
          break;
        }
      }

      if (obdDevice == null) {
        setState(() {
          _hasError = true;
          _errorMessage = 'OBD cihazı bulunamadı';
        });
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
          widget.onError();
        }
        return;
      }

      // Adım 2: Cihaz Bulundu, Bağlanıyor
      setState(() {
        _currentStep = 1;
        _statusMessage = '${obdDevice!.name} bulundu, bağlanıyor...';
      });

      await Future.delayed(const Duration(milliseconds: 500));
      final success = await widget.obdService.connect(obdDevice);

      if (!success) {
        setState(() {
          _hasError = true;
          _errorMessage = widget.obdService.lastError ?? 'Bağlantı başarısız';
        });
        // Kullanıcı kapatana kadar ekranda kal
        return;
      }

      // Adım 3: Araç Okunuyor
      setState(() {
        _currentStep = 2;
        _statusMessage = 'Cihaza bağlandı, araç verileri okunuyor...';
      });

      await Future.delayed(const Duration(milliseconds: 1000));

      // Adım 4: Tamamlandı
      setState(() {
        _currentStep = 3;
        _statusMessage = 'Bağlantı başarılı! Ana sayfaya dönülüyor...';
      });

      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        Navigator.pop(context);
        widget.onComplete();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Hata: $e';
      });
      // Kullanıcı kapatana kadar ekranda kal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0D0D1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _hasError
                            ? Colors.red.withOpacity(0.2)
                            : Colors.cyan.withOpacity(
                                0.1 + 0.1 * _pulseController.value),
                        shape: BoxShape.circle,
                        boxShadow: _hasError
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.cyan.withOpacity(
                                      0.3 * _pulseController.value),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                      ),
                      child: Icon(
                        _hasError
                            ? Icons.error_outline
                            : Icons.bluetooth_searching,
                        color: _hasError ? Colors.red : Colors.cyan,
                        size: 28,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _hasError ? 'Bağlantı Hatası' : 'OBD Bağlantısı',
                        style: TextStyle(
                          color: _hasError ? Colors.red : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _statusMessage,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Progress Steps
            _buildStepIndicator(0, 'Cihaz Aranıyor', Icons.search),
            _buildStepConnector(0),
            _buildStepIndicator(
                1, 'Cihaz Bulundu, Bağlanıyor', Icons.bluetooth_connected),
            _buildStepConnector(1),
            _buildStepIndicator(
                2, 'Araç Verileri Okunuyor', Icons.directions_car),
            _buildStepConnector(2),
            _buildStepIndicator(
                3, 'Tamamlandı, Ana Sayfaya Dönülüyor', Icons.check_circle),

            if (_hasError && _errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber,
                        color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onError();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Kapat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isCompleted = _currentStep > step;
    final isActive = _currentStep == step && !_hasError;
    final isFailed = _hasError && _currentStep == step;

    Color bgColor;
    Color iconColor;
    Color textColor;

    if (isCompleted) {
      bgColor = Colors.green.withOpacity(0.2);
      iconColor = Colors.green;
      textColor = Colors.green;
    } else if (isFailed) {
      bgColor = Colors.red.withOpacity(0.2);
      iconColor = Colors.red;
      textColor = Colors.red;
    } else if (isActive) {
      bgColor = Colors.cyan.withOpacity(0.2);
      iconColor = Colors.cyan;
      textColor = Colors.cyan;
    } else {
      bgColor = Colors.grey.withOpacity(0.1);
      iconColor = Colors.grey[600]!;
      textColor = Colors.grey[600]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? iconColor : iconColor.withOpacity(0.3),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: isActive || isCompleted
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
          if (isActive && !_hasError)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int step) {
    final isCompleted = _currentStep > step;

    return Container(
      margin: const EdgeInsets.only(left: 28),
      height: 20,
      child: Row(
        children: [
          Container(
            width: 2,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isCompleted
                    ? [Colors.green, Colors.green]
                    : [
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.3)
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
