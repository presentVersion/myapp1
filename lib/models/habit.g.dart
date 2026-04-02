// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) => Habit(
  id: json['id'] as String,
  name: json['name'] as String,
  completedDates:
      (json['completedDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ??
      const [],
  skippedDates:
      (json['skippedDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ??
      const [],
  scheduledDays: (json['scheduledDays'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as bool),
  ),
);

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'completedDates': instance.completedDates
      .map((e) => e.toIso8601String())
      .toList(),
  'skippedDates': instance.skippedDates
      .map((e) => e.toIso8601String())
      .toList(),
  'scheduledDays': instance.scheduledDays,
};
