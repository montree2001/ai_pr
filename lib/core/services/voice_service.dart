import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  late SpeechToText _speechToText;
  late FlutterTts _flutterTts;
  
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
    _flutterTts = FlutterTts();
    
    // Initialize Speech to Text
    _speechEnabled = await _speechToText.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
    );
    
    // Configure TTS
    await _configureTts();
  }
  
  Future<void> _configureTts() async {
    await _flutterTts.setLanguage('th-TH'); // Thai language
    await _flutterTts.setSpeechRate(0.8);
    await _flutterTts.setVolume(0.9);
    await _flutterTts.setPitch(1.0);
    
    // Set callbacks
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
    });
    
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });
    
    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
    });
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
    
    // Stop any current speech
    await _flutterTts.stop();
    
    // For web platform, try to use browser's speech synthesis
    if (kIsWeb) {
      // Web speech synthesis is limited, implement fallback
      print('TTS: $text'); // Fallback for debugging
      return;
    }
    
    await _flutterTts.speak(text);
  }
  
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
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
  
  // Get available languages
  Future<List<dynamic>> getLanguages() async {
    return await _flutterTts.getLanguages;
  }
  
  // Check if language is available
  Future<bool> isLanguageAvailable(String language) async {
    final languages = await getLanguages();
    return languages.contains(language);
  }
  
  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
  }
}