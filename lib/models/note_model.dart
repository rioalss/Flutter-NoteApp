import 'dart:convert';

class NoteModel {
  final int? id;
  final String title;
  final String description;
  final DateTime time;

  NoteModel({
    this.id,
    required this.title,
    required this.description,
    required this.time,
  });

  NoteModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? time,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] as String,
      description: map['description'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(int.parse(map['time'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  bool isNull() {
    return [id, title, description, time].contains(null);
  }
}
