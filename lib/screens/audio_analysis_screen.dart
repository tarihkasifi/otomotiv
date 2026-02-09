// Ses Analizi Ekranı
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../services/audio_service.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import '../widgets/diagnosis_result_view.dart';
import '../utils/responsive.dart';

class AudioAnalysisScreen extends StatefulWidget {
  const AudioAnalysisScreen({super.key});

  @override
  State<AudioAnalysisScreen> createState() => _AudioAnalysisScreenState();
}

class _AudioAnalysisScreenState extends State<AudioAnalysisScreen> {
  final AudioStreamService _audioService = AudioStreamService();
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isRecording = false;
  bool _isAnalyzing = false;
  bool _hasRecording = false;
  int _recordingSeconds = 0;
  DiagnosisResult? _result;

  @override
  void dispose() {
    _audioService.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _audioService.stopRecording();
      setState(() {
        _isRecording = false;
        _hasRecording = true;
      });
    } else {
      final started = await _audioService.startRecording();
      if (started) {
        setState(() {
          _isRecording = true;
          _recordingSeconds = 0;
          _result = null;
          _hasRecording = false;
        });
        _startTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mikrofon erişimi sağlanamadı')),
        );
      }
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRecording && mounted) {
        setState(() => _recordingSeconds++);
        return true;
      }
      return false;
    });
  }

  Future<void> _analyze() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen ses tanımı girin')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    try {
      final provider = Provider.of<VehicleProvider>(context, listen: false);
      final result = await _geminiService.analyzeAudioDescription(
        provider.vehicleInfo,
        _descriptionController.text,
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

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = Provider.of<VehicleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('🎤 Ses Analizi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DesktopContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildVehicleCard(vehicle),
              const SizedBox(height: 24),
              _buildRecordingSection(),
              const SizedBox(height: 24),
              _buildDescriptionSection(),
              const SizedBox(height: 24),
              _buildAnalyzeButton(),
              const SizedBox(height: 24),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingSection() {
    return Column(
      children: [
        const Text(
          'Motor çalışırken veya arıza sesi duyulurken kayıt yapın',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _toggleRecording,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _isRecording
                    ? [AppColors.error, AppColors.error.withOpacity(0.7)]
                    : [AppColors.primary, AppColors.critical],
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isRecording ? AppColors.error : AppColors.primary)
                      .withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  size: 48,
                  color: Colors.white,
                ),
                if (_isRecording) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(_recordingSeconds),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _isRecording
              ? 'Durdurmak için dokunun'
              : _hasRecording
                  ? '✓ Kayıt tamamlandı'
                  : 'Kayıt başlatmak için dokunun',
          style: TextStyle(
            color: _hasRecording ? AppColors.success : AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📝 Ses Tanımı',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Duyduğunuz sesi detaylı olarak açıklayın',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Örn: Motor çalışırken ön taraftan metalik vuruntu sesi geliyor...',
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return ElevatedButton(
      onPressed: _isAnalyzing ? null : _analyze,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isAnalyzing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology),
                SizedBox(width: 8),
                Text('AI ile Analiz Et', style: TextStyle(fontSize: 16)),
              ],
            ),
    );
  }
}
