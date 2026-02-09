// Ses Kayıt Servisi - Placeholder (Record paketi sonra eklenecek)
import 'package:permission_handler/permission_handler.dart';

class AudioStreamService {
  bool _isRecording = false;
  
  bool get isRecording => _isRecording;
  String? get recordingPath => null;
  
  // Mikrofon izni kontrolü
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // Ses kaydını başlat (placeholder)
  Future<bool> startRecording() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      print('Mikrofon izni reddedildi');
      return false;
    }
    _isRecording = true;
    return true;
  }

  // Ses kaydını durdur (placeholder)
  Future<String?> stopRecording() async {
    _isRecording = false;
    return null;
  }

  // Kaynak temizliği
  void dispose() {}
}
