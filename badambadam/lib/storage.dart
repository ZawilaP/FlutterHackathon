import 'package:get_storage/get_storage.dart';

List<dynamic> getGuidList() {
  final box = GetStorage();
  print(box.read("guidList"));
  return box.read("guidList") ?? List.empty();
}

void addGuidList(List<dynamic> guidList) {
  final box = GetStorage();
  box.remove("guidList");
  box.write("guidList", guidList);
}

void updateGuidList(dynamic newGuid) {
  List<dynamic> guidList = getGuidList();
  List<dynamic> newGuidList = <dynamic>[newGuid];
  newGuidList.addAll(guidList);
  addGuidList(newGuidList);
}