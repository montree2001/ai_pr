# Qwen Code Context for ai_pr Project

This file contains context information for Qwen Code to better assist with this Flutter project.

## Project Information
- Project Name: ai_pr
- Project Type: Flutter Application
- Primary Language: Dart
- Platform: Mobile (Android/iOS)

## File Structure Overview
- `lib/` - Main source code directory
- `assets/` - Static assets (images, fonts, etc.)
- `android/` - Android specific code
- `ios/` - iOS specific code

## Development Notes
- This is a Flutter project using Dart
- Standard Flutter project structure applies

## Preferences
- Follow Flutter and Dart best practices
- Use proper error handling
- Write clean, readable code with comments where necessary

# ขอบเขตและโครงสร้างระบบ SmartPR Assistant

## 📋 1. ขอบเขตฟังก์ชันการทำงาน (Function Scope)

### 🎯 1.1 Core Modules (โมดูลหลัก)

#### Module 1: AI Chatbot Engine
ออกแบบให้เหมาะกับจอทัชกรีน
ต้องการแสดงข้อมูลแบบอัจฉริยะ
พูดถาม Ai แล้วตอบได้เลย API google api-key=AIzaSyDacAvZwvxPsXFG0qZatUV4E94VugXoAGk
สามารถเพิ่มภาพหรือวีดีโอให้นำเสนอได้
ธีมระบบสีขาวสะอาดและโมเดิร์น
```
📍 ขอบเขต: ระบบสนทนาอัจฉริยะ
✅ In Scope:
  ├── ตอบคำถามทั่วไปเกี่ยวกับวิทยาลัย
  ├── ข้อมูลหลักสูตร ปวช./ปวส. 
  ├── ข้อมูลการรับสมัครและเงื่อนไข
  ├── ข้อมูลกิจกรรมและข่าวสาร
  ├── การนำทางและแผนที่วิทยาลัย
  ├── FAQ อัตโนมัติ
  └── Multi-turn conversation

❌ Out of Scope:
  ├── ข้อมูลส่วนตัวนักเรียน
  ├── ระบบลงทะเบียนเรียน
  ├── การชำระเงินออนไลน์
  └── ข้อมูลคะแนนและผลการเรียน
```

#### Module 2: Content Generation System
```
📍 ขอบเขต: ระบบสร้างเนื้อหาประชาสัมพันธ์
✅ In Scope:
  ├── สร้างโพสต์ Facebook/Instagram
  ├── เนื้อหาการรับสมัคร
  ├── ประกาศข่าวสารทั่วไป
  ├── เนื้อหาโปรโมทหลักสูตร
  ├── Caption สำหรับรูปภาพ
  ├── เทมเพลตการประชาสัมพันธ์
  └── การปรับแต่งสไตล์ตามกลุ่มเป้าหมาย

❌ Out of Scope:
  ├── การออกแบบกราฟิก
  ├── การตัดต่อวิดีโอ
  ├── การสร้างโลโก้
  └── การพิมพ์สื่อสิ่งพิมพ์
```

#### Module 3: Event Planning Assistant
```
📍 ขอบเขต: ระบบวางแผนและจัดการกิจกรรม
✅ In Scope:
  ├── ปฏิทินกิจกรรมประชาสัมพันธ์
  ├── แนะนำกลยุทธ์ตามช่วงเวลา
  ├── เตือนภารกิจสำคัญ
  ├── ติดตามผลการดำเนินงาน
  ├── วิเคราะห์ช่วงเวลาที่เหมาะสม
  └── สร้างแผนการประชาสัมพันธ์

❌ Out of Scope:
  ├── การจองสถานที่
  ├── การจัดการงบประมาณ
  ├── การประสานงานกับผู้ขาย
  └── ระบบลงทะเบียนผู้เข้าร่วม
```

#### Module 4: Analytics & Reporting
```
📍 ขอบเขต: ระบบวิเคราะห์และรายงาน
✅ In Scope:
  ├── สถิติการใช้งานระบบ
  ├── วิเคราะห์คำถามยอดนิยม
  ├── รายงานประสิทธิภาพการประชาสัมพันธ์
  ├── แนวโน้มความต้องการข้อมูล
  ├── Dashboard แบบ Real-time
  └── Export รายงาน PDF/Excel

❌ Out of Scope:
  ├── การวิเคราะห์ข้อมูลโซเชียลมีเดีย
  ├── Google Analytics Integration
  ├── การติดตาม ROI การตลาด
  └── Advanced Business Intelligence
```

