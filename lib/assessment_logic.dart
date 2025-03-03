import 'package:assessment_leeza_app/models/question_model.dart';
import 'data/adult_scores.dart';
import 'data/child_scores.dart';

/// Computes total score given the test type, the list of questions, and the responses.
/// Assumes that the order of questions in the list corresponds to the order of scoring maps.
int findScore(
    String testType, List<Question> questions, Map<String, String> responses) {
  int totalScore = 0;
  switch (testType) {
    case "Adult_AQ":
      for (int i = 0; i < questions.length; i++) {
        final answer = responses[questions[i].id];
        if (answer != null) {
          totalScore += AdultScores.AQ_scores[i][answer] ?? 0;
        }
      }
      break;
    case "Adult_ASRS_5":
      for (int i = 0; i < questions.length; i++) {
        final answer = responses[questions[i].id];
        if (answer != null) {
          totalScore += AdultScores.ASRS_5_Scores[answer] ?? 0;
        }
      }
      break;
    case "Adult_AQ_10":
      for (int i = 0; i < questions.length; i++) {
        final answer = responses[questions[i].id];
        if (answer != null) {
          totalScore += AdultScores.AQ_10_Scores[i][answer] ?? 0;
        }
      }
      break;
    case "Adult_CAT_Q":
      for (int i = 0; i < questions.length; i++) {
        final answer = responses[questions[i].id];
        if (answer != null) {
          totalScore += AdultScores.CAT_Q_Scores[i][answer] ?? 0;
        }
      }
      break;
    case "Adult_RBQ_2A":
      for (int i = 0; i < questions.length; i++) {
        final answer = responses[questions[i].id];
        if (answer != null) {
          totalScore += AdultScores.RBQ_2A_Scores[i][answer] ?? 0;
        }
      }
      break;
    case "Child_ASQ":
      // For the ASQ test, assume: "Yes" = 0, "No" = 1.
      for (int i = 0; i < questions.length; i++) {
        final answer = responses[questions[i].id];
        if (answer != null) {
          totalScore += (answer == "Yes" ? 0 : 1);
        }
      }
      break;
    case "Child_AQ":
      // For the Child AQ, we define a mapping.
      final Map<String, int> childAQMapping = {
        "Definitely Agree": 1,
        "Slightly Agree": 1,
        "Slightly Disagree": 0,
        "Definitely Disagree": 0,
      };
      for (int i = 0; i < questions.length; i++) {
        final answer = responses[questions[i].id];
        if (answer != null) {
          totalScore += childAQMapping[answer] ?? 0;
        }
      }
      break;
    default:
      throw Exception("Invalid test type for scoring");
  }
  return totalScore;
}

/// Returns a prediction string based on score and test type.
String findPrediction(String testType, int score) {
  switch (testType) {
    case "Adult_AQ":
      if (score < 26) return "Low chances of Autism";
      if (score <= 32) return "Medium chances of Autism";
      return "High chances of Autism";
    case "Adult_ASRS_5":
      return score < 14 ? "Low chances of ADHD" : "High chances of ADHD";
    case "Adult_AQ_10":
      return score < 6
          ? "Low chances of Autism"
          : "High chances of Asperger's Syndrome";
    case "Adult_CAT_Q":
      return score < 100
          ? "Low chances of Comorbid conditions"
          : "High chances of Comorbid conditions";
    case "Adult_RBQ_2A":
      if (score <= 25) return "Very low chances of Autism";
      if (score <= 35) return "Medium chances of Autism";
      return "High chances of Autism";
    case "Child_ASQ":
      // Example thresholds for the ASQ test.
      if (score <= 2) return "Low concerns regarding development";
      if (score <= 5) return "Moderate concerns";
      return "High concerns regarding development";
    case "Child_AQ":
      if (score < 6) return "Low chances of Autism";
      return "High chances of Autism";
    default:
      return "";
  }
}
