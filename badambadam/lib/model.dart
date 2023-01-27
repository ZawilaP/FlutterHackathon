import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

/// Survey id is always two IDs
/// user readable one and a guid for secure access
class SurveyIDPair {
  String surveyID;
  String accessGUID;
  SurveyIDPair(this.surveyID, this.accessGUID);
}

class FakeBackendSingleton {
  static final FakeBackendSingleton _singleton =
      FakeBackendSingleton._internal();

  factory FakeBackendSingleton() {
    return _singleton;
  }

  FakeBackendSingleton._internal();

  Survey? survey; // null at start, filled in asynchonously via getSurvey()

  /// currently hardcoded ID to start with, backend will need to handle that somehow
  SurveyIDPair registerNewSurvey() {
    return SurveyIDPair("1", Uuid().v4().toString());
  }

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

enum DetailLevel { highLevel, detailed }

enum NodeStatus { unansweredYet, answered }

enum NodeAnswer { yes, no, third }

class Survey {
  List<Node> nodes = [];
  DetailLevel detailLevel = DetailLevel.highLevel;
  late String postalCode;
  late DateTime birthDate;
  late String simpleID;
  late String accessGUID;

  // -1 is "not able to calculate"
  int calculateResult() {
    return -1;
  }

  // load survey from json file (from backend later)
  Future<Survey> load() async {
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

  /// returns a node by its id
  Node? getNodeById(String id) {
    for (var node in nodes) {
      if (node.id == id) {
        return node;
      }
    }
    return null;
  }

  /// returns a list of all top level nodes (For first, high level only survey)
  List<Node> getTopLevelNodesOnly() {
    List<Node> result = [];
    for (var node in nodes) {
      if (node.isTopLevel) {
        result.add(node);
      }
    }
    result.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
    return result;
  }
}

class Node {
  late String id;
  late String author;
  late bool isTopLevel;
  late bool isInverted;
  late String nodeType;
  List<Question> questions = [];

  String? noPath;
  String? yesPath;
  String? thirdPath;

  NodeStatus status = NodeStatus.unansweredYet;
  NodeAnswer? answer;

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