---

## 🏗️ 2. โครงสร้างไฟล์ระบบ (File Structure)

### 📁 Flutter Project Structure

```
smartpr_assistant/
├── 📁 android/                    # Android specific files
├── 📁 assets/                     # Static assets
│   ├── 📁 images/
│   │   ├── college_logo.png
│   │   ├── avatar_bot.png
│   │   └── bg_patterns/
│   ├── 📁 icons/
│   │   ├── chat_icon.svg
│   │   ├── content_icon.svg
│   │   ├── event_icon.svg
│   │   └── analytics_icon.svg
│   └── 📁 data/
│       ├── college_info.json
│       ├── courses_data.json
│       └── faq_templates.json
├── 📁 lib/                       # Main source code
│   ├── 📄 main.dart              # App entry point
│   ├── 📁 core/                  # Core functionalities
│   │   ├── 📁 constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   ├── api_endpoints.dart
│   │   │   └── app_themes.dart
│   │   ├── 📁 utils/
│   │   │   ├── date_formatter.dart
│   │   │   ├── text_validator.dart
│   │   │   ├── file_helper.dart
│   │   │   └── permission_handler.dart
│   │   ├── 📁 services/
│   │   │   ├── api_service.dart
│   │   │   ├── gemini_service.dart
│   │   │   ├── storage_service.dart
│   │   │   └── analytics_service.dart
│   │   └── 📁 models/
│   │       ├── chat_message.dart
│   │       ├── content_template.dart
│   │       ├── event_data.dart
│   │       ├── user_session.dart
│   │       └── analytics_data.dart
│   ├── 📁 features/             # Feature modules
│   │   ├── 📁 chat/             # Module 1: AI Chatbot
│   │   │   ├── 📁 presentation/
│   │   │   │   ├── 📁 pages/
│   │   │   │   │   ├── chat_page.dart
│   │   │   │   │   └── chat_history_page.dart
│   │   │   │   ├── 📁 widgets/
│   │   │   │   │   ├── message_bubble.dart
│   │   │   │   │   ├── typing_indicator.dart
│   │   │   │   │   ├── quick_replies.dart
│   │   │   │   │   └── voice_input.dart
│   │   │   │   └── 📁 bloc/
│   │   │   │       ├── chat_bloc.dart
│   │   │   │       ├── chat_event.dart
│   │   │   │       └── chat_state.dart
│   │   │   ├── 📁 domain/
│   │   │   │   ├── 📁 entities/
│   │   │   │   │   ├── message.dart
│   │   │   │   │   └── conversation.dart
│   │   │   │   ├── 📁 repositories/
│   │   │   │   │   └── chat_repository.dart
│   │   │   │   └── 📁 usecases/
│   │   │   │       ├── send_message.dart
│   │   │   │       ├── get_response.dart
│   │   │   │       └── save_conversation.dart
│   │   │   └── 📁 data/
│   │   │       ├── 📁 datasources/
│   │   │       │   ├── gemini_datasource.dart
│   │   │       │   └── local_chat_datasource.dart
│   │   │       ├── 📁 models/
│   │   │       │   ├── chat_message_model.dart
│   │   │       │   └── api_response_model.dart
│   │   │       └── 📁 repositories/
│   │   │           └── chat_repository_impl.dart
│   │   ├── 📁 content_generator/   # Module 2: Content Generation
│   │   │   ├── 📁 presentation/
│   │   │   │   ├── 📁 pages/
│   │   │   │   │   ├── content_generator_page.dart
│   │   │   │   │   ├── template_selector_page.dart
│   │   │   │   │   └── content_preview_page.dart
│   │   │   │   ├── 📁 widgets/
│   │   │   │   │   ├── template_card.dart
│   │   │   │   │   ├── content_editor.dart
│   │   │   │   │   ├── preview_panel.dart
│   │   │   │   │   └── export_options.dart
│   │   │   │   └── 📁 bloc/
│   │   │   │       ├── content_bloc.dart
│   │   │   │       ├── content_event.dart
│   │   │   │       └── content_state.dart
│   │   │   ├── 📁 domain/
│   │   │   │   ├── 📁 entities/
│   │   │   │   │   ├── content_template.dart
│   │   │   │   │   └── generated_content.dart
│   │   │   │   ├── 📁 repositories/
│   │   │   │   │   └── content_repository.dart
│   │   │   │   └── 📁 usecases/
│   │   │   │       ├── generate_content.dart
│   │   │   │       ├── save_template.dart
│   │   │   │       └── export_content.dart
│   │   │   └── 📁 data/
│   │   │       ├── 📁 datasources/
│   │   │       │   ├── template_datasource.dart
│   │   │       │   └── content_generator_datasource.dart
│   │   │       └── 📁 repositories/
│   │   │           └── content_repository_impl.dart
│   │   ├── 📁 event_planner/      # Module 3: Event Planning
│   │   │   ├── 📁 presentation/
│   │   │   │   ├── 📁 pages/
│   │   │   │   │   ├── event_planner_page.dart
│   │   │   │   │   ├── calendar_view_page.dart
│   │   │   │   │   └── event_details_page.dart
│   │   │   │   ├── 📁 widgets/
│   │   │   │   │   ├── calendar_widget.dart
│   │   │   │   │   ├── event_card.dart
│   │   │   │   │   ├── reminder_setup.dart
│   │   │   │   │   └── timeline_view.dart
│   │   │   │   └── 📁 bloc/
│   │   │   │       ├── event_bloc.dart
│   │   │   │       ├── event_event.dart
│   │   │   │       └── event_state.dart
│   │   │   ├── 📁 domain/
│   │   │   │   ├── 📁 entities/
│   │   │   │   │   ├── event.dart
│   │   │   │   │   └── event_plan.dart
│   │   │   │   └── 📁 usecases/
│   │   │   │       ├── create_event.dart
│   │   │   │       ├── schedule_reminder.dart
│   │   │   │       └── generate_plan.dart
│   │   │   └── 📁 data/
│   │   │       ├── 📁 datasources/
│   │   │       │   └── event_datasource.dart
│   │   │       └── 📁 repositories/
│   │   │           └── event_repository_impl.dart
│   │   └── 📁 analytics/          # Module 4: Analytics
│   │       ├── 📁 presentation/
│   │       │   ├── 📁 pages/
│   │       │   │   ├── analytics_page.dart
│   │       │   │   ├── dashboard_page.dart
│   │       │   │   └── reports_page.dart
│   │       │   ├── 📁 widgets/
│   │       │   │   ├── chart_widget.dart
│   │       │   │   ├── metric_card.dart
│   │       │   │   ├── data_table.dart
│   │       │   │   └── export_button.dart
│   │       │   └── 📁 bloc/
│   │       │       ├── analytics_bloc.dart
│   │       │       ├── analytics_event.dart
│   │       │       └── analytics_state.dart
│   │       ├── 📁 domain/
│   │       │   ├── 📁 entities/
│   │       │   │   ├── usage_statistics.dart
│   │       │   │   └── performance_metrics.dart
│   │       │   └── 📁 usecases/
│   │       │       ├── generate_report.dart
│   │       │       ├── track_usage.dart
│   │       │       └── export_data.dart
│   │       └── 📁 data/
│   │           ├── 📁 datasources/
│   │           │   └── analytics_datasource.dart
│   │           └── 📁 repositories/
│   │               └── analytics_repository_impl.dart
│   ├── 📁 shared/               # Shared components
│   │   ├── 📁 widgets/
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── loading_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   ├── navigation_rail.dart
│   │   │   └── responsive_layout.dart
│   │   ├── 📁 dialogs/
│   │   │   ├── confirm_dialog.dart
│   │   │   ├── info_dialog.dart
│   │   │   └── settings_dialog.dart
│   │   └── 📁 animations/
│   │       ├── fade_transition.dart
│   │       ├── slide_transition.dart
│   │       └── loading_animation.dart
│   └── 📁 config/              # Configuration
│       ├── app_config.dart
│       ├── database_config.dart
│       ├── api_config.dart
│       └── theme_config.dart
├── 📁 test/                    # Unit & Widget tests
│   ├── 📁 features/
│   │   ├── 📁 chat/
│   │   ├── 📁 content_generator/
│   │   ├── 📁 event_planner/
│   │   └── 📁 analytics/
│   ├── 📁 core/
│   └── 📁 shared/
├── 📁 integration_test/        # Integration tests
├── 📁 web/                     # Web specific files
├── 📁 windows/                 # Windows specific files
├── 📄 pubspec.yaml            # Dependencies
├── 📄 README.md               # Documentation
├── 📄 CHANGELOG.md            # Version history
└── 📄 LICENSE                 # License file
```

