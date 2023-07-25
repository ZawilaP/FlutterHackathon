import 'package:badambadam/screens/resultScreen/basicPdfReport.dart';
import 'package:badambadam/screens/resultScreen/basicPdfReportEnglish.dart';
import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:linkify/linkify.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultDisplayScreen extends StatefulWidget {
  const ResultDisplayScreen({this.score, this.allAnswers});

  final int? score;
  final Map<String, int>? allAnswers;

  @override
  State<ResultDisplayScreen> createState() => _ResultDisplayScreenState();
}

class _ResultDisplayScreenState extends State<ResultDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    String intro = " ";
    String paragraph = " ";
    List<String> actions = [];

    String currentLocale = Localizations.localeOf(context).languageCode;

    // setting texts based on child's score
    setState(() {
      if (widget.score! <= 2) {
        intro = AppLocalizations.of(context).noRiskIntro;
        paragraph = AppLocalizations.of(context).noRiskParagraph;
        actions = [
          AppLocalizations.of(context).noRiskAction1,
          AppLocalizations.of(context).noRiskAction2,
          AppLocalizations.of(context).noRiskAction3,
          AppLocalizations.of(context).noRiskAction4
        ];
      } else if (widget.score! >= 3 && widget.score! <= 7) {
        intro = AppLocalizations.of(context).smallRiskIntro;
        paragraph = AppLocalizations.of(context).smallRiskParagraph;
        actions = [
          AppLocalizations.of(context).smallRiskAction1,
          AppLocalizations.of(context).smallRiskAction2,
          AppLocalizations.of(context).smallRiskAction3,
          AppLocalizations.of(context).smallRiskAction4,
          AppLocalizations.of(context).smallRiskAction5,
        ];
      } else {
        intro = AppLocalizations.of(context).bigRiskIntro;
        paragraph = AppLocalizations.of(context).bigRiskParagraph;
        actions = [
          AppLocalizations.of(context).bigRiskAction1,
          AppLocalizations.of(context).bigRiskAction2,
          AppLocalizations.of(context).bigRiskAction3,
          AppLocalizations.of(context).bigRiskAction4,
          AppLocalizations.of(context).bigRiskAction5,
          AppLocalizations.of(context).bigRiskAction6,
        ];
      }
    });

    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 1);

    var currentGuid = getCurrentGuid()
        .toString()
        .replaceAll(".", "-")
        .replaceAll(" ", "-")
        .replaceAll(":", "-")
        .replaceAll("_", "-")
        .toString()
        .split('-');

    var currentGuidUserNumber = currentGuid[currentGuid.length - 1];

    return widget.allAnswers!.values.isNotEmpty
        ? ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              ScoreDisplayContainer(
                score: widget.score,
                allAnswers: widget.allAnswers!.values.toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: AppLocalizations.of(context).surveyId,
                      style: DefaultTextStyle.of(context).style),
                  TextSpan(
                      text:
                          "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString()} : ",
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: currentGuidUserNumber,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontWeight: FontWeight.bold))
                ])),
              ),
              currentLocale == 'pl'
                  ? PDFSave(
                      score: widget.score,
                      allAnswers: widget.allAnswers!.values.toList(),
                    )
                  : EnglishPDFSave(
                      score: widget.score,
                      allAnswers: widget.allAnswers!.values.toList(),
                    ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:
                    Text(intro, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(paragraph),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(actions[0]),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    children: actions.sublist(1, actions.length).map((e) {
                  return ListTile(
                    leading: Icon(Icons.check),
                    title: Linkify(
                      text: e,
                      onOpen: (link) async {
                        if (!await launchUrl(Uri.parse(link.url))) {
                          throw Exception('Could not launch ${link.url}');
                        }
                      },
                    ),
                  );
                }).toList()),
              ),
              widget.score! >= 3
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 8),
                      child: Center(
                        child: ElevatedButton(
                          style: style,
                          onPressed: () {
                            // Navigate to the second screen using a named route.
                            Navigator.pushNamed(context, '/advancedSurvey');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12),
                            child: Text(
                              AppLocalizations.of(context).advancedSurveyButton,
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).somethingWrong,
              textAlign: TextAlign.center,
            ),
          );
  }
}

// Container for animated score display
class ScoreDisplayContainer extends StatelessWidget {
  ScoreDisplayContainer(
      {Key? key, required this.score, required this.allAnswers})
      : super(key: key);

  final int? score;
  final List<int>? allAnswers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context).dearParent),
          ),
          SizedBox(
            height: 15,
          ),
          CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 15.0,
            percent: score! / allAnswers!.length,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$score/${allAnswers!.length}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
                Text(
                  AppLocalizations.of(context).points,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.white,
            progressColor: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
