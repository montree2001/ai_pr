import 'package:equatable/equatable.dart';

enum ContentType { socialPost, announcement, promotion, recruitment }

class ContentTemplate extends Equatable {
  final String id;
  final String templateName;
  final ContentType templateType;
  final String templateContent;
  final Map<String, String> variables;
  final int usageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContentTemplate({
    required this.id,
    required this.templateName,
    required this.templateType,
    required this.templateContent,
    this.variables = const {},
    this.usageCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    templateName,
    templateType,
    templateContent,
    variables,
    usageCount,
    createdAt,
    updatedAt,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'templateName': templateName,
      'templateType': templateType.name,
      'templateContent': templateContent,
      'variables': variables,
      'usageCount': usageCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ContentTemplate.fromMap(Map<String, dynamic> map) {
    return ContentTemplate(
      id: map['id'],
      templateName: map['templateName'],
      templateType: ContentType.values.firstWhere(
        (e) => e.name == map['templateType'],
      ),
      templateContent: map['templateContent'],
      variables: Map<String, String>.from(map['variables'] ?? {}),
      usageCount: map['usageCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  ContentTemplate copyWith({
    String? id,
    String? templateName,
    ContentType? templateType,
    String? templateContent,
    Map<String, String>? variables,
    int? usageCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContentTemplate(
      id: id ?? this.id,
      templateName: templateName ?? this.templateName,
      templateType: templateType ?? this.templateType,
      templateContent: templateContent ?? this.templateContent,
      variables: variables ?? this.variables,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}