import 'package:badambadam/screens/advancedSurveyScreen/advancedSingleQuestionWidget.dart';
import 'package:flutter/material.dart';
import '../../model.dart';
import '../advancedSurveyScreen/advancedSingleQuestionWidget.dart';
import '../../storage.dart';
import 'radioResponseWidget.dart';

class AdvancedSurveyDisplayScreen extends StatefulWidget {
  AdvancedSurveyDisplayScreen({
    super.key,
  });

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
      return Center(child: Text('Loading...'));
    } else {
      List<Node> allNodes = survey!.nodes;
      List<Node> topLevelSurvey = survey!.getTopLevelNodesOnly();

      // used for storing answers. Initialized with -1 for no answer.
      final ValueNotifier<List<int>> allAdvancedAnswers =
          ValueNotifier<List<int>>(
              List<int>.generate(allNodes.length, (i) => 0));

      final ValueNotifier<Map<String, List<String>>> allAdvancedAnswersDetail =
          ValueNotifier<Map<String, List<String>>>({
        for (var item in allNodes)
          item.id: List<String>.generate(item.questions.length, (index) => '-1')
      });


      print(allAdvancedAnswersDetail);

      final ButtonStyle style = ElevatedButton.styleFrom(
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
              title: const Text('Please check yes or no for every question'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Keep in mind how your child usually behaves.'),
                    Text(
                      'If you have seen your child do the behavior a few times, but he or she does not usually do it, then please answer no.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Close',
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Node questionNode = allNodes[index];
              if (allNodes[index].nodeType == 'Simple_Yes_No') {
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
                            '${questionNode.id} ${questionNode.questions[0]}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height * 0.2,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.7),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: questionNode.questions.length - 1,
                                  itemBuilder: ((context, inputIndex) {
                                    return RadioButtons(
                                        question: questionNode.questions
                                            .sublist(
                                                1,
                                                questionNode.questions
                                                    .length)[inputIndex]
                                            .toString(), inputIndex: inputIndex);
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
                                '${questionNode.id} ${questionNode.questions[0].toString()}'),
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
                        if (allAdvancedAnswers.value.contains(-1)) {
                          _showMyDialog();
                        } else {
                          updateGuidList(
                              "${DateTime.now().toString().trim()}_test");
                          addAllAnswersList(allAdvancedAnswers.value);
                          addFinalScore();
                          calculateAll(allAdvancedAnswers);
                          Navigator.pushNamed(context, '/advancedResult');
                        }
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
  
  void calculateAll(ValueNotifier<List<int>> allAdvancedAnswers) {
    print(allAdvancedAnswers);
  }
}

class AdvancedTextField extends StatefulWidget {
  const AdvancedTextField(
      {Key? key, required this.allAdvancedAnswersDetails, required this.nodeId})
      : super(key: key);

  final ValueNotifier<Map<String, List<String>>> allAdvancedAnswersDetails;
  final String nodeId;

  @override
  State<AdvancedTextField> createState() => _AdvancedTextFieldState();
}

class _AdvancedTextFieldState extends State<AdvancedTextField> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'If you want to add something, do it here'),
      onChanged: (text) {
        widget.allAdvancedAnswersDetails.value[widget.nodeId] =
            ["open_" + myController.text].toList();
        print(widget.allAdvancedAnswersDetails.toString());
      },
    );
  }
}
