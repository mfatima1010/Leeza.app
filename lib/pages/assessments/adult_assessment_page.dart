// import 'package:flutter/material.dart';
// import 'package:assessment_leeza_app/bloc/assessment_event.dart';
// import 'package:assessment_leeza_app/pages/assessments/assessment_question_page.dart';

// class AdultAssessments extends StatelessWidget {
//   // Simply navigate to AssessmentQuestionPage without reading any bloc.
//   void _startAssessment(BuildContext context, String testType) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => AssessmentQuestionPage(testType: testType),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> adultTests = [
//       {
//         "title": "AQ (Autism Spectrum Quotient)",
//         "testType": "Adult_AQ",
//         "age": "AGE 16+",
//         "description":
//             "A self-assessment tool used to measure autism spectrum traits in adults.",
//       },
//       {
//         "title": "ASRS-5 (ADHD Screening)",
//         "testType": "Adult_ASRS_5",
//         "age": "AGE 18+",
//         "description":
//             "A quick ADHD screening tool for adults, based on WHO’s ASRS-5.",
//       },
//       {
//         "title": "AQ-10 (Short Autism Test)",
//         "testType": "Adult_AQ_10",
//         "age": "AGE 16+",
//         "description":
//             "A quick 10-question version of the AQ test for autism screening.",
//       },
//       {
//         "title": "CAT-Q (Camouflaging Autistic Traits)",
//         "testType": "Adult_CAT_Q",
//         "age": "AGE 16+",
//         "description":
//             "Measures the extent of social camouflaging in autistic individuals.",
//       },
//       {
//         "title": "Repetitive Behavioral Questions",
//         "testType": "Adult_RBQ_2A",
//         "age": "AGE 16+",
//         "description":
//             "Assesses repetitive behaviors common in autism spectrum disorders.",
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text("Adult Assessments")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: adultTests.length,
//           itemBuilder: (context, index) {
//             final test = adultTests[index];
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

// class AdultAssessments extends StatelessWidget {
//   void _startAssessment(BuildContext context, String testType) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => AssessmentQuestionPage(testType: testType),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> adultTests = [
//       {
//         "title": "AQ (Autism Spectrum Quotient)",
//         "testType": "Adult_AQ",
//         "age": "AGE 16+",
//         "description":
//             "A self-assessment tool used to measure autism spectrum traits in adults.",
//       },
//       {
//         "title": "ASRS-5 (ADHD Screening)",
//         "testType": "Adult_ASRS_5",
//         "age": "AGE 18+",
//         "description":
//             "A quick ADHD screening tool for adults, based on WHO’s ASRS-5.",
//       },
//       {
//         "title": "AQ-10 (Short Autism Test)",
//         "testType": "Adult_AQ_10",
//         "age": "AGE 16+",
//         "description":
//             "A quick 10-question version of the AQ test for autism screening.",
//       },
//       {
//         "title": "CAT-Q (Camouflaging Autistic Traits)",
//         "testType": "Adult_CAT_Q",
//         "age": "AGE 16+",
//         "description":
//             "Measures the extent of social camouflaging in autistic individuals.",
//       },
//       {
//         "title": "Repetitive Behavioral Questions",
//         "testType": "Adult_RBQ_2A",
//         "age": "AGE 16+",
//         "description":
//             "Assesses repetitive behaviors common in autism spectrum disorders.",
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Adult Assessments",
//             style: Theme.of(context).textTheme.headlineMedium),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: adultTests.length,
//           itemBuilder: (context, index) {
//             final test = adultTests[index];
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

class AdultAssessments extends StatelessWidget {
  void _startAssessment(BuildContext context, String testType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AssessmentQuestionPage(testType: testType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> adultTests = [
      {
        "title": "AQ (Autism Spectrum Quotient)",
        "testType": "Adult_AQ",
        "age": "AGE 16+",
        "description":
            "A self-assessment tool used to measure autism spectrum traits in adults.",
      },
      {
        "title": "ASRS-5 (ADHD Screening)",
        "testType": "Adult_ASRS_5",
        "age": "AGE 18+",
        "description":
            "A quick ADHD screening tool for adults, based on WHO’s ASRS-5.",
      },
      {
        "title": "AQ-10 (Short Autism Test)",
        "testType": "Adult_AQ_10",
        "age": "AGE 16+",
        "description":
            "A quick 10-question version of the AQ test for autism screening.",
      },
      {
        "title": "CAT-Q (Camouflaging Autistic Traits)",
        "testType": "Adult_CAT_Q",
        "age": "AGE 16+",
        "description":
            "Measures the extent of social camouflaging in autistic individuals.",
      },
      {
        "title": "Repetitive Behavioral Questions",
        "testType": "Adult_RBQ_2A",
        "age": "AGE 16+",
        "description":
            "Assesses repetitive behaviors common in autism spectrum disorders.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Adult Assessments",
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: adultTests.length,
          itemBuilder: (context, index) {
            final test = adultTests[index];
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
