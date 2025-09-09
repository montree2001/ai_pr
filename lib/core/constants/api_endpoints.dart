import '../../config/app_config.dart';

class ApiEndpoints {
  // Base URLs
  static const String geminiBaseUrl = AppConfig.geminiBaseUrl;
  static const String geminiModel = AppConfig.geminiModel;
  
  // API Keys (should be moved to environment variables)
  static String get geminiApiKey => AppConfig.geminiApiKey;
  
  // Endpoints
  static String get generateContent => AppConfig.generateContent;
  
  // Request configurations
  static const int requestTimeout = AppConfig.requestTimeout;
  static const Map<String, String> defaultHeaders = AppConfig.defaultHeaders;
}