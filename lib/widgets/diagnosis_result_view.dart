// Teşhis Sonucu Widget'ı
import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';

class DiagnosisResultView extends StatelessWidget {
  final DiagnosisResult result;

  const DiagnosisResultView({super.key, required this.result});

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Düşük': return AppColors.success;
      case 'Orta': return AppColors.warning;
      case 'Yüksek': return AppColors.error;
      case 'Kritik': return AppColors.critical;
      default: return AppColors.textMuted;
    }
  }

  Color _getUrgencyColor(String urgency) {
    if (urgency.contains('Acil')) return AppColors.error;
    if (urgency.contains('Yakın')) return AppColors.warning;
    return AppColors.success;
  }

  IconData _getUrgencyIcon(String urgency) {
    if (urgency.contains('Acil')) return Icons.error;
    if (urgency.contains('Yakın')) return Icons.schedule;
    return Icons.calendar_today;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔍 AI Teşhis Sonucu',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Aciliyet
        _buildUrgencyCard(),
        const SizedBox(height: 16),

        // Olası Arızalar
        _buildIssuesSection(),
        const SizedBox(height: 16),

        // Öneriler
        _buildRecommendationsSection(),

        // Tahmini Maliyet
        if (result.estimatedCost != null) ...[
          const SizedBox(height: 16),
          _buildCostCard(),
        ],

        const SizedBox(height: 16),
        // Uyarı
        _buildDisclaimer(),
      ],
    );
  }

  Widget _buildUrgencyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getUrgencyColor(result.urgency), width: 2),
      ),
      child: Row(
        children: [
          Icon(
            _getUrgencyIcon(result.urgency),
            color: _getUrgencyColor(result.urgency),
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aciliyet Durumu',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              Text(
                result.urgency,
                style: TextStyle(
                  color: _getUrgencyColor(result.urgency),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIssuesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚠️ Olası Arızalar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...result.possibleIssues.map((issue) => _buildIssueCard(issue)),
      ],
    );
  }

  Widget _buildIssueCard(PossibleIssue issue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  issue.issue,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getSeverityColor(issue.severity),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  issue.severity,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            issue.description,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.pie_chart, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                'Olasılık: ${issue.probability}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💡 Öneriler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: result.recommendations.map((rec) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 18, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCostCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💰 Tahmini Maliyet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accent.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.payments, color: AppColors.accent, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.estimatedCost!,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Bu sonuçlar yapay zeka tarafından üretilmiştir ve tahmini niteliktedir. Kesin teşhis için yetkili servisinize başvurun.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
