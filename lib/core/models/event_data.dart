import 'package:equatable/equatable.dart';

enum EventType { admission, activity, announcement, promotion }
enum EventStatus { planned, active, completed, cancelled }

class EventData extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime eventDate;
  final DateTime? eventTime;
  final String? location;
  final EventType eventType;
  final EventStatus status;
  final String? createdBy;
  final DateTime createdAt;

  const EventData({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    this.eventTime,
    this.location,
    required this.eventType,
    this.status = EventStatus.planned,
    this.createdBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    eventDate,
    eventTime,
    location,
    eventType,
    status,
    createdBy,
    createdAt,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime?.toIso8601String(),
      'location': location,
      'eventType': eventType.name,
      'status': status.name,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EventData.fromMap(Map<String, dynamic> map) {
    return EventData(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      eventDate: DateTime.parse(map['eventDate']),
      eventTime: map['eventTime'] != null ? DateTime.parse(map['eventTime']) : null,
      location: map['location'],
      eventType: EventType.values.firstWhere((e) => e.name == map['eventType']),
      status: EventStatus.values.firstWhere((e) => e.name == map['status']),
      createdBy: map['createdBy'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  EventData copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? eventDate,
    DateTime? eventTime,
    String? location,
    EventType? eventType,
    EventStatus? status,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return EventData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      location: location ?? this.location,
      eventType: eventType ?? this.eventType,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}