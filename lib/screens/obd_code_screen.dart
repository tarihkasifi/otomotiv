// OBD-II Kod Analizi Ekranı
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../data/obd_codes.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import '../widgets/diagnosis_result_view.dart';
import '../utils/responsive.dart';

class OBDCodeScreen extends StatefulWidget {
  const OBDCodeScreen({super.key});

  @override
  State<OBDCodeScreen> createState() => _OBDCodeScreenState();
}

class _OBDCodeScreenState extends State<OBDCodeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GeminiService _geminiService = GeminiService();

  OBDCode? _selectedCode;
  bool _isAnalyzing = false;
  DiagnosisResult? _result;

  List<OBDCode> get _searchResults {
    if (_searchController.text.length < 2) return [];
    return searchOBDCode(_searchController.text);
  }

  void _selectCode(OBDCode code) {
    setState(() {
      _selectedCode = code;
      _searchController.text = code.code;
      _result = null;
    });
  }

  Future<void> _analyze() async {
    if (_selectedCode == null) return;

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    try {
      final provider = Provider.of<VehicleProvider>(context, listen: false);
      final result = await _geminiService.analyzeOBDCode(
        provider.vehicleInfo,
        _selectedCode!.code,
        _selectedCode!.description,
      );
      setState(() => _result = result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analiz hatası: $e')),
      );
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = Provider.of<VehicleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('📟 OBD-II Kodu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DesktopContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Araç bilgisi
              _buildVehicleCard(vehicle),
              const SizedBox(height: 24),

              // Arama
              _buildSearchSection(),
              const SizedBox(height: 16),

              // Arama sonuçları
              if (_searchResults.isNotEmpty && _selectedCode == null)
                _buildSearchResults(),

              // Seçili kod
              if (_selectedCode != null) ...[
                _buildSelectedCode(),
                const SizedBox(height: 16),
                _buildAnalyzeButton(),
              ],

              // Boş durum
              if (_searchResults.isEmpty && _selectedCode == null)
                _buildEmptyState(),

              const SizedBox(height: 24),

              // Sonuçlar
              if (_result != null) DiagnosisResultView(result: _result!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleProvider vehicle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_car, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              vehicle.vehicleInfo.displayName,
              style: const TextStyle(color: AppColors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔍 OBD-II Kodu Ara',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          style: const TextStyle(color: AppColors.textPrimary),
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: 'Kod veya açıklama ara... (örn: P0300)',
            prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.textMuted),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _selectedCode = null);
                    },
                  )
                : null,
          ),
          onChanged: (_) => setState(() => _selectedCode = null),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_searchResults.length} sonuç bulundu',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ..._searchResults.map((code) => _buildCodeItem(code)),
      ],
    );
  }

  Widget _buildCodeItem(OBDCode code) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _selectCode(code),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    code.code,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: getSeverityColor(code.severity),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      getSeverityText(code.severity),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                code.description,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              Text(
                code.category,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCode() {
    final code = _selectedCode!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                code.code,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getSeverityColor(code.severity),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  getSeverityText(code.severity),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            code.description,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
          const Divider(color: AppColors.border, height: 24),
          const Text(
            'Olası Nedenler:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...code.possibleCauses.map((cause) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.chevron_right,
                        size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(cause,
                            style:
                                const TextStyle(color: AppColors.textPrimary))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 32),
        const Icon(Icons.qr_code_scanner, size: 64, color: AppColors.textMuted),
        const SizedBox(height: 16),
        const Text(
          'Hata kodunu arayın veya\nveritabanından seçin',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted),
        ),
        const SizedBox(height: 24),
        const Text(
          'Popüler Kodlar:',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['P0300', 'P0420', 'P0171', 'P0335', 'P0700'].map((code) {
            return ActionChip(
              label: Text(code),
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
              labelStyle: const TextStyle(color: AppColors.primary),
              onPressed: () {
                final found = obdCodes.firstWhere((c) => c.code == code);
                _selectCode(found);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return ElevatedButton(
      onPressed: _isAnalyzing ? null : _analyze,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isAnalyzing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology),
                SizedBox(width: 8),
                Text('AI ile Detaylı Analiz', style: TextStyle(fontSize: 16)),
              ],
            ),
    );
  }
}
