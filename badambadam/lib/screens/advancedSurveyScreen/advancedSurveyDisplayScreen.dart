import 'package:badambadam/screens/advancedSurveyScreen/advancedSingleQuestionWidget.dart';
import 'package:flutter/material.dart';
import '../../model.dart';
import '../../storage.dart';
import 'radioResponseWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class AdvancedSurveyDisplayScreen extends StatefulWidget {
  AdvancedSurveyDisplayScreen({
    super.key,
    required this.allPrimaryAnswers,
  });

  final Map<String, int>? allPrimaryAnswers;

  @override
  State<AdvancedSurveyDisplayScreen> createState() =>
      _AdvancedSurveyDisplayScreenState();
}

class _AdvancedSurveyDisplayScreenState
    extends State<AdvancedSurveyDisplayScreen> {
  String lastLocale = '';

  Survey? survey;

  void showSurvey(Survey s) {
    setState(() {
      survey = s;
    });
  }

  int getAnswersLength(List<String>? answers, String answer) {
    return answers!.where((element) => element == answer).toList().length;
  }

  List<List<String>> getQuestionsList(List<Node> questions) {
    List<String> questionsTextList = [];
    List<List<String>> resultQuestionLists = [];
    for (var element in questions) {
      for (var question in element.questions) {
        questionsTextList.add(question.toString());
      }
      questionsTextList.add(element.nodeType);
      resultQuestionLists.add(questionsTextList);
      questionsTextList = [];
    }
    return resultQuestionLists;
  }

  int calculateAdvancedScore(Map<String, int> answers) {
    return (answers.values.reduce((a, b) => a + b));
  }

  @override
  Widget build(BuildContext context) {
    String currentLocale = Localizations.localeOf(context).languageCode;
    if (survey == null || lastLocale != currentLocale) {
      // if not there - then load one
      String locale = currentLocale;
      lastLocale = locale;
      FakeBackendSingleton().getSurvey(null, locale).then(showSurvey);
      try {
        widget.allPrimaryAnswers!.removeWhere((key, value) => value != 1);
      } catch (e) {
        print(e);
      }

      return Center(child: Text(AppLocalizations.of(context).loading));
    }
    if (widget.allPrimaryAnswers!.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).somethingWrong));
    } else {
      // filter questions that were scored in the primary survey
      List<Node> allNodes = survey!.nodes
          .where((element) =>
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 8);

      // ids of YesNoQuestions that don't have dependency
      List<String> singleQuestionIds = [
        '1',
        '2',
        '2_02',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
        '16',
        '17',
        '18',
        '18_01',
        '19',
        '20'
      ];
      // ids of radio button questions that don't have dependency
      List<String> radioButtonsIds = [
        '1_01',
        '2_01',
        '3_01',
        '4_01',
        '7_01',
        '9_01',
        '10_01',
        '14_01',
        '15_01',
        '17_01'
      ];

      return ValueListenableBuilder(
          valueListenable: allAdvancedAnswersDetail,
          builder: (context, value, child) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    Node questionNode = allNodes[index];
                    String currentId = questionNode.id;

                    if (singleQuestionIds.contains(currentId)) {
                      return AdvancedSingleQuestion(
                        questionNode: questionNode,
                        allAnswers: allAdvancedAnswersDetail,
                        mainIndex: index,
                      );
                    }
                    if (radioButtonsIds.contains(currentId)) {
                      return RadioButtonsWidget(
                          questionNode: questionNode,
                          allAdvancedAnswersDetail: allAdvancedAnswersDetail);
                    }
                    // rules
                    Map<String, bool> rules = {
                      '1_02': currentId == '1_02' &&
                          value['1_01']!.contains('PASS_YES') &&
                          value['1_01']!.contains('FAIL_YES'),
                      '2_03': currentId == '2_03' &&
                          value['2_02']!.contains('PASS'),
                      '5_01':
                          currentId == '5_01' && value['5']!.contains('FAIL'),
                      '5_02': currentId == '5_02' &&
                          value['5_01']!.contains('FAIL_YES'),
                      '6_01':
                          currentId == '6_01' && value['6']!.contains('FAIL'),
                      '6_02': currentId == '6_02' &&
                          value['6_01']!.contains('PASS_YES'),
                      '7_02': currentId == '7_02' &&
                          value['7_01']!.contains('PASS_YES'),
                      '7_03': currentId == '7_03' &&
                          value['7_02']!.contains('PASS'),
                      '8_01':
                          currentId == '8_01' && value['8']!.contains('PASS'),
                      '8_02': currentId == '8_02' &&
                          (value['8_01']!.contains('FAIL') ||
                              value['8']!.contains('FAIL')),
                      '8_03': currentId == '8_03' &&
                          value['8_02']!.contains('PASS'),
                      '8_04': currentId == '8_04' &&
                          value['8_03']!.contains('PASS_YES'),
                      '9_02': currentId == '9_02' &&
                          value['9_01']!.contains('PASS_YES'),
                      '10_02': currentId == '10_02' &&
                          value['10_01']!.contains('PASS_YES') &&
                          value['10_01']!.contains('FAIL_YES'),
                      '11_01':
                          currentId == '11_01' && value['11']!.contains('FAIL'),
                      '11_02': currentId == '11_02' &&
                          value['11_01']!.contains('PASS_YES') &&
                          value['11_01']!.contains('FAIL_YES'),
                      '12_01':
                          currentId == '12_01' && value['12']!.contains('FAIL'),
                      '12_02': currentId == '12_02' &&
                          getAnswersLength(value['12_01'], 'PASS_YES') >= 2,
                      '12_03': currentId == '12_03' &&
                          value['12_02']!.contains('PASS_YES') &&
                          value['12_02']!.contains('FAIL_YES'),
                      '13_01':
                          currentId == '13_01' && value['13']!.contains('PASS'),
                      '14_02': currentId == '14_02' &&
                          getAnswersLength(value['14_01'], 'PASS_YES') == 1,
                      '14_03': currentId == '14_03' &&
                          value['14_02']!.contains('PASS'),
                      '16_01':
                          currentId == '16_01' && value['16']!.contains('FAIL'),
                      '16_02': currentId == '16_02' &&
                          value['16_01']!.contains('PASS_YES') &&
                          value['16_01']!.contains('FAIL_YES'),
                      '18_02': currentId == '18_02' &&
                          value['18_01']!.contains('FAIL'),
                      '18_03': currentId == '18_03' &&
                          (value['18_02']!.contains('PASS') ||
                              value['18_01']!.contains('PASS')),
                      '19_01':
                          currentId == '19_01' && value['19']!.contains('FAIL'),
                      '19_02': currentId == '19_02' &&
                          value['19_01']!.contains('FAIL'),
                      '19_03': currentId == '19_03' &&
                          value['19_02']!.contains('FAIL'),
                      '20_01':
                          currentId == '20_01' && value['20']!.contains('PASS'),
                      '20_02': currentId == '20_02' &&
                          (value['20_01']!.contains('FAIL') ||
                              value['20']!.contains('FAIL')),
                    };

                    if (rules['1_02']! ||
                        rules['2_03']! ||
                        rules['10_02']! ||
                        rules['11_02']! ||
                        rules['12_03']! ||
                        rules['16_02']!) {
                      return SingleSelectsWidget(
                          questionNode: questionNode,
                          allAdvancedAnswersDetail: allAdvancedAnswersDetail);
                    }
                    if (rules['5_01']! ||
                        rules['6_01']! ||
                        rules['8_03']! ||
                        rules['11_01']! ||
                        rules['12_01']! ||
                        rules['12_02']! ||
                        rules['16_01']! ||
                        rules['18_03']! ||
                        rules['20_02']!) {
                      return RadioButtonsWidget(
                          questionNode: questionNode,
                          allAdvancedAnswersDetail: allAdvancedAnswersDetail);
                    }
                    if (rules['5_02']! ||
                        rules['6_02']! ||
                        rules['7_02']! ||
                        rules['7_03']! ||
                        rules['8_01']! ||
                        rules['8_02']! ||
                        rules['8_04']! ||
                        rules['9_02']! ||
                        rules['13_01']! ||
                        rules['14_02']! ||
                        rules['14_03']! ||
                        rules['18_02']! ||
                        rules['19_01']! ||
                        rules['19_02']! ||
                        rules['19_03']! ||
                        rules['20_01']!) {
                      return AdvancedSingleQuestion(
                        questionNode: questionNode,
                        allAnswers: allAdvancedAnswersDetail,
                        mainIndex: index,
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
                              Map<dynamic, dynamic> calculatedAnswers =
                                  calculateAll(allAdvancedAnswersDetail);

                              // used for writing results to db
                              calculateAll(allAdvancedAnswersDetail);
                              writeCurrentAdvancedRawAnswers(
                                  allAdvancedAnswersDetail.value);
                              writeCurrentAdvancedAnswers(calculatedAnswers);
                              saveCurrentAdvancedScore(calculateAdvancedScore(
                                  calculatedAnswers.cast<String, int>()));

                              // used for pdf
                              addAllAdvancedRawAnswersMap(
                                  allAdvancedAnswersDetail.value);
                              addCalculatedAdvancedAnswers(calculatedAnswers);
                              addAdvancedSurveyQuestions(
                                  getQuestionsList(allNodes));
                              addFinalAdvancedScore(
                                  calculatedAnswers.cast<String, int>());

                              Navigator.pushNamed(context, '/advancedResult');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 11),
                              child: Text(
                                AppLocalizations.of(context).submitAnswers,
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
          });
    }
  }

  Map<dynamic, dynamic> calculateAll(
      ValueNotifier<Map<String, List<String>>> allAdvancedAnswers) {
    Map<String, List<String>> answers = allAdvancedAnswers.value;
    Map<String, int> resultsMap = {};
    // 1
    if (answers.keys.contains("1")) {
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
    }

    // 2
    if (answers.keys.contains("2")) {
      resultsMap["2"] = answers["2"]!.contains("PASS_YES") ? 0 : 1;
    }

    // 3
    if (answers.keys.contains("3")) {
      resultsMap["3"] = answers["3_01"]!.contains("PASS_YES") ? 0 : 1;
    }
    //4
    if (answers.keys.contains("4")) {
      resultsMap["4"] = answers["4_01"]!.contains("PASS_YES") ? 1 : 0;
    }

    //
    if (answers.keys.contains("5")) {
      if (!answers["5_01"]!.contains("FAIL_YES")) {
        resultsMap["5"] = 1;
      } else {
        resultsMap["5"] = answers["5_02"]!.contains("PASS_YES") ? 0 : 1;
      }
    }

    //6
    if (answers.keys.contains("6")) {
      if (!answers["6_01"]!.contains("PASS_YES")) {
        resultsMap["6"] = 0;
      } else {
        resultsMap["6"] = answers["6_02"]!.contains("PASS_YES") ? 1 : 0;
      }
    }

    //7
    if (answers.keys.contains("7")) {
      if (!answers["7_01"]!.contains("PASS_YES")) {
        resultsMap["7"] = 0;
      } else if (!answers["7_02"]!.contains("PASS_YES")) {
        resultsMap["7"] = 0;
      } else {
        resultsMap["7"] = answers["7_03"]!.contains("PASS_YES") ? 1 : 0;
      }
    }

    //8
    if (answers.keys.contains("8")) {
      if (answers["8_01"]!.contains("PASS_YES")) {
        resultsMap["8"] = 1;
      } else if (!answers["8_02"]!.contains("PASS_YES")) {
        resultsMap["8"] = 0;
      } else if (!answers["8_03"]!.contains("PASS_YES")) {
        resultsMap["8"] = 0;
      } else {
        resultsMap["8"] = answers["8_04"]!.contains("PASS_YES") ? 1 : 0;
      }
    }

    //9
    if (answers.keys.contains("9")) {
      if (!answers["9_01"]!.contains("PASS_YES")) {
        resultsMap["9"] = 0;
      } else {
        resultsMap["9"] = answers["9_02"]!.contains("PASS_YES") ? 1 : 0;
      }
    }

    //10
    if (answers.keys.contains("10")) {
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
    }

    //11
    if (answers.keys.contains("11")) {
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
    }

    //12
    if (answers.keys.contains("12")) {
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
    }
    //13
    if (answers.keys.contains("13")) {
      resultsMap["13"] = answers["13_01"]!.contains("PASS_YES") ? 1 : 0;
    }

    //14
    if (answers.keys.contains("14")) {
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
    }

    //15
    if (answers.keys.contains("15")) {
      int numberOfYes15 =
          answers["15_01"]!.where((element) => element == "PASS_YES").length;
      resultsMap["15"] = numberOfYes15 >= 2 ? 1 : 0;
    }

    //16
    if (answers.keys.contains("16")) {
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
    }

    //17
    if (answers.keys.contains("17")) {
      resultsMap["17"] = answers["17_01"]!.contains("PASS_YES") ? 1 : 0;
    }

    //18
    if (answers.keys.contains("18")) {
      if (!answers["18_01"]!.contains("PASS_YES") &&
          !answers["18_02"]!.contains("PASS_YES")) {
        resultsMap["18"] = 0;
      } else {
        resultsMap["18"] = answers["18_03"]!.contains("PASS_YES") ? 1 : 0;
      }
    }

    //19
    if (answers.keys.contains("19")) {
      if (answers["19_01"]!.contains("PASS_YES")) {
        resultsMap["19"] = 1;
      } else if (answers["19_02"]!.contains("PASS_YES")) {
        resultsMap["19"] = 1;
      } else {
        resultsMap["19"] = answers["19_03"]!.contains("PASS_YES") ? 1 : 0;
      }
    }

    //20
    if (answers.keys.contains("20")) {
      if (answers["20_01"]!.contains("PASS_YES")) {
        resultsMap["20"] = 1;
      } else {
        resultsMap["20"] = answers["20_02"]!.contains("PASS_YES") ? 1 : 0;
      }
    }

    print("RESULTS");
    print(resultsMap);
    return resultsMap;
  }
}

