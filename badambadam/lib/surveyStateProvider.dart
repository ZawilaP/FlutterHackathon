import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';

// Would be perfect to use something like this but it doesn't work for me for whatever reason (probably related to paths)
class MySurveyState extends ChangeNotifier {
  Set scoredQuestions = {};

  void addScoredQuestion(Node? questionNode) {
    scoredQuestions.add(questionNode!.id);
    notifyListeners();
  }

  void removeScoredQuestion(Node? questionNode) {
    scoredQuestions.remove(questionNode!.id);
    notifyListeners();
  }
}