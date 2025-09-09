import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  late SpeechToText _speechToText;
  
  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isSpeaking = false;
  
  String _lastWords = '';
  
  // Getters
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get speechEnabled => _speechEnabled;
  String get lastWords => _lastWords;
  
  Future<void> initialize() async {
    if (kIsWeb) {
      // Web platform has limited speech support
      _speechEnabled = false;
      return;
    }
    
    _speechToText = SpeechToText();
    
    // Initialize Speech to Text
    _speechEnabled = await _speechToText.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
    );
  }
  
  Future<void> startListening({
    required Function(String) onResult,
    String localeId = 'th-TH',
  }) async {
    if (!_speechEnabled) return;
    
    _lastWords = '';
    _isListening = true;
    
    await _speechToText.listen(
      onResult: (result) {
        _lastWords = result.recognizedWords;
        onResult(_lastWords);
        
        if (result.finalResult) {
          _isListening = false;
        }
      },
      localeId: localeId,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }
  
  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
    }
  }
  
  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    
    // TTS functionality temporarily disabled
    // TODO: Re-enable when flutter_tts is properly configured for Windows
    print('TTS would say: $text');
    
    // Simulate speaking state
    _isSpeaking = true;
    await Future.delayed(const Duration(milliseconds: 500));
    _isSpeaking = false;
  }
  
  Future<void> stopSpeaking() async {
    _isSpeaking = false;
  }
  
  void _onSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _isListening = false;
    }
  }
  
  void _onSpeechError(dynamic error) {
    _isListening = false;
    print('Speech error: $error');
  }
  
  // Get available languages (placeholder)
  Future<List<dynamic>> getLanguages() async {
    return ['th-TH', 'en-US']; // Placeholder languages
  }
  
  // Check if language is available
  Future<bool> isLanguageAvailable(String language) async {
    final languages = await getLanguages();
    return languages.contains(language);
  }
  
  void dispose() {
    _speechToText.cancel();
  }
}