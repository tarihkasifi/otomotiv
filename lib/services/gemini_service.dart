// Google Gemini AI Servisi - HTTP API
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/vehicle_provider.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyAr3I4HknYJn9VXuLxu8OtfSOGtCtdaZiY';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  
  String _formatVehicleInfo(VehicleInfo vehicle) {
    String info = '${vehicle.brand} ${vehicle.model}';
    if (vehicle.year != null) info += ' (${vehicle.year} model)';
    info += ' - Yakıt: ${vehicle.fuelType}';
    return info;
  }

  // Ses tanımı analizi
  Future<DiagnosisResult> analyzeAudioDescription(
    VehicleInfo vehicle,
    String audioDescription,
  ) async {
    final prompt = '''Sen deneyimli bir otomotiv ustasısın. Aşağıdaki araç ve ses tanımına göre olası arızaları tespit et.

Araç: ${_formatVehicleInfo(vehicle)}

Ses Tanımı/Açıklama: $audioDescription

Lütfen JSON formatında yanıt ver:
{
  "possibleIssues": [
    {
      "issue": "Arıza adı",
      "probability": "Yüksek/Orta/Düşük",
      "severity": "Düşük/Orta/Yüksek/Kritik",
      "description": "Arıza açıklaması"
    }
  ],
  "recommendations": ["Öneri 1", "Öneri 2"],
  "estimatedCost": "Tahmini maliyet aralığı (TL)",
  "urgency": "Acil/Yakın Zamanda/Rutin Bakımda"
}

Sadece JSON formatında yanıt ver, başka açıklama ekleme.''';

    return _callGeminiAPI(prompt);
  }

  // OBD kodu analizi
  Future<DiagnosisResult> analyzeOBDCode(
    VehicleInfo vehicle,
    String obdCode,
    String codeDescription,
  ) async {
    final prompt = '''Sen deneyimli bir otomotiv ustasısın. Aşağıdaki araç ve OBD-II hata koduna göre detaylı analiz yap.

Araç: ${_formatVehicleInfo(vehicle)}

OBD-II Kodu: $obdCode
Kod Açıklaması: $codeDescription

Lütfen JSON formatında yanıt ver:
{
  "possibleIssues": [
    {
      "issue": "Arıza adı",
      "probability": "Yüksek/Orta/Düşük",
      "severity": "Düşük/Orta/Yüksek/Kritik",
      "description": "Bu araç modeline özel detaylı açıklama"
    }
  ],
  "recommendations": ["Öneri 1", "Öneri 2"],
  "estimatedCost": "Tahmini maliyet aralığı (TL)",
  "urgency": "Acil/Yakın Zamanda/Rutin Bakımda"
}

Sadece JSON formatında yanıt ver.''';

    return _callGeminiAPI(prompt);
  }

  // Semptom bazlı analiz
  Future<DiagnosisResult> analyzeSymptoms(
    VehicleInfo vehicle,
    List<String> symptoms,
    String? additionalInfo,
  ) async {
    final symptomList = symptoms.asMap().entries
        .map((e) => '${e.key + 1}. ${e.value}')
        .join('\n');

    final prompt = '''Sen deneyimli bir otomotiv ustasısın. Aşağıdaki araç ve semptomlarına göre olası arızaları tespit et.

Araç: ${_formatVehicleInfo(vehicle)}

Belirtilen Semptomlar:
$symptomList

${additionalInfo != null ? 'Ek Bilgi: $additionalInfo' : ''}

Bu semptomların birlikte değerlendirilmesiyle olası arızaları tespit et.

Lütfen JSON formatında yanıt ver:
{
  "possibleIssues": [
    {
      "issue": "Arıza adı",
      "probability": "Yüksek/Orta/Düşük",
      "severity": "Düşük/Orta/Yüksek/Kritik",
      "description": "Detaylı açıklama"
    }
  ],
  "recommendations": ["Öneri 1", "Öneri 2"],
  "estimatedCost": "Tahmini maliyet aralığı (TL)",
  "urgency": "Acil/Yakın Zamanda/Rutin Bakımda"
}

Sadece JSON formatında yanıt ver.''';

    return _callGeminiAPI(prompt);
  }

  // Ustaya Sor - Sohbet
  Future<String> askMechanic(
    VehicleInfo vehicle,
    String question,
    List<dynamic> previousMessages,
  ) async {
    // Sohbet geçmişini oluştur
    String chatHistory = '';
    for (var msg in previousMessages.take(10)) {
      final role = msg.isUser ? 'Kullanıcı' : 'Usta';
      chatHistory += '$role: ${msg.text}\n';
    }

    final prompt = '''Sen deneyimli ve yardımsever bir otomotiv ustasısın. Adın "AI Usta".
Türkçe konuşuyorsun ve samimi bir üslupla cevap veriyorsun.

Araç: ${_formatVehicleInfo(vehicle)}

${chatHistory.isNotEmpty ? 'Önceki sohbet:\n$chatHistory\n' : ''}

Kullanıcının sorusu: $question

Lütfen bu soruya yardımcı ol. Teknik terimleri açıkla, güvenlik uyarılarını belirt ve gerekirse servise gitmeyi öner.
Kısa ve öz cevaplar ver, gereksiz uzatma.''';

    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.8,
          'maxOutputTokens': 1024,
        }
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] as String;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error']?['message'] ?? 'Bilinmeyen hata');
      }
    } catch (e) {
      return 'Üzgünüm, şu anda yanıt veremiyorum. Hata: $e';
    }
  }

  Future<DiagnosisResult> _callGeminiAPI(String prompt) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 2048,
        }
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
        
        // JSON'u parse et
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
        if (jsonMatch != null) {
          final jsonData = json.decode(jsonMatch.group(0)!);
          return DiagnosisResult.fromJson(jsonData);
        }
        throw Exception('JSON parse hatası');
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Bilinmeyen hata';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('AI analiz hatası: $e');
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      
      return DiagnosisResult(
        possibleIssues: [
          PossibleIssue(
            issue: 'Analiz Yapılamadı',
            probability: 'Bilinmiyor',
            severity: 'Orta',
            description: 'Hata: $errorMessage',
          ),
        ],
        recommendations: ['Tekrar deneyin', 'İnternet bağlantınızı kontrol edin'],
        urgency: 'Bilinmiyor',
      );
    }
  }
}

// Veri modelleri
class DiagnosisResult {
  final List<PossibleIssue> possibleIssues;
  final List<String> recommendations;
  final String? estimatedCost;
  final String urgency;

  DiagnosisResult({
    required this.possibleIssues,
    required this.recommendations,
    this.estimatedCost,
    required this.urgency,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      possibleIssues: (json['possibleIssues'] as List)
          .map((e) => PossibleIssue.fromJson(e))
          .toList(),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      estimatedCost: json['estimatedCost'],
      urgency: json['urgency'] ?? 'Bilinmiyor',
    );
  }
}

class PossibleIssue {
  final String issue;
  final String probability;
  final String severity;
  final String description;

  PossibleIssue({
    required this.issue,
    required this.probability,
    required this.severity,
    required this.description,
  });

  factory PossibleIssue.fromJson(Map<String, dynamic> json) {
    return PossibleIssue(
      issue: json['issue'] ?? '',
      probability: json['probability'] ?? 'Bilinmiyor',
      severity: json['severity'] ?? 'Orta',
      description: json['description'] ?? '',
    );
  }
}
