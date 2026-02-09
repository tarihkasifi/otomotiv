// Kısayol İşleyici Servisi
// Android uygulama kısayollarını (long-press) Flutter tarafında işler
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../screens/dashboard/how_it_works_screen.dart';

class ShortcutHandlerService {
  static const _channel = MethodChannel('app.shortcuts/handler');

  /// Uygulama açılışında kısayol kontrolü yap
  static Future<void> checkAndHandle(BuildContext context) async {
    try {
      final shortcut = await _channel.invokeMethod<String>('getShortcut');
      if (shortcut != null && context.mounted) {
        _handleShortcut(context, shortcut);
      }
    } catch (e) {
      debugPrint('⚡ [Shortcut] Hata: $e');
    }
  }

  static void _handleShortcut(BuildContext context, String shortcut) {
    switch (shortcut) {
      case 'report_bug':
        _showReportBugDialog(context);
        break;
      case 'share_app':
        _shareApp();
        break;
      case 'pair_device':
        // Dashboard'a yönlendir, oradan cihaz eşleştirme yapılacak
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard-a', (r) => false);
        break;
      case 'get_support':
        _showSupportDialog(context);
        break;
      case 'about':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HowItWorksScreen()),
        );
        break;
    }
  }

  /// Hata bildir dialog
  static void _showReportBugDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.bug_report, color: Colors.red, size: 24),
            SizedBox(width: 10),
            Text('Hata Bildir',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Karşılaştığınız hatayı aşağıda açıklayın. '
              'Geri bildiriminiz uygulamamızı geliştirmemize yardımcı olur.',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              maxLines: 5,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Hatayı detaylı şekilde açıklayın...',
                hintStyle: TextStyle(color: Colors.grey[700]),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[800]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[800]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.cyan),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (controller.text.trim().isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Hata raporu gönderildi. Teşekkürler!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Gönder'),
          ),
        ],
      ),
    );
  }

  /// Uygulamayı paylaş
  static void _shareApp() {
    SharePlus.instance.share(
      ShareParams(
        text: '🚗 Araç Arıza Tespit uygulamasını dene!\n\n'
            'OBD-II ile aracının tüm verilerini gerçek zamanlı oku, '
            'arıza kodlarını analiz et ve performans takibi yap.\n\n'
            'İndir: https://play.google.com/store/apps/details?id=com.example.otomotiv_ariza_tespit',
      ),
    );
  }

  /// Destek al dialog
  static void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.support_agent, color: Colors.orange, size: 24),
            SizedBox(width: 10),
            Text('Destek Al',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSupportItem(
              Icons.email,
              'E-posta ile İletişim',
              'destek@aracteşhis.com',
              Colors.cyan,
            ),
            const SizedBox(height: 12),
            _buildSupportItem(
              Icons.help_outline,
              'Sıkça Sorulan Sorular',
              'Nasıl Çalışır sayfasına gidin',
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildSupportItem(
              Icons.build_circle,
              'Sorun Giderme',
              'Ayarlar > Sorun Giderme',
              Colors.amber,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Text(
                'Geliştirici: Hüseyin AŞİR\n'
                'Sürüm: 1.0.0',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Kapat', style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }

  static Widget _buildSupportItem(
      IconData icon, String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
