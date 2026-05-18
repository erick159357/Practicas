import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  
  bool get soundEnabled => _soundEnabled;
  
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }
  
  Future<void> playSuccess() async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.stop(); // Detener cualquier sonido anterior
      await _audioPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      print('Error playing success sound: $e');
    }
  }
  
  Future<void> playFlip() async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/flip.mp3'));
    } catch (e) {
      print('Error playing flip sound: $e');
    }
  }
  
  Future<void> playWin() async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/win.mp3'));
    } catch (e) {
      print('Error playing win sound: $e');
    }
  }
  
  Future<void> playError() async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/error.mp3'));
    } catch (e) {
      print('Error playing error sound: $e');
    }
  }
  
  void dispose() {
    _audioPlayer.dispose();
  }
}