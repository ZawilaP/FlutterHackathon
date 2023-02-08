import 'package:badambadam/model.dart';
import 'package:get_storage/get_storage.dart';


String getCurrentLanguage() {
  final box = GetStorage();
  return box.read("language") ?? "";
}

void setCurrentLanguage(String lang) {
  final box = GetStorage();
  box.remove("language");
  box.write("language", lang);
}

List<dynamic> getGuidList() {
  final box = GetStorage();
  print(box.read("guidList"));
  return box.read("guidList") ?? List.empty();
}

dynamic getCurrentGuid() {
  final box = GetStorage();
  return box.read("currentGuid") ?? "";
}

void updateCurrentGuid(dynamic newGuid) {
  final box = GetStorage();
  box.remove("currentGuid");
  box.write("currentGuid", newGuid);
}

void addGuidList(List<dynamic> guidList) {
  final box = GetStorage();
  box.remove("guidList");
  box.write("guidList", guidList);
}

void updateGuidList(dynamic newGuid) {
  List<dynamic> guidList = getGuidList();
  List<dynamic> newGuidList = <dynamic>[newGuid];
  updateCurrentGuid(newGuid);
  newGuidList.addAll(guidList);
  addGuidList(newGuidList);
}

void addAllAnswersList (List<int> answers) {
  final box  = GetStorage();
  box.remove('answersList');
  box.write('answersList', answers);
}

List<int> getAllAnswersList () {
  final box = GetStorage();
  print(box.read("answersList"));
  return box.read("answersList") ?? List.empty();
}

void addFinalScore() {
  final box = GetStorage();
  List<int> allAnswers = getAllAnswersList();
  var score = allAnswers.reduce((a, b) => a + b);
  box.write('score', score);
}

int getFinalScore() {
  final box = GetStorage();
  return box.read('score') ?? 0;
}

void addAllTopLevelNodes(List<String> topLevelSurvey) {
  final box = GetStorage();
  box.remove('topLevelSurvey');
  box.write('topLevelSurvey', topLevelSurvey);
}

List<String> getTopLevelNodes() {
  final box = GetStorage();
  return box.read('topLevelSurvey') ?? List.empty();
}

Future<void> writeCurrentAnswers() async {
  saveSurvey(getCurrentGuid(), getAllAnswersList());
}

List<dynamic> getCurrentAnswers() {
  final box = GetStorage();
  return box.read("currentAnswersTuple") ?? List.empty();
}