// Kod Analiz Ekranı - Google AI Destekli OBD-II Kod Analizi
// Kullanıcı hata kodunu girer, Gemini AI analiz eder
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../data/obd_codes.dart';
import '../../services/gemini_service.dart';
import '../../services/sound_service.dart';

class CodeAnalysisScreen extends StatefulWidget {
  const CodeAnalysisScreen({super.key});

  @override
  State<CodeAnalysisScreen> createState() => _CodeAnalysisScreenState();
}

class _CodeAnalysisScreenState extends State<CodeAnalysisScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  final GeminiService _geminiService = GeminiService();

  bool _isAnalyzing = false;
  DiagnosisResult? _result;
  String? _analyzedCode;
  List<OBDCode> _suggestions = [];

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onCodeChanged(String value) {
    setState(() {
      _result = null;
      _analyzedCode = null;
      if (value.length >= 2) {
        _suggestions = searchOBDCode(value).take(5).toList();
      } else {
        _suggestions = [];
      }
    });
  }

  void _selectSuggestion(OBDCode code) {
    _codeController.text = code.code;
    setState(() {
      _suggestions = [];
    });
    _analyzeCode(code.code, code.description);
  }

  Future<void> _analyzeManual() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    // Veritabanında var mı kontrol et
    OBDCode? foundCode;
    try {
      foundCode = obdCodes.firstWhere((c) => c.code == code);
    } catch (_) {}

    _analyzeCode(code, foundCode?.description ?? 'Kullanıcı tarafından girilen kod');
  }

  Future<void> _analyzeCode(String code, String description) async {
    setState(() {
      _isAnalyzing = true;
      _result = null;
      _analyzedCode = code;
      _suggestions = [];
    });

    try {
      final provider = Provider.of<VehicleProvider>(context, listen: false);
      final result = await _geminiService.analyzeOBDCode(
        provider.vehicleInfo,
        code,
        description,
      );
      if (mounted) setState(() => _result = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analiz hatası: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
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
          onPressed: () {
            SoundService().playClick();
            Navigator.pop(context);
          },
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.psychology, color: Colors.cyan, size: 24),
            SizedBox(width: 8),
            Text('KOD ANALİZ',
                style: TextStyle(letterSpacing: 2, fontSize: 18)),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // AI Header
              _buildAIHeader(),
              const SizedBox(height: 20),

              // Kod Giriş Alanı
              _buildCodeInput(),
              const SizedBox(height: 8),

              // Öneriler
              if (_suggestions.isNotEmpty) _buildSuggestions(),

              const SizedBox(height: 16),

              // Analiz Et Butonu
              _buildAnalyzeButton(),

              const SizedBox(height: 16),

              // Popüler Kodlar
              if (_result == null && !_isAnalyzing) _buildPopularCodes(),

              // Yükleniyor
              if (_isAnalyzing) _buildLoadingIndicator(),

              // Sonuçlar
              if (_result != null) _buildResults(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withOpacity(0.15),
            Colors.blue.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyan.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Google AI Destekli',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'OBD-II hata kodunuzu girin, AI detaylı analiz yapsın',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isAnalyzing
              ? Colors.cyan.withOpacity(0.5)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: _codeController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
          fontFamily: 'monospace',
        ),
        textCapitalization: TextCapitalization.characters,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'P0300',
          hintStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 20,
            letterSpacing: 3,
          ),
          prefixIcon: const Icon(Icons.qr_code, color: Colors.cyan),
          suffixIcon: _codeController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _codeController.clear();
                    setState(() {
                      _suggestions = [];
                      _result = null;
                      _analyzedCode = null;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
        onChanged: _onCodeChanged,
        onSubmitted: (_) => _analyzeManual(),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withOpacity(0.2)),
      ),
      child: Column(
        children: _suggestions.map((code) {
          return InkWell(
            onTap: () {
              SoundService().playClick();
              _selectSuggestion(code);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: code != _suggestions.last
                        ? Colors.grey.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      code.code,
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      code.description,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: Colors.grey, size: 18),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: _isAnalyzing || _codeController.text.isEmpty
            ? null
            : const LinearGradient(
                colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
              ),
        color: _isAnalyzing || _codeController.text.isEmpty
            ? Colors.grey[800]
            : null,
      ),
      child: MaterialButton(
        onPressed:
            _isAnalyzing || _codeController.text.isEmpty ? null : _analyzeManual,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: _isAnalyzing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('AI Analiz Ediyor...',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.psychology, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text('AI ile Analiz Et',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
      ),
    );
  }

  Widget _buildPopularCodes() {
    final popularCodes = ['P0300', 'P0420', 'P0171', 'P0335', 'P0700', 'P0401'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'POPÜLER KODLAR',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularCodes.map((code) {
            return GestureDetector(
              onTap: () {
                SoundService().playClick();
                _codeController.text = code;
                _analyzeManual();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.cyan.withOpacity(0.2)),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    letterSpacing: 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Bilgilendirme
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber[600], size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hata kodlarını aracınızın gösterge panelinden veya OBD cihazından okuyabilirsiniz.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.cyan.withOpacity(0.2 + _pulseController.value * 0.3),
                      Colors.blue.withOpacity(0.1 + _pulseController.value * 0.2),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.2 * _pulseController.value),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.psychology,
                    color: Colors.cyan, size: 40),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            '$_analyzedCode kodu analiz ediliyor...',
            style: const TextStyle(color: Colors.cyan, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Google Gemini AI çalışıyor',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final result = _result!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              '$_analyzedCode Analiz Sonucu',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Aciliyet
        _buildUrgencyBadge(result.urgency),
        const SizedBox(height: 16),

        // Olası Sorunlar
        ...result.possibleIssues.asMap().entries.map((entry) {
          final index = entry.key;
          final issue = entry.value;
          return _buildIssueCard(issue, index + 1);
        }),

        // Öneriler
        if (result.recommendations.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildRecommendationsCard(result.recommendations),
        ],

      ],
    );
  }

  Widget _buildUrgencyBadge(String urgency) {
    Color color;
    IconData icon;
    if (urgency.contains('Acil') || urgency.contains('Kritik')) {
      color = Colors.red;
      icon = Icons.warning;
    } else if (urgency.contains('Yakın')) {
      color = Colors.orange;
      icon = Icons.schedule;
    } else {
      color = Colors.green;
      icon = Icons.check;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Aciliyet: $urgency',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(PossibleIssue issue, int number) {
    Color severityColor;
    if (issue.severity.contains('Kritik')) {
      severityColor = Colors.red;
    } else if (issue.severity.contains('Yüksek')) {
      severityColor = Colors.orange;
    } else if (issue.severity.contains('Orta')) {
      severityColor = Colors.amber;
    } else {
      severityColor = Colors.green;
    }

    Color probabilityColor;
    if (issue.probability.contains('Yüksek')) {
      probabilityColor = Colors.red;
    } else if (issue.probability.contains('Orta')) {
      probabilityColor = Colors.orange;
    } else {
      probabilityColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: severityColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık satırı
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: severityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  issue.issue,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Etiketler
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildTag('Olasılık: ${issue.probability}', probabilityColor),
              _buildTag('Ciddiyet: ${issue.severity}', severityColor),
            ],
          ),
          const SizedBox(height: 10),

          // Açıklama
          Text(
            issue.description,
            style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildRecommendationsCard(List<String> recommendations) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyan.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.cyan, size: 18),
              SizedBox(width: 8),
              Text(
                'ÖNERİLER',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.arrow_right,
                          color: Colors.cyan, size: 16),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        rec,
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

}
