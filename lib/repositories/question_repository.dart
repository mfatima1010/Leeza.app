import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:assessment_leeza_app/models/question_model.dart';

class QuestionRepository {
  Future<List<Question>> fetchQuestions(String testType) async {
    late String filePath;
    switch (testType) {
      case "Adult_AQ":
        filePath = "assets/json/adult_AQ.json";
        break;
      case "Adult_ASRS_5":
        filePath = "assets/json/adult_ASRS_5.json";
        break;
      case "Adult_AQ_10":
        filePath = "assets/json/adult_AQ_10.json";
        break;
      case "Adult_CAT_Q":
        filePath = "assets/json/adult_CAT_Q.json";
        break;
      case "Adult_RBQ_2A":
        filePath = "assets/json/adult_RBQ_2A.json";
        break;
      case "Child_ASQ":
        filePath = "assets/json/child_ASQ.json";
        break;
      case "Child_AQ":
        filePath = "assets/json/child_AQ.json";
        break;
      default:
        throw Exception("Invalid test type");
    }
    final String response = await rootBundle.loadString(filePath);
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Question.fromJson(json)).toList();
  }
}
