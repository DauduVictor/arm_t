// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageModelImpl _$$ChatMessageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageModelImpl(
      message: json['message'] as String? ?? '',
      sentByCurrentUser: json['sentByCurrentUser'] as bool? ?? true,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$$ChatMessageModelImplToJson(
        _$ChatMessageModelImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'sentByCurrentUser': instance.sentByCurrentUser,
      'time': instance.time?.toIso8601String(),
    };
