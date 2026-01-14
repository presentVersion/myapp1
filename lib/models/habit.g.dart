// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) => Habit(
  id: json['id'] as String,
  name: json['name'] as String,
  streakCount: (json['streakCount'] as num?)?.toInt() ?? 0,
  completedDates: (json['completedDates'] as List<dynamic>?)
      ?.map((e) => DateTime.parse(e as String))
      .toList(),
);

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'streakCount': instance.streakCount,
  'completedDates': instance.completedDates
      .map((e) => e.toIso8601String())
      .toList(),
};
