// import 'package:flutter/material.dart';
// import 'package:assessment_leeza_app/pages/assessments/assessment_question_page.dart';

// class ChildAssessments extends StatelessWidget {
//   void _startAssessment(BuildContext context, String testType) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => AssessmentQuestionPage(testType: testType),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> childTests = [
//       {
//         "title": "ASQ (Ages & Stages Questionnaire)",
//         "testType": "Child_ASQ",
//         "age": "AGE 2-5",
//         "description":
//             "A parent-completed screening tool to track early childhood development.",
//       },
//       {
//         "title": "AQ (Autism Spectrum Quotient for Children)",
//         "testType": "Child_AQ",
//         "age": "AGE 4-11",
//         "description":
//             "A widely used autism screening test for young children.",
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text("Child Assessments")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: childTests.length,
//           itemBuilder: (context, index) {
//             final test = childTests[index];
//             return Card(
//               elevation: 4,
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       test["title"]!,
//                       style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       test["age"]!,
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[600]),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       test["description"]!,
//                       style:
//                           const TextStyle(fontSize: 16, color: Colors.black87),
//                     ),
//                     const SizedBox(height: 12),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: ElevatedButton(
//                         onPressed: () =>
//                             _startAssessment(context, test["testType"]!),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepPurple,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           "Start Assessment",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:assessment_leeza_app/pages/assessments/assessment_question_page.dart';

// class ChildAssessments extends StatelessWidget {
//   void _startAssessment(BuildContext context, String testType) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => AssessmentQuestionPage(testType: testType),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> childTests = [
//       {
//         "title": "ASQ (Ages & Stages Questionnaire)",
//         "testType": "Child_ASQ",
//         "age": "AGE 2-5",
//         "description":
//             "A parent-completed screening tool to track early childhood development.",
//       },
//       {
//         "title": "AQ (Autism Spectrum Quotient for Children)",
//         "testType": "Child_AQ",
//         "age": "AGE 4-11",
//         "description":
//             "A widely used autism screening test for young children.",
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Child Assessments",
//             style: Theme.of(context).textTheme.headlineMedium),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: childTests.length,
//           itemBuilder: (context, index) {
//             final test = childTests[index];
//             return Card(
//               elevation: 4,
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       test["title"]!,
//                       style: Theme.of(context).textTheme.headlineMedium,
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       test["age"]!,
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       test["description"]!,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     const SizedBox(height: 12),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: ElevatedButton(
//                         onPressed: () =>
//                             _startAssessment(context, test["testType"]!),
//                         child: const Text("Start Assessment"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:assessment_leeza_app/pages/assessments/assessment_question_page.dart';

class ChildAssessments extends StatelessWidget {
  void _startAssessment(BuildContext context, String testType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AssessmentQuestionPage(testType: testType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> childTests = [
      {
        "title": "ASQ (Ages & Stages Questionnaire)",
        "testType": "Child_ASQ",
        "age": "AGE 2-5",
        "description":
            "A parent-completed screening tool to track early childhood development.",
      },
      {
        "title": "AQ (Autism Spectrum Quotient for Children)",
        "testType": "Child_AQ",
        "age": "AGE 4-11",
        "description":
            "A widely used autism screening test for young children.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Child Assessments",
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: childTests.length,
          itemBuilder: (context, index) {
            final test = childTests[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test["title"]!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      test["age"]!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      test["description"]!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () =>
                            _startAssessment(context, test["testType"]!),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                        child: const Text("Start Assessment",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