class RadioButtonsWidget extends StatelessWidget {
  const RadioButtonsWidget({
    super.key,
    required this.questionNode,
    required this.allAdvancedAnswersDetail,
  });

  final Node questionNode;
  final ValueNotifier<Map<String, List<String>>> allAdvancedAnswersDetail;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black45, width: 0.75),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Text(
                  '${AppLocalizations.of(context).question}  ${questionNode.id.replaceAll('_0', '.')}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              Text(
                questionNode.questions[0].toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        subtitle: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.2,
              maxHeight: MediaQuery.of(context).size.height * 0.9),
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              shrinkWrap: true,
              itemCount: questionNode.questions.length - 1,
              itemBuilder: ((context, inputIndex) {
                return RadioButtons(
                    allAdvancedAnswersDetails: allAdvancedAnswersDetail,
                    question: questionNode,
                    inputIndex: inputIndex);
              })),
        ),
      ),
    );
  }
}

class SingleSelectsWidget extends StatefulWidget {
  const SingleSelectsWidget({
    super.key,
    required this.questionNode,
    required this.allAdvancedAnswersDetail,
  });

  final Node questionNode;
  final ValueNotifier<Map<String, List<String>>> allAdvancedAnswersDetail;

  @override
  State<SingleSelectsWidget> createState() => _SingleSelectsWidgetState();
}