---

## 🗄️ 3. Database Schema Design

### 3.1 Local Database (SQLite)

```sql
-- ตาราง conversations: บทสนทนา
CREATE TABLE conversations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    user_message TEXT NOT NULL,
    bot_response TEXT NOT NULL,
    intent_category TEXT,
    confidence_score REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_satisfaction INTEGER DEFAULT NULL
);

-- ตาราง content_templates: เทมเพลตเนื้อหา
CREATE TABLE content_templates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    template_name TEXT NOT NULL,
    template_type TEXT NOT NULL, -- 'social_post', 'announcement', 'promotion'
    template_content TEXT NOT NULL,
    variables JSON, -- ตัวแปรที่สามารถแก้ไขได้
    usage_count INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ตาราง events: กิจกรรม
CREATE TABLE events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    event_time TIME,
    location TEXT,
    event_type TEXT, -- 'admission', 'activity', 'announcement'
    status TEXT DEFAULT 'planned', -- 'planned', 'active', 'completed', 'cancelled'
    created_by TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ตาราง usage_analytics: สถิติการใช้งาน
CREATE TABLE usage_analytics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    feature_name TEXT NOT NULL, -- 'chat', 'content_generator', 'event_planner'
    action_type TEXT NOT NULL, -- 'view', 'generate', 'export', 'save'
    session_id TEXT,
    user_agent TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    additional_data JSON
);

-- ตาราง college_data: ข้อมูลวิทยาลัย
CREATE TABLE college_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    data_type TEXT NOT NULL, -- 'course', 'faculty', 'facility', 'news'
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    category TEXT,
    tags TEXT, -- comma-separated
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- ตาราง user_sessions: เซสชันผู้ใช้
CREATE TABLE user_sessions (
    session_id TEXT PRIMARY KEY,
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_activity DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_interactions INTEGER DEFAULT 0,
    features_used TEXT, -- comma-separated
    ip_address TEXT,
    user_agent TEXT
);
```

