import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  const ChatStarted();
}

class SendMessage extends ChatEvent {
  final String message;

  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class LoadChatHistory extends ChatEvent {
  final String sessionId;

  const LoadChatHistory(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

class ClearChat extends ChatEvent {
  const ClearChat();
}

class RateMessage extends ChatEvent {
  final String messageId;
  final int rating;

  const RateMessage(this.messageId, this.rating);

  @override
  List<Object> get props => [messageId, rating];
}