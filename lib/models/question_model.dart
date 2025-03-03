import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String text;
  final List<String> options;

  const Question({
    required this.id,
    required this.text,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['Qid'] as String,
      text: json['Question'] as String,
      options: List<String>.from(json['Options'] as List),
    );
  }

  @override
  List<Object?> get props => [id, text, options];
}
