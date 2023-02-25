import 'package:badambadam/screens/advancedSurveyScreen/advancedSingleQuestionWidget.dart';
import 'package:badambadam/screens/advancedSurveyScreen/singleSelectWidget.dart';
import 'package:flutter/material.dart';
import '../../model.dart';
import '../../storage.dart';
import 'radioResponseWidget.dart';
import 'advancedTextFieldWidget.dart';
import 'dart:convert';

class AdvancedSurveyDisplayScreen extends StatefulWidget {
  AdvancedSurveyDisplayScreen({
    super.key, required this.allPrimaryAnswers,
  });

  final Map<String, int>? allPrimaryAnswers;

  @override
  State<AdvancedSurveyDisplayScreen> createState() =>
      _AdvancedSurveyDisplayScreenState();
}

class _AdvancedSurveyDisplayScreenState
    extends State<AdvancedSurveyDisplayScreen> {
  Survey? survey;

  void showSurvey(Survey s) {
    setState(() {
      survey = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (survey == null) {
      // if not there - then load one
      FakeBackendSingleton().getSurvey(null).then(showSurvey);
      try {
      widget.allPrimaryAnswers!.removeWhere((key, value) => value != 1);
      } catch (e) {
        print(e);
      }

      return Center(child: Text('Loading...'));
    } else {
      
      // filter questions that were scored in the primary survey
      List<Node> allNodes = survey!.nodes.where((element) =>
          widget.allPrimaryAnswers!.keys.contains(element.id.split('_')[0]))
      .toList();

      // used for storing all answers
      final ValueNotifier<Map<String, List<String>>> allAdvancedAnswersDetail =
          ValueNotifier<Map<String, List<String>>>({
        for (var item in allNodes)
          item.id: List<String>.generate(
              item.questions.length > 1
                  ? item.questions.length - 1
                  : item.questions.length,
              (index) =>
                  '-1') // first question for radio buttons is not radio, just a title, that's why length - 1
      });

      final ButtonStyle style = ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 8);

      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Node questionNode = allNodes[index];

              if (allNodes[index].nodeType == 'SingleSelect') {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'Question ${questionNode.id} ${questionNode.questions[0]}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height * 0.2,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.8),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: questionNode.questions.length - 1,
                                  itemBuilder: ((context, inputIndex) {
                                    return SingleSelect(
                                        allAdvancedAnswersDetails:
                                            allAdvancedAnswersDetail,
                                        question: questionNode,
                                        inputIndex: inputIndex);
                                  }))),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (questionNode.nodeType == 'Simple_Yes_No') {
                return AdvancedSingleQuestion(
                  questionNode: questionNode,
                  allAnswers: allAdvancedAnswersDetail,
                  mainIndex: index,
                );
              } else if (questionNode.nodeType == 'OneYesWillDoStopAsking' ||
                  questionNode.nodeType == 'YesNoBranching') {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'Question ${questionNode.id} ${questionNode.questions[0]}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height * 0.2,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.9),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: questionNode.questions.length - 1,
                                  itemBuilder: ((context, inputIndex) {
                                    return RadioButtons(
                                        allAdvancedAnswersDetails:
                                            allAdvancedAnswersDetail,
                                        question: questionNode,
                                        inputIndex: inputIndex);
                                  }))),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (questionNode.nodeType == 'OpenTextAnyAnswerWillDo') {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Question ${questionNode.id} ${questionNode.questions[0].toString()}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AdvancedTextField(
                                allAdvancedAnswersDetails:
                                    allAdvancedAnswersDetail,
                                nodeId: questionNode.id),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox();
            }, childCount: allNodes.length)),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                      style: style,
                      onPressed: () {
                        // updateGuidList(
                        // "${DateTime.now().toString().trim()}_test");
                        print("BUTTON PRESSED");
                        writeCurrentAdvancedRawAnswers(
                            allAdvancedAnswersDetail.value);
                        writeCurrentAdvancedAnswers(
                            calculateAll(allAdvancedAnswersDetail));
                        // Navigator.pushNamed(context, '/advancedResult');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 11),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                      )),
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  Map<dynamic, dynamic> calculateAll(
      ValueNotifier<Map<String, List<String>>> allAdvancedAnswers) {
    Map<String, List<String>> answers = allAdvancedAnswers.value;
    Map<String, int> resultsMap = {};
    // 1
    bool onePass = answers["1_01"]!.contains("PASS_YES");
    bool oneFail = answers["1_01"]!.contains("FAIL_YES");
    // it can be optimized, but not for now
    if (!onePass & !oneFail) {
      print("What does he do?");
      resultsMap["1"] = 0;
    } else if (onePass & !oneFail) {
      print("1");
      resultsMap["1"] = 1;
    } else if (!onePass & oneFail) {
      print("1: 0");
      resultsMap["1"] = 0;
    } else if (onePass & oneFail) {
      bool pass = answers["1_02"]!.contains("PASS_YES");
      bool fail = answers["1_02"]!.contains("FAIL_YES");
      if (pass) {
        resultsMap["1"] = 1;
      } else if (fail) {
        resultsMap["1"] = 0;
      }
    }
    // 2
    resultsMap["2"] = answers["2"]!.contains("PASS_YES") ? 0 : 1;
    // 3
    if (answers["3_01"]!.contains("PASS_YES")) {
      resultsMap["3"] = 1;
    }
    //4
    resultsMap["4"] = answers["4_01"]!.contains("PASS_YES") ? 1 : 0;

    //5
    if (!answers["5_01"]!.contains("FAIL_YES")) {
      resultsMap["5"] = 1;
    } else {
      resultsMap["5"] = answers["5_02"]!.contains("PASS_YES") ? 0 : 1;
    }

    //6
    if (!answers["6_01"]!.contains("PASS_YES")) {
      resultsMap["6"] = 0;
    } else {
      resultsMap["6"] = answers["6_02"]!.contains("PASS_YES") ? 1 : 0;
    }
    //7
    if (!answers["7_01"]!.contains("PASS_YES")) {
      resultsMap["7"] = 0;
    } else if (!answers["7_02"]!.contains("PASS_YES")) {
      resultsMap["7"] = 0;
    } else {
      resultsMap["7"] = answers["7_03"]!.contains("PASS_YES") ? 1 : 0;
    }
    //8
    if (answers["8_01"]!.contains("PASS_YES")) {
      resultsMap["8"] = 1;
    } else if (!answers["8_02"]!.contains("PASS_YES")) {
      resultsMap["8"] = 0;
    } else if (!answers["8_03"]!.contains("PASS_YES")) {
      resultsMap["8"] = 0;
    } else {
      resultsMap["8"] = answers["8_04"]!.contains("PASS_YES") ? 1 : 0;
    }
    //9
    if (!answers["9_01"]!.contains("PASS_YES")) {
      resultsMap["9"] = 0;
    } else {
      resultsMap["9"] = answers["9_02"]!.contains("PASS_YES") ? 1 : 0;
    }
    //10
    bool onePassTen = answers["10_01"]!.contains("PASS_YES");
    bool oneFailTen = answers["10_01"]!.contains("FAIL_YES");
    // it can be optimized, but not for now
    if (!onePassTen & !oneFailTen) {
      print("What does he do?");
      resultsMap["10"] = 0;
    } else if (onePassTen & !oneFailTen) {
      resultsMap["10"] = 1;
    } else if (!onePassTen & oneFailTen) {
      resultsMap["10"] = 0;
    } else if (onePassTen & oneFailTen) {
      bool passTen = answers["10_02"]!.contains("PASS_YES");
      bool failTen = answers["10_02"]!.contains("FAIL_YES");
      if (passTen) {
        resultsMap["10"] = 1;
      } else if (failTen) {
        resultsMap["10"] = 0;
      }
    }
    //11
    if (answers["11"]!.contains("PASS_YES")) {
      resultsMap["11"] = 1;
    } else {
      bool onePass11 = answers["11_01"]!.contains("PASS_YES");
      bool oneFail11 = answers["11_01"]!.contains("FAIL_YES");
      // it can be optimized, but not for now
      if (!onePass11 & !oneFail11) {
        print("What does he do?");
        resultsMap["11"] = 0;
      } else if (onePass11 & !oneFail11) {
        resultsMap["11"] = 1;
      } else if (!onePass11 & oneFail11) {
        resultsMap["11"] = 0;
      } else if (onePass11 & oneFail11) {
        bool pass11 = answers["11_02"]!.contains("PASS_YES");
        bool fail11 = answers["11_02"]!.contains("FAIL_YES");
        if (pass11) {
          resultsMap["11"] = 1;
        } else if (fail11) {
          resultsMap["11"] = 0;
        }
      }
    }
    //12
    if (answers["12_01"]!.where((element) => element == "PASS_YES").length <=
        1) {
      resultsMap["12"] = 1;
    } else {
      bool onePass12 = answers["12_02"]!.contains("PASS_YES");
      bool oneFail12 = answers["12_02"]!.contains("FAIL_YES");
      // it can be optimized, but not for now
      if (!onePass12 & !oneFail12) {
        print("What does he do?");
        resultsMap["12"] = 0;
      } else if (onePass12 & !oneFail12) {
        resultsMap["12"] = 1;
      } else if (!onePass12 & oneFail12) {
        resultsMap["12"] = 0;
      } else if (onePass12 & oneFail12) {
        bool pass12 = answers["12_03"]!.contains("PASS_YES");
        bool fail12 = answers["12_03"]!.contains("FAIL_YES");
        if (pass12) {
          resultsMap["12"] = 1;
        } else if (fail12) {
          resultsMap["12"] = 0;
        }
      }
    }
    //13
    resultsMap["13"] = answers["13_01"]!.contains("PASS_YES") ? 1 : 0;

    //14
    int numberOfYes =
        answers["14_01"]!.where((element) => element == "PASS_YES").length;
    if (numberOfYes == 0) {
      resultsMap["14"] = 0;
    } else if (numberOfYes >= 2) {
      resultsMap["14"] = 1;
    } else if (numberOfYes == 1) {
      if (answers["14_02"]!.contains("PASS_NO")) {
        resultsMap["14"] = 0;
      } else {
        resultsMap["14"] = answers["14_03"]!.contains("PASS_YES") ? 1 : 0;
      }
    }
    //15
    int numberOfYes15 =
        answers["15_01"]!.where((element) => element == "PASS_YES").length;
    resultsMap["15"] = numberOfYes >= 2 ? 1 : 0;
    //16

    bool onePass16 = answers["16_01"]!.contains("PASS_YES");
    bool oneFail16 = answers["16_01"]!.contains("FAIL_YES");
    // it can be optimized, but not for now
    if (!onePass16 & !oneFail16) {
      print("What does he do?");
      resultsMap["16"] = 0;
    } else if (onePass16 & !oneFail16) {
      resultsMap["16"] = 1;
    } else if (!onePass16 & oneFail16) {
      resultsMap["16"] = 0;
    } else if (onePass16 & oneFail16) {
      bool pass16 = answers["16_02"]!.contains("PASS_YES");
      bool fail16 = answers["16_02"]!.contains("FAIL_YES");
      if (pass16) {
        resultsMap["16"] = 1;
      } else if (fail16) {
        resultsMap["16"] = 0;
      }
    }
    //17
    resultsMap["17"] = answers["17_01"]!.contains("PASS_YES") ? 1 : 0;

    //18
    if (!answers["18_01"]!.contains("PASS_YES") &&
        !answers["18_02"]!.contains("PASS_YES")) {
      resultsMap["18"] = 0;
    } else {
      resultsMap["18"] = answers["18_03"]!.contains("PASS_YES") ? 1 : 0;
    }
    //19
    if (answers["19_01"]!.contains("PASS_YES")) {
      resultsMap["19"] = 1;
    } else if (answers["19_02"]!.contains("PASS_YES")) {
      resultsMap["19"] = 1;
    } else {
      resultsMap["19"] = answers["19_03"]!.contains("PASS_YES") ? 1 : 0;
    }
    //20
    if (answers["20_01"]!.contains("PASS_YES")) {
      resultsMap["20"] = 1;
    } else {
      resultsMap["20"] = answers["20_02"]!.contains("PASS_YES") ? 1 : 0;
    }
    print("RESULTS");
    print(resultsMap);
    return resultsMap;
  }
}
