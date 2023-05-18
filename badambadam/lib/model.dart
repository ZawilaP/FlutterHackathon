import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:math';

String generateRandomString(int length) {
  var rand = Random();
  var codeUnits = List.generate(length, (index) {
    int charCode;
    do {
      charCode = rand.nextInt(127);
    } while (!isAlphanumeric(charCode));
    return charCode;
  });

  return String.fromCharCodes(codeUnits);
}

bool isAlphanumeric(int charCode) {
  return (charCode >= 48 && charCode <= 57) ||
      (charCode >= 65 && charCode <= 90) ||
      (charCode >= 97 && charCode <= 122);
}

void sortListById(List<dynamic> list) {
  list.sort((a, b) {
    double idA = double.parse(a['id'].replaceAll('_', '.'));
    double idB = double.parse(b['id'].replaceAll('_', '.'));
    return idA.compareTo(idB);
  });
}

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

  /// Calculates the survey result
  /// -1 is "not able to calculate", 0+ integer is a real result
  /// implemented only for high level survey
  // int calculateResult() {
  //   if (detailLevel == DetailLevel.detailed) {
  //     return -1;
  //   } else {
  //     int result = 0;
  //     for (var node in nodes) {
  //       // checking top level nodes only
  //       if (node.isTopLevel) {
  //         if (node.status != NodeStatus.answered) {
  //           print('No answer for ${node.questions[0].text}');
  //           return -1; // at least one not answered, unable to calculate
  //         }
  //       }
  //       if (node.isInverted) {
  //         result += node.answer == NodeAnswer.no ? 1 : 0;
  //       } else {
  //         result += node.answer == NodeAnswer.yes ? 1 : 0;
  //       }
  //     }
  //     return result;
  //   }
  // }

  Future<void> register() async {
    //
    DatabaseReference ref = FirebaseDatabase.instance.ref("surveyIds");
    final snapshot = await ref.orderByValue().limitToLast(1).get();
    dynamic lastIdsnap = snapshot.value as Map;
    dynamic lastId = lastIdsnap[lastIdsnap.keys.toList().first];
    String newGuid = generateRandomString(128);
    DatabaseReference refNew =
        FirebaseDatabase.instance.ref("surveyIds/$newGuid");
    await refNew.set(lastId + 1);
    // final snapshotNew = await refNew.get();
    // return snapshotNew.value as Map;
  }

  //
  Future<void> updateQuestion(int questionId, Map<String, dynamic> data) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("questions/$questionId");
    await ref.update(data);
  }

  // load survey from json file (from backend later)
  Future<Survey> load() async {
    await register();
    // await saveSurvey("231231", ["dummyvalue"]);
    // await updateQuestion(81, {"questions/0": "PG13"});
    // await saveNewAdmin("admin@admin.com", "admin");

    final ref2 = FirebaseDatabase.instance.ref();
    final snapshot = await ref2.get();
    var x = snapshot.value as Map;

    List questions = x["questions"] as List;
    sortListById(questions);
    for (var item in questions) {
      Node n = Node(item["id"], item["is_top_level"], item["is_inverted"],
          item["node_type"], item["question_group_id"], item["questions"]);
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
  late bool isTopLevel;
  late bool isInverted;
  late String nodeType;
  late String questionGroupId;
  List<Question> questions = [];

  String? noPath;
  String? yesPath;
  String? thirdPath;

  NodeStatus status = NodeStatus.unansweredYet;
  NodeAnswer? answer;

  Node(String _id, String _isTopLevel, String _isInverted, String _nodeType, String _question_group_id,
      List<dynamic> _questions) {
    id = _id;
    isTopLevel = _isTopLevel == "YES" ? true : false;
    isInverted = _isInverted == "YES" ? true : false;
    nodeType = _nodeType;
    questionGroupId = _question_group_id;
    questions = [];
    for (var q in _questions) {
      questions.add(Question(q.toString()));
    }
  }
  @override
  String toString() {
    return "Node: $id, $isTopLevel, $isInverted, $nodeType, $questionGroupId, $questions";
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
    return text;
  }
}

Future<void> saveSurvey(String guid, List<dynamic> data) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref(
      "answers/${guid.replaceAll(".", "-").replaceAll(" ", "-").replaceAll(":", "-").replaceAll("_", "-")}");
  await ref.set(data);
}

Future<void> saveAdvancedSurvey(String guid, Map<dynamic, dynamic> data) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref(
      "advancedAnswers/${guid.replaceAll(".", "-").replaceAll(" ", "-").replaceAll(":", "-").replaceAll("_", "-")}");
  await ref.set(data);
}

Future<void> saveAdvancedRawSurvey(String guid, Map<dynamic, dynamic> data) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref(
      "advancedRawAnswers/${guid.replaceAll(".", "-").replaceAll(" ", "-").replaceAll(":", "-").replaceAll("_", "-")}");
  await ref.set(data);
}

Future<void> saveNewAdmin(String email, String password) async {
  DatabaseReference refEmail =
      FirebaseDatabase.instance.ref("admin/${email.split("@").first}/email");
  DatabaseReference refPassword =
      FirebaseDatabase.instance.ref("admin/${email.split("@").first}/password");
  await refEmail.set(email);
  await refPassword.set(password);
}

Future<dynamic> getAdminCredentials(String id) async {
  final ref2 = FirebaseDatabase.instance.ref();
  final snapshot = await ref2.get();
  var x = snapshot.value as Map;
  try {
    return x["admin"][id];
  } on Error catch (_) {
    return {};
  }
}

Future<Map<String, dynamic>> getSurveyAnswers() async {
  final ref2 = FirebaseDatabase.instance.ref("answers");
  final snapshot = await ref2.get();
  var x = snapshot.value as Map<String, dynamic>;
  return x;
}

Future<dynamic> getAdvancedSurveyAnswers() async {
  final ref2 = FirebaseDatabase.instance.ref("advancedAnswers");
  final snapshot = await ref2.get();
  var x = snapshot.value as Map;
  return x;
}

Future<Map<String, dynamic>> getAdvancedSurveyRawAnswers() async {
  final ref2 = FirebaseDatabase.instance.ref("advancedRawAnswers");
  final snapshot = await ref2.get();
  var x = snapshot.value as Map<String, dynamic>;
  return x;
}

String generateSixDigitString() {
  Random random = Random();
  String result = '';

  for (int i = 0; i < 6; i++) {
    result += random.nextInt(10).toString();
  }
  return result;
}