### 3.2 Cloud Database (Firestore) Schema

```javascript
// Collection: global_analytics
{
  "daily_stats": {
    "2024-01-15": {
      "total_users": 150,
      "total_interactions": 1250,
      "popular_questions": [
        "หลักสูตรคอมพิวเตอร์มีอะไรบ้าง",
        "การรับสมัครปีนี้เมื่อไหร่",
        "ค่าเทอมเท่าไหร่"
      ],
      "content_generated": 45,
      "events_planned": 8
    }
  },
  "feedback": {
    "conversation_ratings": {
      "positive": 89,
      "neutral": 8,
      "negative": 3
    }
  }
}

// Collection: knowledge_base
{
  "courses": {
    "pvch": {
      "computer": {
        "name": "คอมพิวเตอร์",
        "duration": "3 ปี",
        "subjects": ["โปรแกรมมิง", "เครือข่าย", "ฮาร์ดแวร์"],
        "career_paths": ["โปรแกรมเมอร์", "IT Support", "เทคนิคคอมพิวเตอร์"]
      }
    },
    "pvs": {
      "computer_business": {
        "name": "คอมพิวเตอร์ธุรกิจ",
        "duration": "2 ปี",
        "requirements": "จบ ปวช. คอมพิวเตอร์หรือเทียบเท่า"
      }
    }
  },
  "admissions": {
    "2024": {
      "application_period": "1 มีนาคม - 30 เมษายน 2567",
      "requirements": ["ใบ ม.3 หรือเทียบเท่า", "ใบรับรองแพทย์"],
      "documents": ["สำเนาบัตรประชาชน", "รูปถ่าย 1 นิ้ว จำนวน 3 รูป"]
    }
  }
}
```

