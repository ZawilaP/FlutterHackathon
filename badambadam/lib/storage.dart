import 'package:badambadam/model.dart';
import 'package:get_storage/get_storage.dart';

String getBirthDateString() {
  final box = GetStorage();
  return box.read("birthDate") ?? "";
}

void setBirthDateString(String birthDate) {
  final box = GetStorage();
  box.remove("birthDate");
  box.write("birthDate", birthDate);
}

String getPostalCode() {
  final box = GetStorage();
  return box.read("postalCode") ?? "";
}

void setPostalCode(String postalCode) {
  final box = GetStorage();
  box.remove("postalCode");
  box.write("postalCode", postalCode);
}

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

void addAllAnswersMap(Map<String, int> answers) {
  final box = GetStorage();
  box.remove('answersMap');
  box.write('answersMap', answers);
}

Map<String, int> getAllAnswersMap() {
  final box = GetStorage();
  print(box.read("answersMap"));
  return box.read("answersMap")?.cast<String, int>() ?? {};
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

void addAdvancedSurveyQuestions(List<List<String>> advancedSurveyQuestions) {
  final box = GetStorage();
  box.remove('advancedSurveyQuestions');
  box.write('advancedSurveyQuestions', advancedSurveyQuestions);
}

List<List<String>> getAdvancedSurveyQuestions() {
  final box = GetStorage();
  return box.read('advancedSurveyQuestions') ?? List.empty();
}

void addAllAdvancedRawAnswersMap(Map<String, List<String>> answers) {
  final box = GetStorage();
  box.remove('advancedRawAnswersMap');
  box.write('advancedRawAnswersMap', answers);
}

Map<String, List<String>> getAllAdvancedRawAnswersMap() {
  final box = GetStorage();
  print(box.read("advancedRawAnswersMap"));
  return box.read("advancedRawAnswersMap")?.cast<String, List<String>>() ?? {};
}

Future<void> writeCurrentAnswers() async {
  saveSurvey(getCurrentGuid(), getAllAnswersMap().values.toList());
}

Future<void> writeCurrentAdvancedAnswers(
    Map<dynamic, dynamic> allAnswers) async {
  saveAdvancedSurvey(getCurrentGuid(), allAnswers.values.toList());
}

Future<void> writeCurrentAdvancedRawAnswers(
    Map<dynamic, dynamic> allUneditedAnswers) async {
  saveAdvancedRawSurvey(getCurrentGuid(), allUneditedAnswers);
}

 Map<dynamic, dynamic> getCurrentAdvancedAnswers() {
  final box = GetStorage();
  return box.read("currentAnswersTuple") ?? {};
}

void addFinalAdvancedScore(Map<String, int> allUneditedAnswers) {
  final box = GetStorage();
  var score = allUneditedAnswers.values.reduce((a, b) => a + b);
  box.write('advancedScore', score);
}

int getFinalAdvancedScore() {
  final box = GetStorage();
  return box.read('advancedScore') ?? 0;
}
