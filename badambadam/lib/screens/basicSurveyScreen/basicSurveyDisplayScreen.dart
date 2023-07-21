import 'package:flutter/material.dart';
import '../../model.dart';
import 'singleQuestionWidget.dart';
import '../../storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SurveyWidget extends StatefulWidget {
  SurveyWidget({
    super.key,
  });

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  Survey? survey;
  String lastLocale = '';

  void showSurvey(Survey s) {
    setState(() {
      survey = s;
    });
  }

  int calculateScore(Map<String, int> answers) {
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
      return Center(child: Text(AppLocalizations.of(context).loading));
    } else {
      List<Node> topLevelSurvey = survey!.getTopLevelNodesOnly();
      List<String> topLevelQuestions = [];

      // used for storing answers. Initialized with -1 for no answer.
      final ValueNotifier<Map<String, int>> allAnswers =
          ValueNotifier<Map<String, int>>(
              {for (var item in topLevelSurvey) item.id: -1});

      final ButtonStyle style = ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 8);

      Future<void> showMyDialog() async {
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).hasToAnswer1),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(AppLocalizations.of(context).hasToAnswer2),
                    Text(
                      AppLocalizations.of(context).hasToAnswer3,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    AppLocalizations.of(context).close,
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              topLevelQuestions.add(
                  '${topLevelSurvey[index].id}. ${topLevelSurvey[index].questions[0]}+${topLevelSurvey[index].isInverted}');
              return SingleSurveyQuestion(
                questionNode: topLevelSurvey[index],
                allAnswers: allAnswers,
              );
            }, childCount: topLevelSurvey.length)),
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
                        if (allAnswers.value.values.contains(-1)) {
                          showMyDialog();
                        } else {
                          String guid =
                              "${DateTime.now().toString().trim()}-${generateSixDigitString()}";
                          updateGuidList(guid);
                          addAllTopLevelNodes(topLevelQuestions);
                          addAllAnswersMap(allAnswers.value);
                          writeCurrentAnswers();
                          addFinalScore();
                          saveMetric(guid);
                          saveScore(guid, calculateScore(allAnswers.value));
                          Navigator.pushNamed(context, '/result');
                        }
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
    }
  }
}
