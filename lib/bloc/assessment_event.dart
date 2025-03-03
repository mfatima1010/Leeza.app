import 'package:equatable/equatable.dart';

abstract class AssessmentEvent extends Equatable {
  const AssessmentEvent();
  @override
  List<Object?> get props => [];
}

class LoadQuestions extends AssessmentEvent {
  final String testType;
  const LoadQuestions({required this.testType});
  @override
  List<Object?> get props => [testType];
}

class SelectAnswer extends AssessmentEvent {
  final String questionId;
  final String answer;
  const SelectAnswer({required this.questionId, required this.answer});
  @override
  List<Object?> get props => [questionId, answer];
}

class SubmitAssessment extends AssessmentEvent {
  final String testType;
  const SubmitAssessment({required this.testType});
  @override
  List<Object?> get props => [testType];
}