---

## 🔧 4. API Structure & Services

### 4.1 Google Gemini API Integration

```dart
// lib/core/services/gemini_service.dart
class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash';
  static const String _apiKey = 'YOUR_API_KEY';

  // สำหรับ AI Chatbot
  Future<String> generateChatResponse(String userMessage, List<ChatMessage> history) async {
    final prompt = _buildChatPrompt(userMessage, history);
    return await _callGeminiAPI(prompt, 'chat');
  }

  // สำหรับ Content Generator
  Future<String> generateContent(String contentType, Map<String, String> variables) async {
    final prompt = _buildContentPrompt(contentType, variables);
    return await _callGeminiAPI(prompt, 'content');
  }

  // สำหรับ Event Planner
  Future<Map<String, dynamic>> generateEventPlan(String eventType, DateTime date) async {
    final prompt = _buildEventPrompt(eventType, date);
    final response = await _callGeminiAPI(prompt, 'event');
    return jsonDecode(response);
  }

  String _buildChatPrompt(String message, List<ChatMessage> history) {
    return '''
คุณคือ SmartPR Assistant ผู้ช่วยประชาสัมพันธ์อัจฉริยะของวิทยาลัยการอาชีพปราสาท

ข้อมูลพื้นฐาน:
- ชื่อ: วิทยาลัยการอาชีพปราสาท
- ที่ตั้ง: อำเภอปราสาท จังหวัดสุรินทร์
- หลักสูตร: ปวช. และ ปวส. หลายสาขา

ประวัติการสนทนา:
${history.map((msg) => '${msg.isUser ? "ผู้ใช้" : "บอท"}: ${msg.text}').join('\n')}

คำถามปัจจุบัน: $message

กรุณาตอบด้วยภาษาไทยที่เป็นมิตร เข้าใจง่าย และให้ข้อมูลที่เป็นประโยชน์
''';
  }
}
```

### 4.2 Local Storage Service

```dart
// lib/core/services/storage_service.dart
class StorageService {
  static late Database _database;

  static Future<void> initialize() async {
    _database = await openDatabase(
      'smartpr_local.db',
      version: 1,
      onCreate: _createTables,
    );
  }

  // บันทึกบทสนทนา
  static Future<void> saveConversation(ChatMessage message) async {
    await _database.insert('conversations', message.toMap());
  }

  // ดึงประวัติการสนทนา
  static Future<List<ChatMessage>> getConversationHistory(String sessionId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'conversations',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'timestamp DESC',
      limit: 50,
    );
    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }

  // บันทึกสถิติการใช้งาน
  static Future<void> logUsage(String feature, String action, {Map<String, dynamic>? data}) async {
    await _database.insert('usage_analytics', {
      'feature_name': feature,
      'action_type': action,
      'session_id': await _getCurrentSessionId(),
      'additional_data': jsonEncode(data ?? {}),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
```

---

## 🎨 5. UI/UX Component Structure

### 5.1 Design System

```dart
// lib/core/constants/app_themes.dart
class AppThemes {
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);
  
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'Roboto',
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
```

### 5.2 Responsive Layout Structure

```dart
// lib/shared/widgets/responsive_layout.dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 768) {
          return mobile;
        } else if (constraints.maxWidth < 1200) {
          return tablet ?? desktop;
        } else {
          return desktop;
        }
      },
    );
  }
}
```

---

## 📊 6. Data Flow Architecture

### 6.1 BLoC Pattern Implementation

```dart
// lib/features/chat/presentation/bloc/chat_bloc.dart
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService _geminiService;
  final StorageService _storageService;

  ChatBloc(this._geminiService, this._storageService) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    
    try {
      // บันทึกข้อความผู้ใช้
      final userMessage = ChatMessage(
        text: event.message,
        isUser: true,
        timestamp: DateTime.now(),
      );
      await _storageService.saveConversation(userMessage);

      // ได้รับการตอบกลับจาก AI
      final response = await _geminiService.generateChatResponse(
        event.message,
        state.conversations,
      );

      // บันทึกการตอบกลับ
      final botMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      await _storageService.saveConversation(botMessage);

      emit(ChatSuccess([...state.conversations, userMessage, botMessage]));
    } catch (e) {
      emit(ChatError('เกิดข้อผิดพลาด: ${e.toString()}'));
    }
  }
}
```

