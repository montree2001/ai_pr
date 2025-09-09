import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/chat_message.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  Future<String> generateChatResponse(
    String userMessage,
    List<ChatMessage> history,
  ) async {
    final prompt = _buildChatPrompt(userMessage, history);
    return await _callGeminiAPI(prompt);
  }

  Future<String> generateContent(
    String contentType,
    Map<String, String> variables,
  ) async {
    final prompt = _buildContentPrompt(contentType, variables);
    return await _callGeminiAPI(prompt);
  }

  Future<Map<String, dynamic>> generateEventPlan(
    String eventType,
    DateTime date,
  ) async {
    final prompt = _buildEventPrompt(eventType, date);
    final response = await _callGeminiAPI(prompt);
    try {
      return jsonDecode(response);
    } catch (e) {
      return {'plan': response, 'suggestions': []};
    }
  }

  String _buildChatPrompt(String message, List<ChatMessage> history) {
    final historyText = history
        .take(10)
        .map((msg) => '${msg.isUser ? "ผู้ใช้" : "บอท"}: ${msg.text}')
        .join('\n');

    return '''
คุณคือ SmartPR Assistant ผู้ช่วยประชาสัมพันธ์อัจฉริยะของวิทยาลัยการอาชีพปราสาท

ข้อมูลพื้นฐาน:
- ชื่อ: วิทยาลัยการอาชีพปราสาท
- ที่ตั้ง: อำเภอปราสาท จังหวัดสุรินทร์
- หลักสูตร: ปวช. และ ปวส. หลายสาขา
- จุดเด่น: การศึกษาวิชาชีพที่ตอบสนองความต้องการของท้องถิ่น

ประวัติการสนทนา:
$historyText

คำถามปัจจุบัน: $message

กรุณาตอบด้วยภาษาไทยที่เป็นมิตร เข้าใจง่าย และให้ข้อมูลที่เป็นประโยชน์
''';
  }

  String _buildContentPrompt(String contentType, Map<String, String> variables) {
    final variableText = variables.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');

    return '''
สร้างเนื้อหาประชาสัมพันธ์สำหรับวิทยาลัยการอาชีพปราสาท

ประเภทเนื้อหา: $contentType
ข้อมูลที่ให้มา:
$variableText

กรุณาสร้างเนื้อหาที่:
- เหมาะสมกับโซเชียลมีเดีย (Facebook/Instagram)
- ใช้ภาษาไทยที่ดึงดูดและเข้าใจง่าย
- มีความน่าสนใจและชวนติดตาม
- ใส่แฮชแท็กที่เกี่ยวข้อง
- ระบุข้อมูลติดต่อของวิทยาลัย

รูปแบบ:
🎓 หัวข้อหลัก
✨ รายละเอียด
📍 สถานที่/วันเวลา (ถ้ามี)
📞 ข้อมูลติดต่อ
#แฮชแท็ก
''';
  }

  String _buildEventPrompt(String eventType, DateTime date) {
    return '''
สร้างแผนการประชาสัมพันธ์สำหรับกิจกรรม: $eventType
วันที่กิจกรรม: ${date.day}/${date.month}/${date.year}

กรุณาสร้างแผนการประชาสัมพันธ์ที่ประกอบด้วย:
1. ช่วงเวลาการประชาสัมพันธ์ (ก่อนกิจกรรม)
2. ช่องทางการประชาสัมพันธ์
3. เนื้อหาสำหรับแต่ละช่วงเวลา
4. กลุ่มเป้าหมาย
5. ตัวชี้วัดความสำเร็จ

ตอบในรูปแบบ JSON ที่มีโครงสร้างชัดเจน
''';
  }

  Future<String> _callGeminiAPI(String prompt) async {
    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 1024,
      }
    };

    try {
      final uri = Uri.parse('${ApiEndpoints.generateContent}?key=${ApiEndpoints.geminiApiKey}');
      final response = await http.post(
        uri,
        headers: ApiEndpoints.defaultHeaders,
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: ApiEndpoints.requestTimeout));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Check if the response has the expected structure
        if (data != null && 
            data['candidates'] != null && 
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          throw Exception('Unexpected API response structure: ${response.body}');
        }
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network Error (ClientException): ${e.message}. Please check your internet connection.');
    } on TimeoutException catch (e) {
      throw Exception('Network Error (Timeout): The request timed out. Please check your internet connection or try again later.');
    } catch (e) {
      throw Exception('Network Error: $e. Please check your internet connection and API key.');
    }
  }
}