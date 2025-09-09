import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../models/content_template.dart';
import '../models/event_data.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static final Map<String, List<Map<String, dynamic>>> _inMemoryStorage = {};

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Initialize in-memory storage for web platform
    if (kIsWeb) {
      _initInMemoryStorage();
    }
  }

  static void _initInMemoryStorage() {
    _inMemoryStorage['conversations'] = [];
    _inMemoryStorage['content_templates'] = [];
    _inMemoryStorage['events'] = [];
    _inMemoryStorage['usage_analytics'] = [];
    _inMemoryStorage['user_sessions'] = [];
  }

  // Chat Message Operations
  static Future<void> saveConversation(ChatMessage message) async {
    if (kIsWeb) {
      _inMemoryStorage['conversations']!.add(message.toMap());
    } else {
      // For mobile platforms, implement SQLite logic later
      _inMemoryStorage['conversations'] ??= [];
      _inMemoryStorage['conversations']!.add(message.toMap());
    }
  }

  static Future<List<ChatMessage>> getConversationHistory(String sessionId) async {
    List<Map<String, dynamic>> conversations;
    
    if (kIsWeb) {
      conversations = _inMemoryStorage['conversations']!
          .where((conv) => conv['sessionId'] == sessionId)
          .toList();
    } else {
      // For mobile platforms, implement SQLite logic later
      conversations = _inMemoryStorage['conversations']
          ?.where((conv) => conv['sessionId'] == sessionId)
          .toList() ?? [];
    }

    conversations.sort((a, b) => DateTime.parse(b['timestamp'])
        .compareTo(DateTime.parse(a['timestamp'])));
    
    final limited = conversations.take(50).toList();
    return limited.map((map) => ChatMessage.fromMap(map)).toList();
  }

  // Content Template Operations
  static Future<void> saveContentTemplate(ContentTemplate template) async {
    final templateMap = template.toMap();
    templateMap['variables'] = jsonEncode(template.variables);
    
    if (kIsWeb) {
      // Remove existing template with same ID
      _inMemoryStorage['content_templates']!.removeWhere(
        (item) => item['id'] == template.id
      );
      _inMemoryStorage['content_templates']!.add(templateMap);
    } else {
      // For mobile platforms, implement SQLite logic later
      _inMemoryStorage['content_templates'] ??= [];
      _inMemoryStorage['content_templates']!.removeWhere(
        (item) => item['id'] == template.id
      );
      _inMemoryStorage['content_templates']!.add(templateMap);
    }
  }

  static Future<List<ContentTemplate>> getContentTemplates() async {
    List<Map<String, dynamic>> templates;
    
    if (kIsWeb) {
      templates = _inMemoryStorage['content_templates']!;
    } else {
      templates = _inMemoryStorage['content_templates'] ?? [];
    }

    return templates.map((map) {
      final parsedMap = Map<String, dynamic>.from(map);
      parsedMap['variables'] = jsonDecode(map['variables'] ?? '{}');
      return ContentTemplate.fromMap(parsedMap);
    }).toList();
  }

  // Event Operations
  static Future<void> saveEvent(EventData event) async {
    final eventMap = event.toMap();
    
    if (kIsWeb) {
      // Remove existing event with same ID
      _inMemoryStorage['events']!.removeWhere(
        (item) => item['id'] == event.id
      );
      _inMemoryStorage['events']!.add(eventMap);
    } else {
      _inMemoryStorage['events'] ??= [];
      _inMemoryStorage['events']!.removeWhere(
        (item) => item['id'] == event.id
      );
      _inMemoryStorage['events']!.add(eventMap);
    }
  }

  static Future<List<EventData>> getEvents() async {
    List<Map<String, dynamic>> events;
    
    if (kIsWeb) {
      events = _inMemoryStorage['events']!;
    } else {
      events = _inMemoryStorage['events'] ?? [];
    }

    events.sort((a, b) => DateTime.parse(a['eventDate'])
        .compareTo(DateTime.parse(b['eventDate'])));
    
    return events.map((map) => EventData.fromMap(map)).toList();
  }

  // Analytics Operations
  static Future<void> logUsage(
    String feature,
    String action, {
    Map<String, dynamic>? data,
  }) async {
    final sessionId = await getCurrentSessionId();
    final analyticsData = {
      'featureName': feature,
      'actionType': action,
      'sessionId': sessionId,
      'timestamp': DateTime.now().toIso8601String(),
      'additionalData': jsonEncode(data ?? {}),
    };

    if (kIsWeb) {
      _inMemoryStorage['usage_analytics']!.add(analyticsData);
    } else {
      _inMemoryStorage['usage_analytics'] ??= [];
      _inMemoryStorage['usage_analytics']!.add(analyticsData);
    }
  }

  // Session Management
  static Future<String> getCurrentSessionId() async {
    const key = 'current_session_id';
    String? sessionId = _prefs?.getString(key);
    
    if (sessionId == null) {
      sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      await _prefs?.setString(key, sessionId);
    }
    
    return sessionId;
  }

  static Future<void> startNewSession() async {
    const key = 'current_session_id';
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    await _prefs?.setString(key, sessionId);
  }

  // Preferences
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }
}