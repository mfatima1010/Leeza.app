// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:assessment_leeza_app/bloc/assessment_bloc.dart';
// import 'package:assessment_leeza_app/repositories/question_repository.dart';

// class AssessmentPage extends StatelessWidget {
//   final String testType;

//   const AssessmentPage({required this.testType});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AssessmentBloc(
//         questionRepository: QuestionRepository(),
//       )..add(LoadQuestions(testType)),
//       child: Scaffold(
//         appBar: AppBar(title: Text("$testType Assessment")),
//         body: BlocBuilder<AssessmentBloc, AssessmentState>(
//           builder: (context, state) {
//             if (state is AssessmentLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is AssessmentLoaded) {
//               return ListView.builder(
//                 itemCount: state.questions.length,
//                 itemBuilder: (context, index) {
//                   final question = state.questions[index];
//                   return ListTile(
//                     title: Text(question['question']),
//                     trailing: DropdownButton<String>(
//                       value: state.responses[question['qid']],
//                       items: ["Yes", "No"]
//                           .map(
//                               (e) => DropdownMenuItem(value: e, child: Text(e)))
//                           .toList(),
//                       onChanged: (answer) {
//                         context.read<AssessmentBloc>().add(
//                               SelectAnswer(question['qid'], answer!),
//                             );
//                       },
//                     ),
//                   );
//                 },
//               );
//             } else if (state is AssessmentSubmitted) {
//               return Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushNamed('/results');
//                   },
//                   child: Text("Show Results"),
//                 ),
//               );
//             }
//             return Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }
