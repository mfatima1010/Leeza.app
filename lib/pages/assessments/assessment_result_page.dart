import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assessment_leeza_app/bloc/assessment_bloc.dart';
import 'package:assessment_leeza_app/bloc/assessment_state.dart';
import 'package:assessment_leeza_app/pages/schedule_page.dart';
import 'package:assessment_leeza_app/pages/assessments/assessment_question_page.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:assessment_leeza_app/utils/app_colors.dart';
import 'package:assessment_leeza_app/utils/app_text_styles.dart';

class AssessmentResultPage extends StatefulWidget {
  final String currentTestType;

  const AssessmentResultPage({Key? key, required this.currentTestType})
      : super(key: key);

  @override
  State<AssessmentResultPage> createState() => _AssessmentResultPageState();
}

class _AssessmentResultPageState extends State<AssessmentResultPage> {
  late SharedPreferences _prefs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Track completed assessments
  Future<List<String>> getCompletedAssessments() async {
    return _prefs.getStringList('completedAssessments') ?? [];
  }

  Future<void> addCompletedAssessment(String testType) async {
    final completed = await getCompletedAssessments();
    if (!completed.contains(testType)) {
      completed.add(testType);
      await _prefs.setStringList('completedAssessments', completed);
    }
  }

  // Complex recommendation logic
  Future<String?> getNextRecommendation(
      String currentTest, String prediction, List<String> completed) async {
    switch (currentTest) {
      case "Adult_AQ":
        if (prediction.toLowerCase().contains("high") ||
            prediction.toLowerCase().contains("medium")) {
          if (!completed.contains("Adult_ASRS_5")) return "Adult_ASRS_5";
        } else {
          if (!completed.contains("Adult_CAT_Q")) return "Adult_CAT_Q";
        }
        break;

      case "Adult_ASRS_5":
        if (prediction.toLowerCase().contains("high")) {
          if (!completed.contains("Adult_AQ")) return "Adult_AQ";
        } else {
          if (!completed.contains("Adult_CAT_Q")) return "Adult_CAT_Q";
        }
        break;

      case "Adult_CAT_Q":
        if (prediction.toLowerCase().contains("high")) {
          if (!completed.contains("Adult_RBQ_2A")) return "Adult_RBQ_2A";
        } else {
          if (!completed.contains("Adult_ASRS_5")) return "Adult_ASRS_5";
        }
        break;

      case "Adult_RBQ_2A":
        if (prediction.toLowerCase().contains("high")) {
          if (!completed.contains("Adult_AQ")) return "Adult_AQ";
        } else {
          if (!completed.contains("Adult_ASRS_5")) return "Adult_ASRS_5";
        }
        break;
    }
    return null; // No further assessment needed
  }

  String getTestDisplayName(String testType) {
    switch (testType) {
      case "Adult_AQ":
        return "Autism Spectrum Quotient (AQ)";
      case "Adult_ASRS_5":
        return "ADHD Self-Report Scale (ASRS-5)";
      case "Adult_CAT_Q":
        return "Camouflaging Autistic Traits Questionnaire (CAT-Q)";
      case "Adult_RBQ_2A":
        return "Repetitive Behavior Questionnaire (RBQ-2A)";
      default:
        return testType;
    }
  }

