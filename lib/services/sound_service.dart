// Uygulama Geneli Ses Servisi
// Tüm buton tıklamalarında dugme.wav çalar
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;

  /// Servisi başlat - uygulama açılışında çağır
  Future<void> init() async {
    if (_isInitialized) return;
    await _player.setSource(AssetSource('ses/dugme.wav'));
    await _player.setVolume(0.5);
    _isInitialized = true;
  }

  /// Buton tıklama sesi çal
  Future<void> playClick() async {
    try {
      if (!_isInitialized) await init();
      await _player.stop();
      await _player.play(AssetSource('ses/dugme.wav'));
    } catch (_) {
      // Ses çalamazsa sessizce devam et
    }
  }

  void dispose() {
    _player.dispose();
  }
}
