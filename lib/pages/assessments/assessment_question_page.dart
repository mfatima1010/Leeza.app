import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assessment_leeza_app/bloc/assessment_bloc.dart';
import 'package:assessment_leeza_app/bloc/assessment_event.dart';
import 'package:assessment_leeza_app/bloc/assessment_state.dart';
import 'package:assessment_leeza_app/repositories/question_repository.dart';
import 'package:assessment_leeza_app/utils/app_colors.dart';
import 'assessment_result_page.dart';

class AssessmentQuestionPage extends StatefulWidget {
  final String testType;
  const AssessmentQuestionPage({Key? key, required this.testType})
      : super(key: key);

  @override
  _AssessmentQuestionPageState createState() => _AssessmentQuestionPageState();
}

class _AssessmentQuestionPageState extends State<AssessmentQuestionPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  String getReferenceText(String testType) {
    switch (testType) {
      case "Adult_AQ":
      case "Adult_AQ_10":
        return "Reference: The Autism-Spectrum Quotient (AQ) (Baron-Cohen et al., 2001)";
      case "Adult_CAT_Q":
        return "Reference: Development and Validation of the Camouflaging Autistic Traits Questionnaire (CAT-Q) (Hull et al., 2018)";
      case "Adult_RBQ_2A":
        return "Reference: Assessing repetitive behaviour using the Adult RBQ-2A (Barrett et al., 2015)";
      case "Adult_ASRS_5":
        return "Reference: The WHO Adult ADHD Self-Report Scale (ASRS) (Kessler et al., 2005)";
      case "Child_ASQ":
      case "Child_AQ":
        return "Reference: Allison, Auyeung & Baron-Cohen (2012)";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AssessmentBloc(questionRepository: QuestionRepository())
            ..add(LoadQuestions(testType: widget.testType)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.testType} Assessment",
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        body: BlocConsumer<AssessmentBloc, AssessmentState>(
          listener: (context, state) {
            if (state is AssessmentSubmitted) {
              final currentBloc = context.read<AssessmentBloc>();
              Future.microtask(() {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => BlocProvider.value(
                      value: currentBloc,
                      child: AssessmentResultPage(
                        currentTestType: widget.testType,
                      ),
                    ),
                  ),
                );
              });
            }
          },
          builder: (context, state) {
            if (state is AssessmentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AssessmentLoaded) {
              final totalQuestions = state.questions.length;
              return Stack(
                children: [
                  // Questions section with PageView
                  Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: totalQuestions,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final question = state.questions[index];
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            question.text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          Column(
                                            children:
                                                question.options.map((option) {
                                              bool isSelected = state
                                                      .responses[question.id] ==
                                                  option;
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: isSelected
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : AppColor.lightGrey,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    elevation:
                                                        isSelected ? 4 : 0,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16),
                                                  ),
                                                  onPressed: () {
                                                    context
                                                        .read<AssessmentBloc>()
                                                        .add(SelectAnswer(
                                                            questionId:
                                                                question.id,
                                                            answer: option));
                                                    if (index <
                                                        totalQuestions - 1) {
                                                      _pageController.nextPage(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        curve: Curves.easeIn,
                                                      );
                                                    } else {
                                                      context
                                                          .read<
                                                              AssessmentBloc>()
                                                          .add(SubmitAssessment(
                                                              testType: widget
                                                                  .testType));
                                                    }
                                                  },
                                                  child: Text(
                                                    option,
                                                    style: TextStyle(
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Progress indicator section
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Column(
                                      children: [
                                        LinearProgressIndicator(
                                          value: totalQuestions == 0
                                              ? 0
                                              : (_currentPage + 1) /
                                                  totalQuestions,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                          minHeight: 8,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Question ${_currentPage + 1} of $totalQuestions",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColor.instructionText
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "When answering the above questions, please consider how much the statements apply to you. These questions are indicative only and do not form a formal diagnosis.",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColor.instructionText,
                                            height: 1.4,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColor.referenceText
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      getReferenceText(widget.testType),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColor.referenceText,
                                            fontStyle: FontStyle.italic,
                                            height: 1.4,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is AssessmentError) {
              return Center(
                  child: Text(state.message,
                      style: Theme.of(context).textTheme.bodyLarge));
            }
            return const Center(child: Text("Something went wrong!"));
          },
        ),
      ),
    );
  }
}