class _SingleSelectsWidgetState extends State<SingleSelectsWidget>
    with AutomaticKeepAliveClientMixin {
  List<bool> _selectedAnswers = [];

  List<Widget> listQuestions(List<Question> questions) {
    List<Widget> textWidgets = [];
    for (var question in questions.skip(1)) {
      textWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 350,
                child: Text(
                  question.toString(),
                  maxLines: 5,
                  style: TextStyle(fontSize: 16),
                )),
          ),
        ],
      ));
    }

    return textWidgets;
  }

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<bool>.generate(
        widget.questionNode.questions.length - 1, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black45, width: 0.75),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Text(
                    '${AppLocalizations.of(context).question} ${widget.questionNode.id.replaceAll('_0', '.')}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Text(
                  widget.questionNode.questions[0].toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )),
        subtitle: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, bottom: 15.0, left: 5.0, right: 5.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.2,
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            child: ToggleButtons(
              isSelected: _selectedAnswers,
              borderRadius: BorderRadius.circular(10),
              direction: Axis.vertical,
              onPressed: (int index) {
                List<String> questionWordsList = widget.questionNode.questions
                    .skip(1)
                    .toList()[index]
                    .toString()
                    .split(' ');
                bool isFail = questionWordsList.length > 1 &&
                    questionWordsList[0] == '[F]';
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedAnswers.length; i++) {
                    _selectedAnswers[i] = i == index;
                    print(_selectedAnswers);
                    widget.allAdvancedAnswersDetail
                            .value[widget.questionNode.id]![i] =
                        _selectedAnswers[i]
                            ? (isFail ? 'FAIL_YES' : 'PASS_YES')
                            : '-1';
                  }
                  print(widget.allAdvancedAnswersDetail.value);
                });
              },
              children: listQuestions(widget.questionNode.questions),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
