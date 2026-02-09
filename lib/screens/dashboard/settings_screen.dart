// Ayarlar Ekranı
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/theme_provider.dart';
import '../../services/sound_service.dart';
import '../../services/device_history_service.dart';
import '../../utils/responsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoConnect = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _units = 'metric';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoConnect = prefs.getBool('setting_autoConnect') ?? true;
      _soundEnabled = prefs.getBool('setting_soundEnabled') ?? true;
      _vibrationEnabled = prefs.getBool('setting_vibrationEnabled') ?? true;
      _units = prefs.getString('setting_units') ?? 'metric';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0A0A15) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.transparent : Colors.white,
        elevation: isDark ? 0 : 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black87),
          onPressed: () {
            SoundService().playClick();
            Navigator.pop(context);
          },
        ),
        title: Text('AYARLAR',
            style: TextStyle(
                letterSpacing: 2,
                color: isDark ? Colors.white : Colors.black87)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: DesktopContentWrapper(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              // Görünüm
              _buildSection(
                  'GÖRÜNÜM',
                  [
                    _buildThemeSwitchTile(themeProvider),
                  ],
                  isDark),
              const SizedBox(height: 16),

              // Bağlantı
              _buildSection(
                  'BAĞLANTI',
                  [
                    _buildSwitchTile(
                      'Otomatik Bağlan',
                      'Uygulama açıldığında OBD\'ye bağlan',
                      Icons.bluetooth_connected,
                      _autoConnect,
                    (value) {
                      setState(() => _autoConnect = value);
                      _saveSetting('setting_autoConnect', value);
                    },
                      isDark,
                    ),
                  ],
                  isDark),
              const SizedBox(height: 16),

              // Birimler
              _buildSection(
                  'BİRİMLER',
                  [
                    _buildOptionTile(
                      'Hız Birimi',
                      _units == 'metric' ? 'km/h' : 'mph',
                      Icons.speed,
                      () => _showUnitsDialog(isDark),
                      isDark,
                    ),
                    _buildOptionTile(
                      'Sıcaklık Birimi',
                      _units == 'metric' ? '°C' : '°F',
                      Icons.thermostat,
                      () => _showUnitsDialog(isDark),
                      isDark,
                    ),
                  ],
                  isDark),
              const SizedBox(height: 16),

              // Bildirimler
              _buildSection(
                  'BİLDİRİMLER',
                  [
                    _buildSwitchTile(
                      'Sesler',
                      'Uygulama seslerini etkinleştir',
                      Icons.volume_up,
                      _soundEnabled,
                    (value) {
                      setState(() => _soundEnabled = value);
                      _saveSetting('setting_soundEnabled', value);
                    },
                      isDark,
                    ),
                    _buildSwitchTile(
                      'Titreşim',
                      'Dokunsal geri bildirim',
                      Icons.vibration,
                      _vibrationEnabled,
                    (value) {
                      setState(() => _vibrationEnabled = value);
                      _saveSetting('setting_vibrationEnabled', value);
                    },
                      isDark,
                    ),
                  ],
                  isDark),
              const SizedBox(height: 16),

              // Hakkında
              _buildSection(
                  'HAKKINDA',
                  [
                    _buildInfoTile(
                      'Uygulama Sürümü', '1.0.0', Icons.info, isDark),
                  _buildInfoTile('Geliştirici', 'Hüseyin AŞİR', Icons.code, isDark),
                  _buildActionTile(
                      'Gizlilik Politikası', Icons.privacy_tip, () => _showPrivacyPolicyDialog(isDark), isDark),
                  _buildActionTile(
                      'Kullanım Şartları', Icons.description, () => _showTermsDialog(isDark), isDark),
                  ],
                  isDark),
              const SizedBox(height: 16),

              // Cihaz Geçmişi
              _buildDeviceHistorySection(isDark),
              const SizedBox(height: 24),

              // Sıfırla butonu
              ElevatedButton.icon(
                onPressed: () => _showResetDialog(themeProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Ayarları Sıfırla'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.2),
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitchTile(ThemeProvider themeProvider) {
    final isDark = themeProvider.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!)),
      ),
      child: ListTile(
        leading: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          color: isDark ? Colors.amber : Colors.orange,
        ),
        title: Text(
          isDark ? 'Karanlık Mod' : 'Açık Mod',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        subtitle: Text(
          isDark ? 'Koyu renk teması aktif' : 'Açık renk teması aktif',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Switch(
          value: isDark,
          onChanged: (value) => themeProvider.setDarkMode(value),
          activeColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.grey : Colors.grey[600],
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

  Widget _buildSwitchTile(String title, String subtitle, IconData icon,
      bool value, Function(bool) onChanged, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!)),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: isDark ? Colors.grey[500] : Colors.grey[600]),
        title: Text(title,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildOptionTile(String title, String value, IconData icon,
      VoidCallback onTap, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!)),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: isDark ? Colors.grey[500] : Colors.grey[600]),
        title: Text(title,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: TextStyle(color: Colors.grey[500])),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoTile(
      String title, String value, IconData icon, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!)),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: isDark ? Colors.grey[500] : Colors.grey[600]),
        title: Text(title,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        trailing: Text(value, style: TextStyle(color: Colors.grey[500])),
      ),
    );
  }

  Widget _buildActionTile(
      String title, IconData icon, VoidCallback onTap, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!)),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: isDark ? Colors.grey[500] : Colors.grey[600]),
        title: Text(title,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
        onTap: () {
          SoundService().playClick();
          onTap();
        },
      ),
    );
  }

  Widget _buildDeviceHistorySection(bool isDark) {
    return FutureBuilder<List<DeviceHistory>>(
      future: DeviceHistoryService.loadHistory(),
      builder: (context, snapshot) {
        final history = snapshot.data ?? [];
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CİHAZ GEÇMİŞİ',
                      style: TextStyle(
                        color: isDark ? Colors.grey : Colors.grey[600],
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    if (history.isNotEmpty)
                      GestureDetector(
                        onTap: () => _showClearHistoryDialog(isDark),
                        child: Text(
                          'TÜM GEÇMİŞİ SİL',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (history.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.bluetooth_disabled,
                          color: Colors.grey[600], size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'Henüz bağlanan cihaz yok',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              else
                ...history.map((device) => _buildDeviceHistoryTile(device, isDark)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeviceHistoryTile(DeviceHistory device, bool isDark) {
    final lastConnectedText = _formatLastConnected(device.lastConnected);

    return Dismissible(
      key: Key(device.deviceAddress),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            title: Text('Cihaz Kaydını Sil?',
                style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            content: Text(
              '${device.deviceName} kaydı silinecek.',
              style: TextStyle(color: Colors.grey[600]),
            ),
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
      },
      onDismissed: (direction) async {
        await DeviceHistoryService.deleteDevice(device.deviceAddress);
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bluetooth, color: Colors.cyan, size: 20),
          ),
          title: Text(
            device.vehicleName ?? device.deviceName,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${device.connectionCount} bağlantı • $lastConnectedText',
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
              if (device.vin != null)
                Text(
                  'VIN: ${device.vin}',
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 10, fontFamily: 'monospace'),
                ),
            ],
          ),
          trailing: Icon(Icons.swipe_left,
              color: Colors.grey[700], size: 16),
          isThreeLine: device.vin != null,
        ),
      ),
    );
  }

  String _formatLastConnected(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Az önce';
    if (diff.inHours < 1) return '${diff.inMinutes} dk önce';
    if (diff.inDays < 1) return '${diff.inHours} saat önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    return '${dt.day}.${dt.month}.${dt.year}';
  }

  void _showClearHistoryDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text('Tüm Geçmişi Sil?',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        content: Text(
          'Tüm bağlanan cihaz kayıtları kalıcı olarak silinecek.',
          style: TextStyle(color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await DeviceHistoryService.clearAll();
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🗑️ Cihaz geçmişi silindi'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Tümünü Sil'),
          ),
        ],
      ),
    );
  }

  void _showUnitsDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text('Birim Sistemi Seç',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Metrik (km/h, °C)',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87)),
              leading: Radio<String>(
                value: 'metric',
                groupValue: _units,
                onChanged: (value) {
                  setState(() => _units = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text('Imperial (mph, °F)',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87)),
              leading: Radio<String>(
                value: 'imperial',
                groupValue: _units,
                onChanged: (value) {
                  setState(() => _units = value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(ThemeProvider themeProvider) {
    final isDark = themeProvider.isDarkMode;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text('Ayarları Sıfırla?',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        content: Text(
          'Tüm ayarlar varsayılan değerlere döndürülecek.',
          style: TextStyle(color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _autoConnect = true;
                _soundEnabled = true;
                _vibrationEnabled = true;
                _units = 'metric';
              });
              themeProvider.setDarkMode(true);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Ayarlar sıfırlandı'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.privacy_tip, color: isDark ? Colors.cyan : Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Gizlilik Politikası',
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18)),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              'Son Güncelleme: 08 Şubat 2026\n\n'
              '1. TOPLANAN VERİLER\n'
              'Bu uygulama, aracınızın OBD-II portundaki sensör verilerini '
              '(hız, devir, motor sıcaklığı, arıza kodları vb.) yalnızca '
              'cihazınızda yerel olarak okur ve işler. Bu veriler '
              'herhangi bir sunucuya gönderilmez ve üçüncü şahıslarla paylaşılmaz.\n\n'
              '2. BLUETOOTH ERİŞİMİ\n'
              'Uygulama, OBD-II adaptörünüze bağlanmak için Bluetooth '
              'iznine ihtiyaç duyar. Bluetooth erişimi yalnızca OBD cihazı '
              'ile iletişim kurmak amacıyla kullanılır.\n\n'
              '3. CİHAZ GEÇMİŞİ\n'
              'Bağlanan OBD cihazlarının geçmişi (cihaz adı, adres, bağlantı '
              'sayısı) yalnızca cihazınızda yerel olarak saklanır. Bu verileri '
              'Ayarlar > Cihaz Geçmişi bölümünden silebilirsiniz.\n\n'
              '4. İNTERNET ERİŞİMİ\n'
              'Uygulama, AI arıza kodu analizi özelliği için internet '
              'bağlantısı kullanır. Bu durumda yalnızca girilen arıza kodu '
              'AI servisine gönderilir, kişisel veya araç kimlik bilgileri paylaşılmaz.\n\n'
              '5. VERİ GÜVENLİĞİ\n'
              'Tüm araç verileri cihazınızda şifrelenmeden saklanır. '
              'Cihazınızın güvenliğini sağlamak sizin sorumluluğunuzdadır.\n\n'
              '6. ÇOCUKLARIN GİZLİLİĞİ\n'
              'Bu uygulama 13 yaş altı çocuklara yönelik değildir ve '
              'bilinçli olarak çocuklardan veri toplamaz.\n\n'
              '7. İLETİŞİM\n'
              'Gizlilik politikasıyla ilgili sorularınız için '
              'geliştirici ile iletişime geçebilirsiniz.\n\n'
              'Geliştirici: Hüseyin AŞİR',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat',
                style: TextStyle(color: isDark ? Colors.cyan : Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.description, color: isDark ? Colors.cyan : Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Kullanım Şartları',
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18)),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              'Son Güncelleme: 08 Şubat 2026\n\n'
              '1. KABUL\n'
              'Bu uygulamayı kullanarak aşağıdaki kullanım şartlarını '
              'kabul etmiş sayılırsınız.\n\n'
              '2. KULLANIM AMACI\n'
              'Bu uygulama, OBD-II uyumlu araçların teşhis verilerini '
              'okumak ve görüntülemek amacıyla tasarlanmıştır. Uygulama '
              'profesyonel araç arıza teşhis cihazlarının yerini almaz.\n\n'
              '3. SORUMLULUK REDDİ\n'
              '• Uygulama tarafından gösterilen veriler yalnızca bilgi '
              'amaçlıdır ve %100 doğruluğu garanti edilmez.\n'
              '• Aracınızda herhangi bir arıza belirtisi olduğunda '
              'mutlaka profesyonel bir tamirciye başvurun.\n'
              '• Arıza kodu silme işlemi arıza nedenini çözmez, '
              'yalnızca uyarı ışığını söndürür.\n'
              '• Sürüş sırasında uygulamayı kullanmak tehlikeli olabilir.\n\n'
              '4. AI ANALİZ ÖZELLİĞİ\n'
              'AI analiz sonuçları yapay zeka tarafından üretilir ve '
              'kesin tanı niteliği taşımaz. Sonuçları profesyonel '
              'mekanik değerlendirmesiyle doğrulayın.\n\n'
              '5. GARANTİ\n'
              'Bu uygulama "olduğu gibi" sunulmaktadır. Geliştirici, '
              'uygulamanın kullanımından doğabilecek doğrudan veya '
              'dolaylı zararlardan sorumlu değildir.\n\n'
              '6. OBD ADAPTÖRÜ\n'
              'Uygulamanın çalışması için Bluetooth destekli bir '
              'OBD-II adaptörü (ELM327 uyumlu) gereklidir. Adaptör '
              'uyumluluğu garanti edilmez.\n\n'
              '7. GÜNCELLEME\n'
              'Bu şartlar önceden haber verilmeksizin güncellenebilir. '
              'Güncel şartları uygulama içinden takip edebilirsiniz.\n\n'
              'Geliştirici: Hüseyin AŞİR',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat',
                style: TextStyle(color: isDark ? Colors.cyan : Colors.blue)),
          ),
        ],
      ),
    );
  }
}
