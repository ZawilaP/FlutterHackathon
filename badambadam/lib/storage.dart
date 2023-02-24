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

void addAllAnswersMap (Map<String, int> answers) {
  final box  = GetStorage();
  box.remove('answersMap');
  box.write('answersMap', answers);
}

Map<String, int> getAllAnswersMap () {
  final box = GetStorage();
  print(box.read("answersMap"));
  return box.read("answersMap") ?? {};
}

void addFinalScore() {
  final box = GetStorage();
  Map<String, int> allAnswers = getAllAnswersMap();
  var score = allAnswers.values.reduce((a, b) => a + b);
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
  saveSurvey(getCurrentGuid(), getAllAnswersMap().values.toList());
}

Future<void> writeCurrentAdvancedAnswers(Map<dynamic, dynamic> allAnswers) async {
  saveAdvancedSurvey(getCurrentGuid(), allAnswers.values.toList());
}

List<dynamic> getCurrentAnswers() {
  final box = GetStorage();
  return box.read("currentAnswersTuple") ?? List.empty();
}