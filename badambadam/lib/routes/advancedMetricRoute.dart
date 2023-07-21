import 'package:badambadam/storage.dart';
import 'package:badambadam/screens/metricScreen/binaryMetricQuestionWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            title: Text(AppLocalizations.of(context).answerEveryQuestion),
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

    Future<void> _showMyDialog2() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
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

    Future<void> _showMyDialog3() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
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
                questionText: AppLocalizations.of(context).familyMemberAutismInformation,
                localParamName: "familyMemberAutismInformation"),
            BinaryMetricQuestion(
                questionId: "2",
                questionText: AppLocalizations.of(context).familyAutismSigns,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "familyAutismSigns"),
            BinaryMetricQuestion(
                questionId: "3",
                questionText: AppLocalizations.of(context).familyAtypicalAutismSigns,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "familyAtypicalAutismSigns"),
            BinaryMetricQuestion(
                questionId: "4",
                questionText: AppLocalizations.of(context).familyAspergerAutismSigns,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "familyAspergerAutismSigns"),
            BinaryMetricQuestion(
                questionId: "5",
                questionText: AppLocalizations.of(context).familyDevelopmentIssues,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
                localParamName: "familyDevelopmentIssues"),
            BinaryMetricQuestion(
                questionId: "6",
                questionText: AppLocalizations.of(context).familyOtherAutismSigns,
                firstOption: AppLocalizations.of(context).yes,
                secondOption: AppLocalizations.of(context).no,
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
                    AppLocalizations.of(context).proceedToSurvey,
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


  familyMembers = <String>[
    AppLocalizations.of(context).mother,
    AppLocalizations.of(context).sisterOne,
    AppLocalizations.of(context).father,
    AppLocalizations.of(context).sisterTwo,
    AppLocalizations.of(context).sisterThree,
    AppLocalizations.of(context).brotherOne,
    AppLocalizations.of(context).brotherTwo,
    AppLocalizations.of(context).brotherThree,
    AppLocalizations.of(context).grandpa,
    AppLocalizations.of(context).grandma,
    AppLocalizations.of(context).otherFromFamily,
    AppLocalizations.of(context).legalGuardian,
    AppLocalizations.of(context).someoneElse
  ];

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
                          '${AppLocalizations.of(context).question} ${widget.questionId}',
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

                          if (familyMembers[index] == AppLocalizations.of(context).someoneElse) {
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
                          hintText: AppLocalizations.of(context).whoIsTheOtherPerson),
                      onChanged: (text) {
                        _selectedFamilyMembers[_selectedFamilyMembers.length -
                            1] = '${AppLocalizations.of(context).someoneElse}+${myController.text}';
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
