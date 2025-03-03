import 'package:flutter/material.dart';
// import '../assessment_page.dart'; // ✅ Ensure correct import

import 'assessment_question_page.dart';

class AssessmentListPage extends StatelessWidget {
  final String category; // "Adult" or "Child"
  final List<String>
      tests; // e.g. ["Adult_AQ", "Adult_ASRS_5", "Adult_AQ_10", ...]

  const AssessmentListPage(
      {Key? key, required this.category, required this.tests})
      : super(key: key);

  void _navigateToAssessment(BuildContext context, String testType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssessmentQuestionPage(testType: testType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$category Assessments")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tests.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(
                tests[index],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: ElevatedButton(
                onPressed: () => _navigateToAssessment(context, tests[index]),
                child: const Text("Take Assessment"),
              ),
            ),
          );
        },
      ),
    );
  }
}
