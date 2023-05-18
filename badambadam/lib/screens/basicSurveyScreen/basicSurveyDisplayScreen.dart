import 'package:flutter/material.dart';
import '../../model.dart';
import 'singleQuestionWidget.dart';
import '../../storage.dart';

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

  @override
  Widget build(BuildContext context) {
    String currentLocale = Localizations.localeOf(context).languageCode;
    if (survey == null || lastLocale != currentLocale) {
      // if not there - then load one
      String locale = currentLocale;
      lastLocale = locale;
      FakeBackendSingleton().getSurvey(null, locale).then(showSurvey);
      return Center(child: Text('Ładowanie...'));
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

      Future<void> _showMyDialog() async {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                  'Proszę odpowiedzieć TAK lub NIE na każde pytanie.'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text(
                        'Proszę pomyśleć o tym, w jaki sposób dziecko zachowuje się na codzień.'),
                    Text(
                      'Jeśli widział/a Pan/Pani zachowanie kilka razy, ale dziecko zwykle się tak nie zachowuje, proszę zaznaczyć NIE.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Zamknij',
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
                          _showMyDialog();
                        } else {
                          updateGuidList(DateTime.now().toString().trim() +
                              "-" +
                              generateSixDigitString());
                          addAllTopLevelNodes(topLevelQuestions);
                          addAllAnswersMap(allAnswers.value);
                          writeCurrentAnswers();
                          addFinalScore();
                          Navigator.pushNamed(context, '/result');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 11),
                        child: Text(
                          'Zatwierdź odpowiedzi',
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
