import 'package:equatable/equatable.dart';
import '../models/question_model.dart';

abstract class AssessmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssessmentInitial extends AssessmentState {}

class AssessmentLoading extends AssessmentState {}

class AssessmentLoaded extends AssessmentState {
  final List<Question> questions;
  final Map<String, String> responses; // key: question id, value: chosen option

  AssessmentLoaded({required this.questions, required this.responses});
  @override
  List<Object?> get props => [questions, responses];
}

class AssessmentSubmitted extends AssessmentState {
  final int score;
  final String prediction;
  AssessmentSubmitted({required this.score, required this.prediction});
  @override
  List<Object?> get props => [score, prediction];
}

class AssessmentError extends AssessmentState {
  final String message;
  AssessmentError({required this.message});
  @override
  List<Object?> get props => [message];
}
