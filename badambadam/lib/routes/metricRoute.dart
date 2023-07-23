import 'package:badambadam/screens/metricScreen/selectMetricQuestionWidget.dart';
import 'package:badambadam/storage.dart';
import 'package:badambadam/screens/metricScreen/binaryMetricQuestionWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            title:  Text(AppLocalizations.of(context).answerEveryQuestion),
            actions: <Widget>[
              TextButton(
                child:  Text(
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

    Future<void> _showMyDialog2() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(
                AppLocalizations.of(context).changesWontBeSaved),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context).no,
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  cleanMetricData();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context).yes,
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
            PostalCodeInput(
              questionId: "1",
              questionText: AppLocalizations.of(context).providePostalCode,
            ),
            SelectMetricQuestion(
                questionId: "2",
                questionText: AppLocalizations.of(context).childGender,
                valueList: <String>[AppLocalizations.of(context).male, AppLocalizations.of(context).female],
                hintText: AppLocalizations.of(context).chooseGender,
                localParamName: "gender"),
            SelectMetricQuestion(
                questionId: "3",
                questionText: AppLocalizations.of(context).whoIsFillingTheSurvey,
                valueList: <String>[
                  AppLocalizations.of(context).father,
                  AppLocalizations.of(context).mother,
                  AppLocalizations.of(context).grandpa,
                  AppLocalizations.of(context).grandma,
                  AppLocalizations.of(context).otherFromFamily,
                  AppLocalizations.of(context).legalGuardian,
                  AppLocalizations.of(context).someoneElse
                ],
                hintText: AppLocalizations.of(context).choosePerson,
                localParamName: "familyInformation"),
            SelectMetricQuestion(
                questionId: "4",
                questionText: AppLocalizations.of(context).whichPregnancyWeek,
                localParamName: "pregnancyWeek",
                hintText: AppLocalizations.of(context).chooseWeek,
                valueList: List.generate(27, (i) => (i + 16).toString())),
            WeightInput(
              questionId: "5",
              questionText: AppLocalizations.of(context).birthWeight,
            ),
            BinaryMetricQuestion(
                questionId: "6",
                questionText: AppLocalizations.of(context).geneticDiseases,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "geneticDiseases"),
            BinaryMetricQuestion(
                questionId: "7",
                questionText: AppLocalizations.of(context).healthIssues,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "healthIssues"),
            BinaryMetricQuestion(
                questionId: "8",
                questionText: AppLocalizations.of(context).visionIssues,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "visionIssues"),
            BinaryMetricQuestion(
                questionId: "9",
                questionText: AppLocalizations.of(context).hearingIssues,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "hearingIssues"),
            BinaryMetricQuestion(
                questionId: "10",
                questionText: AppLocalizations.of(context).mobilityIssues,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "mobilityIssues"),
            BinaryMetricQuestion(
                questionId: "11",
                questionText: AppLocalizations.of(context).mobilityRehab,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "mobilityRehab"),
            BinaryMetricQuestion(
                questionId: "12",
                questionText: AppLocalizations.of(context).skillsIssues,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "skillsIssues"),
            BinaryMetricQuestion(
                questionId: "13",
                questionText: AppLocalizations.of(context).autismSigns,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
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
                    if (getMetricDataString("autismSigns") == AppLocalizations.of(context).yes) {
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
                    AppLocalizations.of(context).continueForward,
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
                  child: Text('${AppLocalizations.of(context).question} ${widget.questionId}',
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
                  prefixIcon: Icon(Icons.home),
                  hintText: AppLocalizations.of(context).zipCodePlaceholder,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                inputFormatters: [PostalCodeFormatter()],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? text) {
                  String pattern = r'^\d\d-\d\d\d$';
                  String errorMessage = AppLocalizations.of(context).zipCodeFormat;
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
                  child: Text('${AppLocalizations.of(context).question} ${widget.questionId}',
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
                  hintText: AppLocalizations.of(context).weightAtBirth,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? text) {
                   String errorMessage =
                      AppLocalizations.of(context).weightMustBeCorrect;
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
