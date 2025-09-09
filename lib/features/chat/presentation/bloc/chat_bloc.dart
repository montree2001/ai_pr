import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/models/chat_message.dart';
import '../../../../core/constants/app_strings.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService _geminiService;
  final Uuid _uuid = const Uuid();

  ChatBloc({GeminiService? geminiService})
      : _geminiService = geminiService ?? GeminiService(),
        super(const ChatInitial()) {
    on<ChatStarted>(_onChatStarted);
    on<SendMessage>(_onSendMessage);
    on<LoadChatHistory>(_onLoadChatHistory);
    on<ClearChat>(_onClearChat);
    on<RateMessage>(_onRateMessage);
  }

  Future<void> _onChatStarted(ChatStarted event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    
    try {
      final sessionId = await StorageService.getCurrentSessionId();
      final history = await StorageService.getConversationHistory(sessionId);
      
      // Add welcome message if no history
      List<ChatMessage> messages = [];
      if (history.isEmpty) {
        final welcomeMessage = ChatMessage(
          id: _uuid.v4(),
          text: AppStrings.welcomeMessage,
          isUser: false,
          timestamp: DateTime.now(),
          sessionId: sessionId,
        );
        await StorageService.saveConversation(welcomeMessage);
        messages = [welcomeMessage];
      } else {
        messages = history.reversed.toList();
      }

      await StorageService.logUsage('chat', 'start');
      
      emit(ChatLoaded(
        messages: messages,
        sessionId: sessionId,
      ));
    } catch (e) {
      emit(ChatError('เกิดข้อผิดพลาดในการโหลดแชท: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;
    
    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: event.message,
      isUser: true,
      timestamp: DateTime.now(),
      sessionId: currentState.sessionId,
    );

    final updatedMessages = [...currentState.messages, userMessage];
    
    // Show typing indicator
    emit(currentState.copyWith(
      messages: updatedMessages,
      isTyping: true,
    ));

    try {
      // Save user message
      await StorageService.saveConversation(userMessage);
      await StorageService.logUsage('chat', 'send_message');

      // Get AI response
      final response = await _geminiService.generateChatResponse(
        event.message,
        currentState.messages,
      );

      // Create bot message
      final botMessage = ChatMessage(
        id: _uuid.v4(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
        sessionId: currentState.sessionId,
      );

      // Save bot message
      await StorageService.saveConversation(botMessage);

      final finalMessages = [...updatedMessages, botMessage];

      emit(currentState.copyWith(
        messages: finalMessages,
        isTyping: false,
      ));

    } catch (e) {
      // Add error message
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        text: 'ขออภัย เกิดข้อผิดพลาดในการเชื่อมต่อกับระบบ: ${e.toString()}. กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตของคุณและลองใหม่อีกครั้ง',
        isUser: false,
        timestamp: DateTime.now(),
        sessionId: currentState.sessionId,
      );

      emit(currentState.copyWith(
        messages: [...updatedMessages, errorMessage],
        isTyping: false,
      ));

      await StorageService.logUsage('chat', 'error', data: {'error': e.toString()});
    }
  }

  Future<void> _onLoadChatHistory(LoadChatHistory event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    
    try {
      final history = await StorageService.getConversationHistory(event.sessionId);
      
      emit(ChatLoaded(
        messages: history.reversed.toList(),
        sessionId: event.sessionId,
      ));
    } catch (e) {
      emit(ChatError('เกิดข้อผิดพลาดในการโหลดประวัติ: ${e.toString()}'));
    }
  }

  Future<void> _onClearChat(ClearChat event, Emitter<ChatState> emit) async {
    if (state is! ChatLoaded) return;

    try {
      await StorageService.startNewSession();
      final newSessionId = await StorageService.getCurrentSessionId();
      
      final welcomeMessage = ChatMessage(
        id: _uuid.v4(),
        text: AppStrings.welcomeMessage,
        isUser: false,
        timestamp: DateTime.now(),
        sessionId: newSessionId,
      );
      
      await StorageService.saveConversation(welcomeMessage);
      await StorageService.logUsage('chat', 'clear');
      
      emit(ChatLoaded(
        messages: [welcomeMessage],
        sessionId: newSessionId,
      ));
    } catch (e) {
      emit(ChatError('เกิดข้อผิดพลาดในการล้างแชท: ${e.toString()}'));
    }
  }

  Future<void> _onRateMessage(RateMessage event, Emitter<ChatState> emit) async {
    try {
      await StorageService.logUsage('chat', 'rate_message', data: {
        'messageId': event.messageId,
        'rating': event.rating,
      });
    } catch (e) {
      // Silent error for rating
    }
  }
}