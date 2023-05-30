import 'package:badambadam/storage.dart';
import 'package:badambadam/screens/metricScreen/binaryMetricQuestionWidget.dart';
import 'package:flutter/material.dart';

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
            MultiSelectMetricQuestion(
                questionId: "1",
                questionText: "Kto ma zdiagnozowane spektrum autyzmu?",
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

class MultiSelectMetricQuestion extends StatefulWidget {
  MultiSelectMetricQuestion(
      {super.key,
      required this.questionId,
      required this.questionText,
      required this.localParamName});

  final String questionId;
  final String questionText;
  final String localParamName;

  @override
  State<MultiSelectMetricQuestion> createState() =>
      _MultiSelectMetricQuestionState();
}

class _MultiSelectMetricQuestionState extends State<MultiSelectMetricQuestion>
    with AutomaticKeepAliveClientMixin {
  List<bool> _selectedAnswers = [];
  List<String> _selectedFamilyMembers = [];
  List<String> familyMembers = <String>[
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
  ];
  bool _otherFlag = false;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  List<Widget> familyMembersTextWidget(List<String> familyMembers) {
    List<Widget> textWidgets = [];
    for (var question in familyMembers) {
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
    _selectedAnswers =
        List<bool>.generate(familyMembers.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Card(
        color: Theme.of(context).colorScheme.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black45, width: 0.75),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            ListTile(
              title: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 8),
                        child: Text(
                          'Pytanie ${widget.questionId}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      Text(
                        widget.questionText,
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
                      maxHeight: MediaQuery.of(context).size.height),
                  child: SingleChildScrollView(
                    child: ToggleButtons(
                      isSelected: _selectedAnswers,
                      borderRadius: BorderRadius.circular(10),
                      direction: Axis.vertical,
                      onPressed: (int index) {
                        setState(() {
                          _selectedAnswers[index] = !_selectedAnswers[index];

                          if (_selectedAnswers[index]) {
                            _selectedFamilyMembers.add(familyMembers[index]);
                          } else if (!_selectedAnswers[index] &&
                              _selectedFamilyMembers
                                  .contains(familyMembers[index])) {
                            _selectedFamilyMembers.remove(familyMembers[index]);
                          }

                          print(_selectedFamilyMembers);

                          if (familyMembers[index] == 'Inna osoba') {
                            _otherFlag = true;
                          } else {
                            _otherFlag = false;
                          }

                          setMetricDataString(widget.localParamName,
                              _selectedFamilyMembers.toString());
                        });
                      },
                      children: familyMembersTextWidget(familyMembers),
                    ),
                  ),
                ),
              ),
            ),
            _otherFlag
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Kim jest inna osoba?"),
                      onChanged: (text) {
                        _selectedFamilyMembers[_selectedFamilyMembers.length -
                            1] = 'Inna_osoba+${myController.text}';
                        setMetricDataString(widget.localParamName,
                            _selectedFamilyMembers.toString());
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
