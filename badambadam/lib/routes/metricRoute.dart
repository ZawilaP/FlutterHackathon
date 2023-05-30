import 'package:badambadam/screens/metricScreen/quantityInputMetricQuestionWidget.dart';
import 'package:badambadam/screens/metricScreen/selectMetricQuestionWidget.dart';
import 'package:badambadam/storage.dart';
import 'package:badambadam/screens/metricScreen/binaryMetricQuestionWidget.dart';
import 'package:flutter/material.dart';
import '../screens/basicSurveyScreen/basicSurveyDisplayScreen.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MetricRoute extends StatelessWidget {
  MetricRoute({super.key});
  var pregancyWeeksList = List.generate(27, (i) => (42 - i));

  @override
  Widget build(BuildContext context) {
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
            title: const Text('Proszę odpowiedzieć na każde pytanie!'),
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

    Future<void> _showMyDialog2() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Zmiany nie zostaną zapisane, czy chcesz kontynuować?'),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Nie',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  cleanMetricData();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Tak',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  cleanMetricData();
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => _showMyDialog2(),
        ),
        title: InkWell(
          onTap: () => _showMyDialog2(),
          child: Image.asset(
            'graphics/SYNAPSIS_herb_2.png',
            fit: BoxFit.cover,
            scale: 2,
          ),
        ),
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          children: <Widget>[
            PostalCodeInput(questionId: "1", questionText: "Proszę podać kod pocztowy",),
            SelectMetricQuestion(
                questionId: "2",
                questionText: "Jaka jest płeć dziecka?",
                valueList: <String>['Męska', 'Żeńska'],
                hintText: "Wybierz płeć dziecka",
                localParamName: "gender"),
            SelectMetricQuestion(
                questionId: "3",
                questionText: "Kim jest wypełniający badanie?",
                valueList: <String>[
                  'Ojciec',
                  'Matka',
                  'Dziadek',
                  'Babcia',
                  'Inna osoba z rodziny',
                  'Opiekun prawny',
                  'Inna osoba'
                ],
                hintText: "Wybierz osobę",
                localParamName: "familyInformation"),
            SelectMetricQuestion(
                questionId: "4",
                questionText: "Dziecko urodzone w tygodniu ciąży",
                localParamName: "pregnancyWeek",
                hintText: 'Wybierz tydzień',
                valueList: List.generate(27, (i) => (i + 16).toString())),
            WeightInput(
              questionId: "5",
              questionText: "Proszę podać wagę urodzeniową dziecka (w gramach)",
            ),
            BinaryMetricQuestion(
                questionId: "6",
                questionText: "Czy dziecko ma choroby genetyczne?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "geneticDiseases"),
            BinaryMetricQuestion(
                questionId: "7",
                questionText: "Czy dziecko ma poważne problemy zdrowotne?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "healthIssues"),
            BinaryMetricQuestion(
                questionId: "8",
                questionText: "Czy dziecko ma poważne problemy ze wzrokiem?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "visionIssues"),
            BinaryMetricQuestion(
                questionId: "9",
                questionText: "Czy dziecko ma poważne problemy ze słuchem?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "hearingIssues"),
            BinaryMetricQuestion(
                questionId: "10",
                questionText: "Czy dziecko ma problemy w rozwoju ruchowym?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "mobilityIssues"),
            BinaryMetricQuestion(
                questionId: "11",
                questionText: "Czy dziecko jest/było rehabilitowane ruchowo?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "mobilityRehab"),
            BinaryMetricQuestion(
                questionId: "12",
                questionText:
                    "Czy kiedykolwiek dziecko wycofało się ze zdobytych umiejętności na okres dłuższy niż 2 tygodnie?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "skillsIssues"),
            BinaryMetricQuestion(
                questionId: "13",
                questionText:
                    "Czy ktoś w rodzinie ma zdiagnozowane zaburzenie ze spektrum autyzmu?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "autismSigns"),
            ElevatedButton(
                style: style,
                onPressed: () {
                  if (getMetricDataString("autismSigns") == "" ||
                      getMetricDataString("skillsIssues") == "" ||
                      getMetricDataString("mobilityRehab") == "" ||
                      getMetricDataString("mobilityIssues") == "" ||
                      getMetricDataString("hearingIssues") == "" ||
                      getMetricDataString("visionIssues") == "" ||
                      getMetricDataString("healthIssues") == "" ||
                      getMetricDataString("geneticDiseases") == "" ||
                      getMetricDataString("gender") == "" ||
                      getMetricDataString("weight") == "" ||
                      getMetricDataString("familyInformation") == "" ||
                      getMetricDataString("pregnancyWeek") == "" ||
                      getPostalCode() == "") {
                    _showMyDialog();
                  } else {
                    if (getMetricDataString("autismSigns") == "TAK") {
                      Navigator.pushNamed(context, '/advancedMetric');
                    } else {
                      Navigator.pushNamed(context, '/survey');
                    }
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11),
                  child: Text(
                    'Przejdź dalej',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                )),
          ]),
    );
  }
}

class PostalCodeInput extends StatefulWidget {
  PostalCodeInput(
      {super.key, required this.questionId, required this.questionText});

  String questionId;
  String questionText;

  @override
  State<PostalCodeInput> createState() => _PostalCodeInputState();
}

class _PostalCodeInputState extends State<PostalCodeInput>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Theme.of(context).colorScheme.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade500, width: 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            ListTile(
                title: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text('Pytanie ${widget.questionId}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                subtitle: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text(widget.questionText),
                )
                ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.home),
                  hintText: AppLocalizations.of(context).zipCodePlaceholder,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                inputFormatters: [PostalCodeFormatter()],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? text) {
                  String pattern = r'^\d\d-\d\d\d$';
                  const String errorMessage = "Podaj kod pocztowy (np. 01-234)";
                  RegExp regExp = RegExp(pattern);
                  if (text == null) {
                    return errorMessage;
                  }
                  if (text.isEmpty) {
                    return errorMessage;
                  } else if (!regExp.hasMatch(text)) {
                    return errorMessage;
                  }
                  return null;
                },
                onChanged: (text) => setPostalCode(text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class WeightInput extends StatefulWidget {
  const WeightInput(
      {super.key, required this.questionId, required this.questionText});

  final String questionId;
  final String questionText;

  @override
  State<WeightInput> createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Theme.of(context).colorScheme.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade500, width: 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            ListTile(
                title: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text('Pytanie ${widget.questionId}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                subtitle: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text(widget.questionText),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Waga urodzeniowa dziecka",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? text) {
                  const String errorMessage =
                      "Waga nie może być ujemna i przekraczać 10kg";
                  if (text == null) {
                    return errorMessage;
                  }
                  if (text.isEmpty) {
                    return errorMessage;
                  } else if (int.tryParse(text) != null &&
                      (int.parse(text) < 0 || int.parse(text) > 9999)) {
                    return errorMessage;
                  }
                  return null;
                },
                onChanged: (text) => setMetricDataString("weight", text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PostalCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 6) {
      return oldValue;
    }
    if (newValue.text.length == 2 && oldValue.text.length != 3) {
      return TextEditingValue(
          text: '${newValue.text}-',
          selection: TextSelection.collapsed(offset: newValue.text.length + 1));
    }
    return newValue;
  }
}
