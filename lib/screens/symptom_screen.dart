// Semptom Seçimi Ekranı
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../data/symptoms.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import '../widgets/diagnosis_result_view.dart';
import '../utils/responsive.dart';

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  final Set<String> _selectedSymptomIds = {};
  String? _expandedCategory;
  bool _isAnalyzing = false;
  DiagnosisResult? _result;

  List<Symptom> get _selectedSymptoms {
    return getAllSymptoms()
        .where((s) => _selectedSymptomIds.contains(s.id))
        .toList();
  }

  void _toggleSymptom(Symptom symptom) {
    setState(() {
      if (_selectedSymptomIds.contains(symptom.id)) {
        _selectedSymptomIds.remove(symptom.id);
      } else {
        _selectedSymptomIds.add(symptom.id);
      }
      _result = null;
    });
  }

  Future<void> _analyze() async {
    if (_selectedSymptoms.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    try {
      final provider = Provider.of<VehicleProvider>(context, listen: false);
      final symptomNames = _selectedSymptoms.map((s) => s.name).toList();
      final result = await _geminiService.analyzeSymptoms(
        provider.vehicleInfo,
        symptomNames,
        _additionalInfoController.text.isNotEmpty
            ? _additionalInfoController.text
            : null,
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
      appBar: AppBar(title: const Text('📋 Semptom Seç')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DesktopContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Araç bilgisi
              _buildVehicleCard(vehicle),
              const SizedBox(height: 16),

              // Seçili semptomlar
              if (_selectedSymptoms.isNotEmpty) _buildSelectedChips(),
              const SizedBox(height: 16),

              // Semptom kategorileri
              _buildCategories(),
              const SizedBox(height: 24),

              // Ek bilgi
              _buildAdditionalInfo(),
              const SizedBox(height: 16),

              // Analiz butonu
              _buildAnalyzeButton(),
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

  Widget _buildSelectedChips() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seçilen Semptomlar (${_selectedSymptoms.length})',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedSymptoms.map((symptom) {
              return Chip(
                label: Text(symptom.name),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                backgroundColor: AppColors.primary,
                deleteIcon:
                    const Icon(Icons.close, size: 16, color: Colors.white),
                onDeleted: () => _toggleSymptom(symptom),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📋 Semptom Seçin',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Aracınızda gözlemlediğiniz belirtileri seçin',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 16),
        ...symptomCategories.map((category) => _buildCategoryCard(category)),
      ],
    );
  }

  Widget _buildCategoryCard(SymptomCategory category) {
    final isExpanded = _expandedCategory == category.name;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedCategory = isExpanded ? null : category.name;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(_getCategoryIcon(category.name),
                      color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) _buildSymptomList(category.symptoms),
        ],
      ),
    );
  }

  Widget _buildSymptomList(List<Symptom> symptoms) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: symptoms.map((symptom) {
          final isSelected = _selectedSymptomIds.contains(symptom.id);
          return InkWell(
            onTap: () => _toggleSymptom(symptom),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                border:
                    const Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symptom.name,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          symptom.description,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isSelected ? AppColors.success : AppColors.textMuted,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💬 Ek Bilgi (Opsiyonel)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _additionalInfoController,
          maxLines: 3,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Arıza hakkında ek detaylar yazın...',
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    final isEnabled = _selectedSymptoms.isNotEmpty && !_isAnalyzing;

    return ElevatedButton(
      onPressed: isEnabled ? _analyze : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isAnalyzing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.psychology),
                const SizedBox(width: 8),
                Text(
                  'AI ile Analiz Et (${_selectedSymptoms.length} semptom)',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Motor Sesleri':
        return Icons.volume_up;
      case 'Fren Sistemi':
        return Icons.no_crash;
      case 'Süspansiyon':
        return Icons.swap_vert;
      case 'Şanzıman':
        return Icons.settings;
      case 'Egzoz Sistemi':
        return Icons.cloud;
      case 'Motor Performans':
        return Icons.speed;
      case 'Elektrik Sistemi':
        return Icons.flash_on;
      case 'Soğutma Sistemi':
        return Icons.ac_unit;
      case 'Direksiyon':
        return Icons.radio_button_checked;
      default:
        return Icons.help_outline;
    }
  }
}
