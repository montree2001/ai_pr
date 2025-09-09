import 'package:flutter/foundation.dart';

class AppConfig {
  // API Configuration
  static String get geminiApiKey {
    // In a production app, you would use environment variables
    // For now, we're using the hard-coded key but with a safer approach
    if (kDebugMode) {
      // For development, you can use a different key or mock service
      return const String.fromEnvironment('GEMINI_API_KEY', 
          defaultValue: 'AIzaSyDacAvZwvxPsXFG0qZatUV4E94VugXoAGk');
    } else {
      // For production, always use environment variables
      return const String.fromEnvironment('GEMINI_API_KEY');
    }
  }

  // API Endpoints
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String geminiModel = 'gemini-1.5-flash';
  
  static String get generateContent => '$geminiBaseUrl/$geminiModel:generateContent';
  
  // Request configurations
  static const int requestTimeout = 30;
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
}