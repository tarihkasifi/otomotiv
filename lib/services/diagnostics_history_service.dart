// Teşhis Geçmişi Servisi - SharedPreferences ile lokal depolama
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DiagnosticsHistoryService {
  static const String _historyKey = 'diagnostics_history';
  static const int _maxRecords = 50;

  // Teşhis kaydı modeli
  static Future<void> saveRecord(DiagnosticRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    // Yeni kaydı başa ekle
    history.insert(0, record);

    // Maksimum 50 kayıt tut
    if (history.length > _maxRecords) {
      history.removeRange(_maxRecords, history.length);
    }

    // JSON olarak kaydet
    final jsonList = history.map((r) => r.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  static Future<List<DiagnosticRecord>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => DiagnosticRecord.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  static Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    history.removeWhere((r) => r.id == id);

    final jsonList = history.map((r) => r.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }
}

// Teşhis Kaydı Modeli
class DiagnosticRecord {
  final String id;
  final DateTime timestamp;
  final String vehicleName;
  final List<String> dtcCodes;
  final Map<String, String> liveData;
  final String? notes;
  final DiagnosticStatus status;

  DiagnosticRecord({
    required this.id,
    required this.timestamp,
    required this.vehicleName,
    required this.dtcCodes,
    required this.liveData,
    this.notes,
    required this.status,
  });

  factory DiagnosticRecord.fromJson(Map<String, dynamic> json) {
    return DiagnosticRecord(
      id: json['id'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      vehicleName: json['vehicleName'] ?? 'Bilinmeyen Araç',
      dtcCodes: List<String>.from(json['dtcCodes'] ?? []),
      liveData: Map<String, String>.from(json['liveData'] ?? {}),
      notes: json['notes'],
      status: DiagnosticStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => DiagnosticStatus.unknown,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'vehicleName': vehicleName,
      'dtcCodes': dtcCodes,
      'liveData': liveData,
      'notes': notes,
      'status': status.name,
    };
  }

  // Yardımcı factory constructor
  static DiagnosticRecord create({
    required String vehicleName,
    required List<String> dtcCodes,
    Map<String, String>? liveData,
    String? notes,
  }) {
    return DiagnosticRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      vehicleName: vehicleName,
      dtcCodes: dtcCodes,
      liveData: liveData ?? {},
      notes: notes,
      status: dtcCodes.isEmpty
          ? DiagnosticStatus.healthy
          : DiagnosticStatus.hasErrors,
    );
  }
}

enum DiagnosticStatus {
  healthy, // Arıza yok
  hasErrors, // Arıza kodları var
  pending, // Beklemede
  unknown, // Bilinmiyor
}
