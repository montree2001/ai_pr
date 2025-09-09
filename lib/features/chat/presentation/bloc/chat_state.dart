import 'package:equatable/equatable.dart';
import '../../../../core/models/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final String sessionId;
  final bool isTyping;

  const ChatLoaded({
    required this.messages,
    required this.sessionId,
    this.isTyping = false,
  });

  @override
  List<Object> get props => [messages, sessionId, isTyping];

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    String? sessionId,
    bool? isTyping,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      sessionId: sessionId ?? this.sessionId,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}

class MessageSending extends ChatState {
  final List<ChatMessage> messages;
  final String sessionId;

  const MessageSending({
    required this.messages,
    required this.sessionId,
  });

  @override
  List<Object> get props => [messages, sessionId];
}