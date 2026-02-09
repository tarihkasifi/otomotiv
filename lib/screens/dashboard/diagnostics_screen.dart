// Teşhis Ekranı - Arıza Kodları
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/obd_service.dart';
import '../../services/diagnostics_history_service.dart';
import '../../data/obd_codes.dart';
import '../../providers/theme_provider.dart';
import '../../utils/responsive.dart';
import 'diagnostics_history_screen.dart';

class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  final OBDService _obdService = OBDService();

  List<DTCCode> _dtcCodes = [];
  bool _isReading = false;
  bool _isClearing = false;

  Future<void> _readDTCs() async {
    if (!_obdService.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ OBD cihazına bağlı değil!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isReading = true);

    final codes = await _obdService.readDTCs();

    setState(() {
      _dtcCodes = codes;
      _isReading = false;
    });

    // Geçmişe kaydet
    final liveData = await _obdService.readLiveData();
    final record = DiagnosticRecord.create(
      vehicleName: 'OBD Bağlı Araç',
      dtcCodes: codes.map((c) => c.code).toList(),
      liveData: {
        'Hız': '${liveData.speed ?? 0} km/h',
        'RPM': '${liveData.rpm ?? 0}',
        'Sıcaklık': '${liveData.coolantTemp ?? 0}°C',
        'Gaz': '${(liveData.throttlePosition ?? 0).toInt()}%',
      },
    );
    await DiagnosticsHistoryService.saveRecord(record);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(codes.isEmpty
              ? '✅ Arıza kodu bulunamadı!'
              : '⚠️ ${codes.length} arıza kodu bulundu'),
          backgroundColor: codes.isEmpty ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  Future<void> _clearDTCs() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Arıza Kodlarını Sil?', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'Tüm arıza kodları silinecek ve check engine lambası sıfırlanacak.\n\nBu işlem geri alınamaz.',
          style: TextStyle(color: Colors.grey),
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

    if (confirm != true) return;

    setState(() => _isClearing = true);

    final success = await _obdService.clearDTCs();

    setState(() {
      _isClearing = false;
      if (success) _dtcCodes.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(success ? '✅ Arıza kodları silindi!' : '❌ Silme başarısız'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('TEŞHİS',
            style: TextStyle(
                letterSpacing: 2,
                color: isDark ? Colors.white : Colors.black87)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history,
                color: isDark ? Colors.white70 : Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DiagnosticsHistoryScreen()),
              );
            },
            tooltip: 'Geçmiş',
          ),
        ],
      ),
      body: DesktopContentWrapper(
        child: Column(
          children: [
            // Butonlar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isReading ? null : _readDTCs,
                      icon: _isReading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search),
                      label: Text(_isReading ? 'Okunuyor...' : 'ARIZA KODU OKU'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          (_isClearing || _dtcCodes.isEmpty) ? null : _clearDTCs,
                      icon: _isClearing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.delete_sweep),
                      label: Text(_isClearing ? 'Siliniyor...' : 'KODLARI SİL'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Durum kartı
            _buildStatusCard(),

            // DTC listesi
            Expanded(
              child: _dtcCodes.isEmpty ? _buildEmptyState() : _buildDTCList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final hasErrors = _dtcCodes.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasErrors
              ? [Colors.red.withOpacity(0.2), const Color(0xFF1A1A2E)]
              : [Colors.green.withOpacity(0.2), const Color(0xFF1A1A2E)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasErrors
              ? Colors.red.withOpacity(0.5)
              : Colors.green.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hasErrors
                  ? Colors.red.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasErrors ? Icons.warning : Icons.check_circle,
              color: hasErrors ? Colors.red : Colors.green,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasErrors ? 'ARIZA TESPİT EDİLDİ' : 'SORUN YOK',
                  style: TextStyle(
                    color: hasErrors ? Colors.red : Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  hasErrors
                      ? '${_dtcCodes.length} arıza kodu bulundu'
                      : 'Araçta aktif arıza kodu yok',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build_circle, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            'Arıza kodu okumak için\n"ARIZA KODU OKU" butonuna basın',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDTCList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _dtcCodes.length,
      itemBuilder: (context, index) {
        final dtc = _dtcCodes[index];
        return _buildDTCCard(dtc);
      },
    );
  }

  Widget _buildDTCCard(DTCCode dtc) {
    // OBD kodları listesinden açıklamayı bul
    final obdCode = obdCodes.firstWhere(
      (c) => c.code == dtc.code,
      orElse: () => OBDCode(
        code: dtc.code,
        description: 'Bilinmeyen arıza kodu',
        category: 'Genel',
        severity: 'medium',
        possibleCauses: [],
      ),
    );

    Color severityColor;
    switch (obdCode.severity) {
      case 'high':
        severityColor = Colors.red;
        break;
      case 'medium':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = Colors.yellow;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: ExpansionTile(
        leading: GestureDetector(
          onTap: () => _showAIDetailPopup(dtc, obdCode, severityColor),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.error_outline, color: severityColor),
          ),
        ),
        title: GestureDetector(
          onTap: () => _showAIDetailPopup(dtc, obdCode, severityColor),
          child: Row(
            children: [
              Text(
                dtc.code,
                style: TextStyle(
                  color: severityColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 12, color: Colors.cyan),
                    SizedBox(width: 4),
                    Text('AI',
                        style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          obdCode.description,
          style: TextStyle(color: Colors.grey[400]),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olası Nedenler:',
                  style: TextStyle(
                      color: Colors.grey[300], fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...obdCode.possibleCauses.map((cause) => Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_right,
                              color: severityColor, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(cause,
                                style: TextStyle(color: Colors.grey[400])),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showAIDetailPopup(dtc, obdCode, severityColor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.withOpacity(0.2),
                      foregroundColor: Colors.cyan,
                      side: const BorderSide(color: Colors.cyan),
                    ),
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: const Text('AI ile Detaylı Analiz'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAIDetailPopup(DTCCode dtc, OBDCode obdCode, Color severityColor) {
    showDialog(
      context: context,
      builder: (context) => _AIDetailDialog(
        dtcCode: dtc.code,
        description: obdCode.description,
        category: obdCode.category,
        severity: obdCode.severity,
        possibleCauses: obdCode.possibleCauses,
        severityColor: severityColor,
      ),
    );
  }
}

class _AIDetailDialog extends StatefulWidget {
  final String dtcCode;
  final String description;
  final String category;
  final String severity;
  final List<String> possibleCauses;
  final Color severityColor;

  const _AIDetailDialog({
    required this.dtcCode,
    required this.description,
    required this.category,
    required this.severity,
    required this.possibleCauses,
    required this.severityColor,
  });

  @override
  State<_AIDetailDialog> createState() => _AIDetailDialogState();
}

class _AIDetailDialogState extends State<_AIDetailDialog> {
  bool _isLoading = true;
  String _aiAnalysis = '';
  String _symptoms = '';
  String _solutions = '';
  String _cost = '';

  @override
  void initState() {
    super.initState();
    _fetchAIAnalysis();
  }

  Future<void> _fetchAIAnalysis() async {
    // Yapay zeka analizi için hazır veritabanı kullan
    // Gerçek API çağrısı yerine lokal analiz
    await Future.delayed(const Duration(milliseconds: 500));

    final analysis = _getLocalAnalysis(widget.dtcCode);

    if (mounted) {
      setState(() {
        _aiAnalysis = analysis['analysis'] ??
            'Bu arıza kodu hakkında detaylı bilgi bulunamadı.';
        _symptoms = analysis['symptoms'] ?? 'Belirtiler tanımlanmamış.';
        _solutions = analysis['solutions'] ?? 'Çözüm önerisi bulunamadı.';
        _cost = analysis['cost'] ?? 'Maliyet bilgisi yok.';
        _isLoading = false;
      });
    }
  }

  Map<String, String> _getLocalAnalysis(String code) {
    // Yaygın arıza kodları için hazır analiz
    final analyses = <String, Map<String, String>>{
      'P0300': {
        'analysis':
            'Motor ateşleme sisteminizde rastgele silindir ateşleme problemi tespit edildi. Bu, birden fazla silindirin düzensiz çalıştığını gösterir.',
        'symptoms':
            '• Motor titremesi ve sarsılması\n• Güç kaybı\n• Yakıt tüketiminde artış\n• Egzoz dumanı\n• Check Engine ışığı yanıp sönme',
        'solutions':
            '1. Bujileri kontrol edin ve gerekirse değiştirin\n2. Ateşleme bobinlerini test edin\n3. Yakıt enjektörlerini temizleyin\n4. Hava filtresi ve MAF sensörünü kontrol edin\n5. Vakum kaçaklarını arayın',
        'cost': 'Tahmini Maliyet: 500₺ - 3.000₺',
      },
      'P0171': {
        'analysis':
            'Motor yakıt karışımı çok fakir. Hava/yakıt oranı normalden fazla hava içeriyor.',
        'symptoms':
            '• Rölantide sarsılma\n• Hızlanma zorluğu\n• Motor stop etme\n• Düzensiz rölanti devri',
        'solutions':
            '1. Vakum hortumlarını kontrol edin\n2. MAF sensörünü temizleyin\n3. Yakıt pompası basıncını test edin\n4. Oksijen sensörünü kontrol edin\n5. Enjektörleri temizleyin',
        'cost': 'Tahmini Maliyet: 300₺ - 2.000₺',
      },
      'P0420': {
        'analysis':
            'Katalitik konvertör verimliliği düşük. Egzoz emisyonları normalin üzerinde.',
        'symptoms':
            '• Egzoz kokusu\n• Güç kaybı\n• Yakıt tüketiminde artış\n• Emisyon testinden kalma',
        'solutions':
            '1. Oksijen sensörlerini kontrol edin\n2. Egzoz kaçaklarını arayın\n3. Katalitik konvertörü temizleyin\n4. Gerekirse katalitik konvertörü değiştirin',
        'cost': 'Tahmini Maliyet: 2.000₺ - 8.000₺',
      },
      'P0401': {
        'analysis':
            'EGR (Egzoz Gazı Geri Dönüşüm) sistemi yeterli akış sağlamıyor.',
        'symptoms':
            '• Motor vuruntu sesi\n• Rölanti sorunları\n• Performans düşüşü\n• NOx emisyonları yüksek',
        'solutions':
            '1. EGR valfini temizleyin\n2. EGR borularını kontrol edin\n3. EGR valfinin hareketini test edin\n4. Karbon birikintilerini temizleyin\n5. Gerekirse EGR valfini değiştirin',
        'cost': 'Tahmini Maliyet: 500₺ - 2.500₺',
      },
      'P0442': {
        'analysis':
            'EVAP sisteminde küçük bir kaçak tespit edildi. Yakıt buharı atmosfere kaçıyor.',
        'symptoms':
            '• Yakıt kokusu\n• Yakıt tüketiminde hafif artış\n• Check Engine ışığı',
        'solutions':
            '1. Yakıt deposu kapağını kontrol edin\n2. EVAP hortumlarını inceleyin\n3. EVAP kanister valfini test edin\n4. Duman testi ile kaçağı bulun',
        'cost': 'Tahmini Maliyet: 200₺ - 1.000₺',
      },
      'P0128': {
        'analysis':
            'Motor soğutma suyu sıcaklığı normal çalışma aralığının altında kalıyor.',
        'symptoms':
            '• Isıtıcı iyi çalışmıyor\n• Yakıt tüketimi artışı\n• Soğuk hava sürüşünde performans kaybı',
        'solutions':
            '1. Termostatı kontrol edin ve değiştirin\n2. Soğutma suyu seviyesini kontrol edin\n3. Soğutma suyu sıcaklık sensörünü test edin\n4. Radyatör fanını kontrol edin',
        'cost': 'Tahmini Maliyet: 300₺ - 800₺',
      },
      'P0455': {
        'analysis':
            'EVAP sisteminde büyük bir kaçak tespit edildi. Yakıt buharı önemli miktarda kaçıyor.',
        'symptoms':
            '• Belirgin yakıt kokusu\n• Check Engine ışığı sürekli yanık\n• Emisyon testi başarısız',
        'solutions':
            '1. Yakıt deposu kapağını değiştirin\n2. EVAP hortum bağlantılarını kontrol edin\n3. Yakıt deposu ve boyun bağlantısını inceleyin\n4. EVAP sistemi duman testi yapın',
        'cost': 'Tahmini Maliyet: 150₺ - 800₺',
      },
      'P0174': {
        'analysis':
            'Bank 2 yakıt karışımı çok fakir. Çift sıralı motorlarda ikinci silindir grubunda sorun.',
        'symptoms':
            '• Motor titremesi\n• Hızlanma sırasında sarsılma\n• Rölantide düzensizlik\n• Egzoz kokusu',
        'solutions':
            '1. Bank 2 tarafındaki vakum kaçaklarını arayın\n2. MAF sensörünü temizleyin\n3. Bank 2 oksijen sensörünü kontrol edin\n4. Enjektörleri test edin',
        'cost': 'Tahmini Maliyet: 400₺ - 2.500₺',
      },
    };

    if (analyses.containsKey(code)) {
      return analyses[code]!;
    }

    // Genel analiz
    final codePrefix = code.isNotEmpty ? code[0] : 'P';
    String category = 'Genel';
    switch (codePrefix) {
      case 'P':
        category = 'Güç Aktarma/Motor';
        break;
      case 'B':
        category = 'Gövde/Karoseri';
        break;
      case 'C':
        category = 'Şasi/Fren/Direksiyon';
        break;
      case 'U':
        category = 'İletişim/Ağ';
        break;
    }

    return {
      'analysis':
          'Bu $category kategorisinde bir arıza kodudur. Detaylı teşhis için profesyonel bir oto servisine başvurmanız önerilir.',
      'symptoms':
          '• Check Engine ışığı yanık\n• Aracın performansını etkileyebilir\n• Yakıt tüketimini artırabilir',
      'solutions':
          '1. OBD verilerini profesyonel diagnoz cihazıyla doğrulayın\n2. İlgili sensör ve bileşenleri kontrol edin\n3. Üreticinin teknik bültenlerini inceleyin\n4. Sertifikalı bir teknisyene danışın',
      'cost': 'Tahmini Maliyet: Teşhise bağlı',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0D0D1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.severityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.auto_awesome, color: Colors.cyan, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dtcCode,
                        style: TextStyle(
                          color: widget.severityColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        'AI Arıza Analizi',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              widget.description,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Content
            Flexible(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.cyan),
                          SizedBox(height: 16),
                          Text('AI analiz yapıyor...',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                              '🔍 Detaylı Analiz', _aiAnalysis, Colors.cyan),
                          const SizedBox(height: 12),
                          _buildSection(
                              '⚠️ Belirtiler', _symptoms, Colors.orange),
                          const SizedBox(height: 12),
                          _buildSection(
                              '🔧 Çözüm Önerileri', _solutions, Colors.green),
                          const SizedBox(height: 12),
                          _buildSection(
                              '💰 Tahmini Maliyet', _cost, Colors.purple),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style:
                TextStyle(color: Colors.grey[300], fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
