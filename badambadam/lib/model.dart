import 'dart:convert';
import 'package:flutter/services.dart';

class FakeBackendSingleton {
  static final FakeBackendSingleton _singleton =
      FakeBackendSingleton._internal();

  factory FakeBackendSingleton() {
    return _singleton;
  }

  FakeBackendSingleton._internal();

  Survey? survey; // null at start, filled in asynchonously

  Future<Survey> getSurvey(String? guid) async {
    // can get a past survey from backend (not implemented now) via a guid
    // or get the survey from the local json file (if guid is null)
    // if the survey is already loaded, returns it from memory
    if (guid == null) {
      if (this.survey == null) {
        this.survey = Survey();
        return survey!.load();
      } else {
        return Future(() => survey!);
      }
    } else {
      throw Exception("GetSurvey(guid) not implemented");
    }
  }
}

class Survey {
  List<Node> nodes = [];
  Future<Survey> load() async {
    // load survey from json file
    String data = await rootBundle.loadString("assets/survey_v1.json");
    final jsonResult = jsonDecode(data);
    // get all the nodes processed one by one
    for (var node in jsonResult["questions"]) {
      Node n = Node(node["id"], node["author"], node["is_top_level"],
          node["is_inverted"], node["node_type"], node["questions"]);
      nodes.add(n);
    }
    return this;
  }
}

class Node {
  late String id;
  late String author;
  late bool isTopLevel;
  late bool isInverted;
  late String nodeType;
  String? noPath;
  String? yesPath;
  String? thirdPath;
  List<Question> questions = [];
  Node(String _id, String _author, String _isTopLevel, String _isInverted,
      String _nodeType, List<dynamic> _questions) {
    id = _id;
    author = _author;
    isTopLevel = _isTopLevel == "YES" ? true : false;
    isInverted = _isInverted == "YES" ? true : false;
    nodeType = _nodeType;
    questions = [];
    for (var q in _questions) {
      questions.add(Question(q.toString()));
    }
  }
  @override
  String toString() {
    return "Node: $id, $author, $isTopLevel, $isInverted, $nodeType, $questions";
  }
}

class Question {
  String text = "empty";
  bool isNegated = false;
  Question(String _text) {
    if (_text.startsWith("[P]")) {
      isNegated = false;
      text = _text.substring(3);
    } else if (_text.startsWith("[N]")) {
      isNegated = true;
      text = _text.substring(3);
    } else {
      text = _text;
    }
  }

  @override
  String toString() {
    return "Question: $text, Negated: $isNegated";
  }
}
