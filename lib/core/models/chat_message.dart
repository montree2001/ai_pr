import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? sessionId;
  final String? intentCategory;
  final double? confidenceScore;
  final int? userSatisfaction;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.sessionId,
    this.intentCategory,
    this.confidenceScore,
    this.userSatisfaction,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    isUser,
    timestamp,
    sessionId,
    intentCategory,
    confidenceScore,
    userSatisfaction,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
      'sessionId': sessionId,
      'intentCategory': intentCategory,
      'confidenceScore': confidenceScore,
      'userSatisfaction': userSatisfaction,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      text: map['text'],
      isUser: map['isUser'] == 1,
      timestamp: DateTime.parse(map['timestamp']),
      sessionId: map['sessionId'],
      intentCategory: map['intentCategory'],
      confidenceScore: map['confidenceScore']?.toDouble(),
      userSatisfaction: map['userSatisfaction'],
    );
  }

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? sessionId,
    String? intentCategory,
    double? confidenceScore,
    int? userSatisfaction,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      sessionId: sessionId ?? this.sessionId,
      intentCategory: intentCategory ?? this.intentCategory,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      userSatisfaction: userSatisfaction ?? this.userSatisfaction,
    );
  }
}