  Color _getPredictionColor(String prediction, BuildContext context) {
    final lowerPred = prediction.toLowerCase();
    if (lowerPred.contains("low")) return Colors.green;
    if (lowerPred.contains("medium") || lowerPred.contains("moderate"))
      return Colors.yellow;
    if (lowerPred.contains("high")) return Colors.red;
    return Theme.of(context).colorScheme.onBackground;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Assessment Results")),
      body: BlocBuilder<AssessmentBloc, AssessmentState>(
        builder: (context, state) {
          if (state is AssessmentSubmitted) {
            // Add current test to completed list
            addCompletedAssessment(widget.currentTestType);
            final predictionColor =
                _getPredictionColor(state.prediction, context);

            return FutureBuilder<List<String>>(
              future: getCompletedAssessments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Results Display
                      Text(
                        "Know Yourself Better!",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: predictionColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Your Score: ${state.score}",
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.prediction,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: predictionColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Book Consultation Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const SchedulePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          "Book Consultation",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // New Recommendation Section
                      FutureBuilder<String?>(
                        future: getNextRecommendation(
                          widget.currentTestType,
                          state.prediction,
                          snapshot.data!,
                        ),
                        builder: (context, recommendationSnapshot) {
                          if (!recommendationSnapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          final nextTest = recommendationSnapshot.data;
                          if (nextTest != null) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColor.strokeGrey),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.primary.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Recommended Assessment",
                                    style: AppTextStyles.s20(
                                      color: AppColor.primary,
                                      fontType: FontType.SEMI_BOLD,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "We recommend taking the ",
                                          style: AppTextStyles.s16(
                                            color: AppColor.textDarkGrey,
                                            fontType: FontType.REGULAR,
                                          ),
                                        ),
                                        TextSpan(
                                          text: getTestDisplayName(nextTest),
                                          style: AppTextStyles.withUnderline(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontType: FontType.SEMI_BOLD,
                                            size: 16,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      AssessmentQuestionPage(
                                                    testType: nextTest,
                                                  ),
                                                ),
                                              );
                                            },
                                        ),
                                        TextSpan(
                                          text: " next",
                                          style: AppTextStyles.s16(
                                            color: AppColor.textDarkGrey,
                                            fontType: FontType.REGULAR,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Text(
                            "No further assessments needed at this time.",
                            style: AppTextStyles.s18(
                              color: AppColor.textGrey,
                              fontType: FontType.REGULAR,
                            ).copyWith(fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // FAQ Section
                      Text(
                        "FAQs",
                        style: AppTextStyles.s24(
                          color: AppColor.primary,
                          fontType: FontType.BOLD,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...faqData.entries.map((entry) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColor.strokeGrey),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primary.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              title: Text(
                                entry.key,
                                style: AppTextStyles.s18(
                                  color: AppColor.textDarkGrey,
                                  fontType: FontType.SEMI_BOLD,
                                ),
                              ),
                              children: entry.value.map((faq) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        faq["question"]!,
                                        style: AppTextStyles.s16(
                                          color: AppColor.primary,
                                          fontType: FontType.MEDIUM,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        faq["answer"]!,
                                        style: AppTextStyles.s14(
                                          color: AppColor.textGrey,
                                          fontType: FontType.REGULAR,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),

                      // Assessment References
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.strokeGrey),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primary.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Assessment References",
                              style: AppTextStyles.s24(
                                color: AppColor.primary,
                                fontType: FontType.BOLD,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                _buildReferenceItem(
                                    "AQ",
                                    "The Autism-Spectrum Quotient (AQ)",
                                    "Baron-Cohen et al., 2001"),
                                _buildReferenceItem(
                                    "CAT-Q",
                                    "Development and Validation of the Camouflaging Autistic Traits Questionnaire",
                                    "Hull et al., 2018"),
                                _buildReferenceItem(
                                    "RBQ",
                                    "Assessing repetitive behaviour using the Adult RBQ-2A",
                                    "Barrett et al., 2015"),
                                _buildReferenceItem(
                                    "ASRS-5",
                                    "The WHO Adult ADHD Self-Report Scale",
                                    "Kessler et al., 2005"),
                                _buildReferenceItem(
                                    "AQ-10",
                                    "Abbreviated version of the AQ",
                                    "Allison, Auyeung & Baron-Cohen, 2012"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  final Map<String, List<Map<String, String>>> faqData = {
    "Child AQ-10": [
      {
        "question": "How do you diagnose Autism?",
        "answer":
            "A comprehensive assessment including questionnaires and specialist feedback."
      },
      {
        "question": "How long does an autism assessment last?",
        "answer": "Approximately 30 minutes to 2 hours."
      },
      {
        "question": "Who will conduct my assessment?",
        "answer": "Qualified professionals conduct the assessment."
      },
      {
        "question": "Do you offer face-to-face or online appointments?",
        "answer":
            "Both are available; face-to-face is offered only in Hyderabad."
      },
    ],
    "ASRS-5": [
      {
        "question": "How do you diagnose ADHD?",
        "answer":
            "Using symptom checklists, behavior rating scales, and childhood reports."
      },
      {
        "question": "What information do I need to provide?",
        "answer":
            "Pre-assessment questionnaires and details from someone who knew you in childhood."
      },
      {
        "question": "Who will conduct my assessment?",
        "answer": "Experienced psychiatrists conduct the assessment."
      },
      {
        "question": "Do you offer online assessments?",
        "answer": "Yes, subject to availability."
      },
    ],
    "Adult Assessments": [
      {
        "question": "How do you diagnose Autism in adults?",
        "answer":
            "Through structured clinical assessments and behavioral analysis."
      },
      {
        "question": "How long does an autism assessment last?",
        "answer": "Typically 30 minutes to 2 hours."
      },
      {
        "question": "Who conducts the assessment?",
        "answer": "Qualified clinicians conduct the assessment."
      },
      {
        "question": "Are online consultations available?",
        "answer":
            "Yes, though in-person assessments are available only in Hyderabad."
      },
    ],
  };

  Widget _buildReferenceItem(String code, String title, String authors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  code,
                  style: AppTextStyles.s14(
                    color: AppColor.primary,
                    fontType: FontType.SEMI_BOLD,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.s14(
                    color: AppColor.textDarkGrey,
                    fontType: FontType.MEDIUM,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text(
              authors,
              style: AppTextStyles.s12(
                color: AppColor.textGrey,
                fontType: FontType.REGULAR,
              ).copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
