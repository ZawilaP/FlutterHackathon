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

import '../screens/metricScreen/selectMetricQuestionWidget.dart';

class AdvancedMetricRoute extends StatelessWidget {
  const AdvancedMetricRoute({super.key});

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

    Future<void> _showMyDialog3() async {
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
                  Navigator.pushNamed(context, '/metric');
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
          onPressed: () => _showMyDialog3(),
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
            SelectMetricQuestion(
                questionId: "1",
                questionText: "Kto ma zdiagnozowane spektrum autyzmu?",
                valueList: <String>[
                  'Ojciec',
                  'Matka',
                  'Siostra (pierwsza)',
                  'Siostra (druga)',
                  'Siostra (trzecia)',
                  'Brat (pierwszy)',
                  'Brat (drugi)',
                  'Brat (trzeci)',
                  'Dziadek',
                  'Babcia',
                  'Inna osoba z rodziny',
                  'Opiekun prawny',
                  'Inna osoba'
                ],
                hintText: "Wybierz osobę",
                localParamName: "familyMemberAutismInformation"),
            BinaryMetricQuestion(
                questionId: "2",
                questionText:
                    "Czy wskazana osoba/wskazane osoby ma/mają zdiagnozowany autyzm?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "familyAutismSigns"),
            BinaryMetricQuestion(
                questionId: "3",
                questionText:
                    "Czy wskazana osoba/wskazane osoby ma/mają zdiagnozowany autyzm atypowy?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "familyAtypicalAutismSigns"),
            BinaryMetricQuestion(
                questionId: "4",
                questionText:
                    "Czy wskazana osoba/wskazane osoby ma/mają zdiagnozowany Zespół Aspergera?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "familyAspergerAutismSigns"),
            BinaryMetricQuestion(
                questionId: "5",
                questionText:
                    "Czy wskazana osoba/wskazane osoby ma/mają zdiagnozowany całościowe zaburzenia rozwojowe?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "familyDevelopmentIssues"),
            BinaryMetricQuestion(
                questionId: "6",
                questionText:
                    "Czy wskazana osoba/wskazane osoby ma/mają zdiagnozowane inne zaburzenia ze spektrum autyzmu?",
                firstOption: "TAK",
                secondOption: "NIE",
                localParamName: "familyOtherAutismSigns"),
            ElevatedButton(
                style: style,
                onPressed: () {
                  if (getMetricDataString("familyAutismSigns") == "" ||
                      getMetricDataString("familyAtypicalAutismSigns") == "" ||
                      getMetricDataString("familyAspergerAutismSigns") == "" ||
                      getMetricDataString("familyDevelopmentIssues") == "" ||
                      getMetricDataString("familyOtherAutismSigns") == "") {
                    _showMyDialog();
                  } else {
                    Navigator.pushNamed(context, '/survey');
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11),
                  child: Text(
                    'Przejdź do badania',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                )),
          ]),
    );
  }
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
          text: newValue.text + '-',
          selection: TextSelection.collapsed(offset: newValue.text.length + 1));
    }
    return newValue;
  }
}
