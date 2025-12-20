import 'package:json_annotation/json_annotation.dart';
part 'chronicle.g.dart';

@JsonSerializable()
class Chronicle {
  final int? id;
  final String date; // 2012-12-12 format
  final String eventName;
  final Map<String, dynamic> params;
  final String? comment;

  Chronicle(this.id, this.date, this.eventName, this.params, this.comment);

  Map<String, dynamic> toJson() => _$ChronicleToJson(this);
  factory Chronicle.fromJson(Map<String, dynamic> json) => _$ChronicleFromJson(json);

  @override
  String toString() => 'Chronicle{date: $date, eventName: $eventName, params: $params, comment: $comment}';
}
