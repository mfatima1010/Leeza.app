class AssessmentQuestion {
  final String id;
  final String question;
  final List<String> options;

  AssessmentQuestion(
      {required this.id, required this.question, required this.options});

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      id: json['Qid'],
      question: json['Question'],
      options: List<String>.from(json['Options']),
    );
  }
}