---

## 🚀 7. Deployment & Distribution

### 7.1 Build Configurations

```yaml
# build_configs.yaml
development:
  api_endpoint: "https://dev-api.smartpr.local"
  debug_mode: true
  analytics_enabled: false

staging:
  api_endpoint: "https://staging-api.smartpr.com"
  debug_mode: false
  analytics_enabled: true

production:
  api_endpoint: "https://api.smartpr.com"
  debug_mode: false
  analytics_enabled: true
  performance_monitoring: true
```

### 7.2 Installation Package Structure

```
📦 SmartPR_Assistant_v1.0/
├── 📁 Application/
│   ├── SmartPR_Assistant.exe        # Main executable
│   ├── data/                        # SQLite database
│   └── assets/                      # Static files
├── 📁 Documentation/
│   ├── User_Manual_TH.pdf          # คู่มือผู้ใช้ภาษาไทย
│   ├── User_Manual_EN.pdf          # คู่มือผู้ใช้ภาษาอังกฤษ
│   ├── Technical_Specs.pdf         # เอกสารทางเทคนิค
│   └── API_Configuration.pdf       # คู่มือตั้งค่า API
├── 📁 Setup/
│   ├── setup.exe                   # Installer
│   ├── requirements.txt            # System requirements
│   └── configuration.json          # Default settings
└── 📄 README.txt                   # คำแนะนำการติดตั้ง
```

---

## 🔍 8. Testing Strategy

### 8.1 Test Coverage Matrix

| Module | Unit Tests | Widget Tests | Integration Tests | E2E Tests |
|--------|------------|--------------|-------------------|-----------|
| Chat Engine | ✅ 90% | ✅ 85% | ✅ 80% | ✅ 75% |
| Content Generator | ✅ 85% | ✅ 80% | ✅ 75% | ✅ 70% |
| Event Planner | ✅ 80% | ✅ 75% | ✅ 70% | ✅ 65% |
| Analytics | ✅ 85% | ✅ 80% | ✅ 75% | ✅ 70% |

### 8.2 Performance Benchmarks

```dart
// performance_tests.dart
class PerformanceTests {
  // API Response Time
  static const int maxApiResponseTime = 3000; // 3 seconds
  
  // UI Rendering
  static const int maxWidgetBuildTime = 16; // 60 FPS
  
  // Database Operations
  static const int maxDbQueryTime = 100; // 100ms
  
  // Memory Usage
  static const int maxMemoryUsage = 512; // 512 MB
}
```

---

## 📈 9. Monitoring & Maintenance

### 9.1 Health Check Endpoints

```dart
class SystemHealthCheck {
  static Future<Map<String, dynamic>> getSystemStatus() async {
    return {
      'database': await _checkDatabaseConnection(),
      'api': await _checkGeminiAPI(),
      'storage': await _checkLocalStorage(),
      'memory': await _getMemoryUsage(),
      'uptime': _getUptime(),
      'last_updated': DateTime.now().toIso8601String(),
    };
  }
}
```

### 9.2 Update Mechanism

```dart
class AutoUpdater {
  static Future<bool> checkForUpdates() async {
    // ตรวจสอบเวอร์ชันใหม่
    final latestVersion = await _getLatestVersion();
    final currentVersion = await _getCurrentVersion();
    
    return _isNewerVersion(latestVersion, currentVersion);
  }
  
  static Future<void> downloadAndInstallUpdate() async {
    // ดาวน์โหลดและติดตั้งอัปเดต
  }
}
```

---

**สรุป**: โครงสร้างนี้ออกแบบมาเพื่อให้ระบบมีความยืดหยุ่น ขยายได้ และบำรุงรักษาง่าย พร้อมทั้งตอบสนองความต้องการของการประกวดสิ่งประดิษฐ์อย่างครบถ้วน