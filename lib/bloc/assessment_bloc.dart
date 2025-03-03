import 'package:flutter_bloc/flutter_bloc.dart';
import 'assessment_event.dart';
import 'assessment_state.dart';
import '../repositories/question_repository.dart';
import 'package:assessment_leeza_app/assessment_logic.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  final QuestionRepository questionRepository;

  AssessmentBloc({required this.questionRepository})
      : super(AssessmentInitial()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<SelectAnswer>(_onSelectAnswer);
    on<SubmitAssessment>(_onSubmitAssessment);
  }

  Future<void> _onLoadQuestions(
      LoadQuestions event, Emitter<AssessmentState> emit) async {
    emit(AssessmentLoading());
    try {
      final questions = await questionRepository.fetchQuestions(event.testType);
      emit(AssessmentLoaded(questions: questions, responses: {}));
    } catch (e) {
      emit(AssessmentError(message: "Failed to load questions: $e"));
    }
  }

  void _onSelectAnswer(SelectAnswer event, Emitter<AssessmentState> emit) {
    final currentState = state;
    if (currentState is AssessmentLoaded) {
      final updatedResponses = Map<String, String>.from(currentState.responses);
      updatedResponses[event.questionId] = event.answer;
      emit(AssessmentLoaded(
          questions: currentState.questions, responses: updatedResponses));
    }
  }

  void _onSubmitAssessment(
      SubmitAssessment event, Emitter<AssessmentState> emit) {
    final currentState = state;
    if (currentState is AssessmentLoaded) {
      final totalScore = findScore(
          event.testType, currentState.questions, currentState.responses);
      final prediction = findPrediction(event.testType, totalScore);
      emit(AssessmentSubmitted(score: totalScore, prediction: prediction));
    }
  }
}
