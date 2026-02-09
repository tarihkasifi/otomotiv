// Nasıl Çalışır / Hakkında Sayfası
import 'package:flutter/material.dart';
import '../../services/sound_service.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            SoundService().playClick();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'NASIL ÇALIŞIR?',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00E5FF).withOpacity(0.15),
                    const Color(0xFF2979FF).withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.cyan.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.directions_car,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'OBD Araç Diagnostik',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Aracınızın tüm verilerini gerçek zamanlı olarak okuyun, '
                    'arıza kodlarını analiz edin ve performans takibi yapın.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Bölüm 1: OBD Nedir?
            _buildSection(
              icon: Icons.help_outline,
              color: Colors.cyan,
              title: 'OBD Nedir?',
              content:
                  'OBD (On-Board Diagnostics), aracınızın elektronik beyin ünitesinden '
                  '(ECU) gerçek zamanlı veriler okumanızı sağlayan bir araç teşhis sistemidir.\n\n'
                  'OBD-II portu, 1996 ve sonrası üretilen tüm araçlarda standart olarak bulunur. '
                  'Bu port genellikle direksiyon kolonunun altında, sürücü tarafında yer alır.\n\n'
                  'Bu uygulama, bir OBD-II Bluetooth adaptörü aracılığıyla aracınızın '
                  'ECU\'suna bağlanarak motor verileri, arıza kodları ve performans '
                  'bilgilerini okumanızı sağlar.',
            ),

            const SizedBox(height: 20),

            // Bölüm 2: İlk Kurulum
            _buildSection(
              icon: Icons.settings_suggest,
              color: Colors.orange,
              title: 'İlk Kurulum',
              content: '',
              steps: const [
                'OBD-II Bluetooth adaptörünü aracınızın OBD portuna takın. '
                    'Port genellikle direksiyon altında, sürücü tarafındadır.',
                'Aracınızın kontağını açık (ON) konumuna getirin. '
                    'Adaptördeki LED ışığın yandığını kontrol edin.',
                'Telefonunuzun Bluetooth ayarlarına gidin ve OBD cihazını eşleştirin. '
                    'Cihaz genellikle "OBDII", "ELM327" veya "V-LINK" adıyla görünür. '
                    'Şifre sorulursa "1234" veya "0000" girin.',
                'Uygulamayı açın ve "Cihazı Eşleştir" butonuna dokunun. '
                    'Eşleştirilmiş OBD cihazınızı listeden seçin.',
                'Aracınızı çalıştırın ve ana sayfadaki "OBD CİHAZINA BAĞLAN" '
                    'butonuna basın. Bağlantı kurulduktan sonra veriler otomatik okunmaya başlar.',
              ],
            ),

            const SizedBox(height: 20),

            // Bölüm 3: Uygulama Özellikleri
            _buildSection(
              icon: Icons.apps,
              color: Colors.green,
              title: 'Uygulama Özellikleri',
              content: '',
              features: [
                {
                  'icon': Icons.speed,
                  'title': 'Gösterge Paneli',
                  'desc': 'Hız, devir, sıcaklık, voltaj gibi temel verileri '
                      'analog göstergelerle gerçek zamanlı olarak gösterir. '
                      'Yatay modda tam ekran deneyimi sunar.',
                },
                {
                  'icon': Icons.bolt,
                  'title': 'Performans',
                  'desc': '0-100 km/h hızlanma süresi, motor gücü tahmini '
                      've performans metrikleri ile aracınızın yeteneklerini ölçün.',
                },
                {
                  'icon': Icons.grid_view,
                  'title': 'Veri Gridi',
                  'desc': 'Motor sıcaklığı, yakıt seviyesi, gaz kelebeği konumu, '
                      'ateşleme zamanlaması dahil tüm OBD parametrelerini tek ekranda görün.',
                },
                {
                  'icon': Icons.warning_amber,
                  'title': 'Arıza Kodları',
                  'desc': 'Araçtaki DTC (Diagnostic Trouble Code) arıza kodlarını '
                      'okuyun, açıklamalarını gösterin ve silin.',
                },
                {
                  'icon': Icons.info_outline,
                  'title': 'Araç Bilgisi',
                  'desc': 'VIN numarası, yazdaki protokol türü ve ECU bilgileri '
                      'gibi araç kimlik bilgilerini görüntüleyin.',
                },
                {
                  'icon': Icons.code,
                  'title': 'AI Kod Analizi',
                  'desc': 'Arıza kodlarını yapay zeka ile analiz ettirin. '
                      'Olası nedenler, çözüm önerileri ve detaylı açıklamalar alın.',
                },
                {
                  'icon': Icons.flag,
                  'title': 'Yarış Modu',
                  'desc': 'Hızlanma ve hız testleri yaparak aracınızın '
                      'performans istatistiklerini kaydedin.',
                },
              ],
            ),

            const SizedBox(height: 20),

            // Bölüm 4: Veri Okuma
            _buildSection(
              icon: Icons.sync,
              color: Colors.blue,
              title: 'Veri Okuma Nasıl Çalışır?',
              content:
                  'Uygulama, Bluetooth üzerinden OBD adaptörüne bağlandıktan sonra, '
                  'aracın ECU\'suna standart OBD-II PID (Parameter ID) komutları gönderir.\n\n'
                  '• Her 500 milisaniyede bir güncel veriler okunur\n'
                  '• Hız, devir, sıcaklık gibi kritik veriler anlık güncellenir\n'
                  '• Motor kapalıyken bağlantı kurulamaz\n'
                  '• Kontak açık olmalıdır (motor çalışıyor olmalı)\n\n'
                  'OBD adaptörü, ECU\'dan gelen ham verileri Bluetooth üzerinden '
                  'telefona iletir. Uygulama bu verileri anlamlı değerlere '
                  'dönüştürerek ekranda gösterir.',
            ),

            const SizedBox(height: 20),

            // Bölüm 5: Sorun Giderme
            _buildSection(
              icon: Icons.build_circle,
              color: Colors.amber,
              title: 'Sorun Giderme',
              content: '',
              troubleshooting: const [
                {
                  'problem': 'OBD cihazı Bluetooth listesinde görünmüyor',
                  'solution': 'Cihazın araca takılı ve kontağın açık olduğundan emin olun. '
                      'Telefonun Bluetooth\'unu kapatıp açmayı deneyin.',
                },
                {
                  'problem': 'Bağlantı kurulamıyor',
                  'solution': 'Aracın motorunun çalışır durumda olduğunu kontrol edin. '
                      'OBD adaptörünü çıkarıp tekrar takın. Bluetooth eşleştirmesini '
                      'silip yeniden yapın.',
                },
                {
                  'problem': 'Veri okunamıyor veya değerler 0 gösteriyor',
                  'solution': 'Motor çalışıyor olmalıdır. Bazı araçlar belirli PID\'leri '
                      'desteklemeyebilir. Bağlantıyı kesip tekrar bağlanmayı deneyin.',
                },
                {
                  'problem': 'Bağlantı kopuyor',
                  'solution': 'OBD adaptörünün OBD portuna tam oturduğundan emin olun. '
                      'Telefonun Bluetooth menzilinde (yaklaşık 10 metre) olduğundan emin olun.',
                },
              ],
            ),

            const SizedBox(height: 20),

            // Bölüm 6: Uyarılar
            _buildSection(
              icon: Icons.warning,
              color: Colors.red,
              title: 'Önemli Uyarılar',
              content:
                  '⚠️ Motor sıcaklığı 100°C\'yi aştığında araç ekranındaki değer '
                  'kırmızıya döner. Bu durumda aracı durdurmanız ve soğumasını '
                  'beklemeniz önerilir.\n\n'
                  '⚠️ Sürüş sırasında uygulamayı kullanmak dikkatinizi dağıtabilir. '
                  'Güvenlik için aracı durdurup kullanmanız tavsiye edilir.\n\n'
                  '⚠️ Arıza kodu silme işlemi, check engine ışığını söndürür. '
                  'Ancak sorunun kendisi çözülmezse kod tekrar oluşacaktır.\n\n'
                  '⚠️ OBD adaptörünü uzun süre araca takılı bırakmak, aküden '
                  'enerji çekebilir. Kullanmadığınızda çıkarmanız önerilir.',
            ),

            const SizedBox(height: 40),

            // Alt bilgi
            Center(
              child: Column(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.cyan.withOpacity(0.3), size: 24),
                  const SizedBox(height: 8),
                  Text(
                    'OBD Araç Diagnostik v1.0',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tüm OBD-II uyumlu araçlarla çalışır',
                    style: TextStyle(color: Colors.grey[700], fontSize: 11),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
    List<String>? steps,
    List<Map<String, dynamic>>? features,
    List<Map<String, String>>? troubleshooting,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // İçerik
          if (content.isNotEmpty)
            Text(
              content,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                height: 1.6,
              ),
            ),

          // Adımlar
          if (steps != null)
            ...steps.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

          // Özellikler
          if (features != null)
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(f['icon'] as IconData,
                            color: color, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f['title'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                f['desc'] as String,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),

          // Sorun giderme
          if (troubleshooting != null)
            ...troubleshooting.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.amber[600], size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                t['problem']!,
                                style: TextStyle(
                                  color: Colors.amber[400],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            t['solution']!,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
