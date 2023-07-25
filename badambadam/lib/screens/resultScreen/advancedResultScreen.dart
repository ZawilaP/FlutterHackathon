import 'package:badambadam/screens/resultScreen/advancedPdfReport.dart';
import 'package:badambadam/screens/resultScreen/advancedPdfReportEnglish.dart';
import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:linkify/linkify.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvancedResultDisplayScreen extends StatefulWidget {
  const AdvancedResultDisplayScreen(
      {super.key, this.score, this.allRawAnswers, this.allCalculatedAnswers});

  final int? score;
  final Map<String, List<String>>? allRawAnswers;
  final Map<dynamic, dynamic>? allCalculatedAnswers;

  @override
  State<AdvancedResultDisplayScreen> createState() =>
      _AdvancedResultDisplayScreenState();
}

class _AdvancedResultDisplayScreenState
    extends State<AdvancedResultDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    String intro = " ";
    String paragraph = " ";
    List<String> actions = [];

    String currentLocale = Localizations.localeOf(context).languageCode;

    setState(() {
      if (widget.score! < 2) {
        intro = AppLocalizations.of(context).negativeIntro;
        paragraph = AppLocalizations.of(context).negativeParagraph;
        actions = [
          AppLocalizations.of(context).negativeActions1,
          AppLocalizations.of(context).negativeActions2,
          AppLocalizations.of(context).negativeActions3,
          AppLocalizations.of(context).negativeActions4
        ];
      } else {
        intro = AppLocalizations.of(context).positiveIntro;
        paragraph = AppLocalizations.of(context).positiveParagraph;
        actions = [
          AppLocalizations.of(context).positiveActions1,
          AppLocalizations.of(context).positiveActions2,
          AppLocalizations.of(context).positiveActions3,
          AppLocalizations.of(context).positiveActions4,
          AppLocalizations.of(context).positiveActions5
        ];
      }
    });

    var currentGuid = getCurrentGuid()
        .toString()
        .replaceAll(".", "-")
        .replaceAll(" ", "-")
        .replaceAll(":", "-")
        .replaceAll("_", "-")
        .toString()
        .split('-');

    var currentGuidUserNumber = currentGuid[currentGuid.length - 1];

    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 8);

    return widget.allRawAnswers!.isNotEmpty
        ? ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              ScoreDisplayContainer(
                score: widget.score,
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
                  ? AdvancedPDFSave(
                      score: widget.score,
                      allRawAnswers: widget.allRawAnswers,
                      allCalculatedAnswers: widget.allCalculatedAnswers,
                    )
                  : EnglishAdvancedPDFSave(
                      score: widget.score,
                      allRawAnswers: widget.allRawAnswers,
                      allCalculatedAnswers: widget.allCalculatedAnswers,
                    ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  intro,
                  style: widget.score! >= 2
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : TextStyle(),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  paragraph,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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

class ScoreDisplayContainer extends StatelessWidget {
  const ScoreDisplayContainer({super.key, this.score});
  final int? score;

  String getScoreText(int? score, BuildContext context) {
    String currText = '';

    if (score == 1) {
      currText = AppLocalizations.of(context).singlePoint;
    } else if (score! > 1 && score <= 4) {
      currText = AppLocalizations.of(context).points2;
    } else {
      currText = AppLocalizations.of(context).points;
    }

    return currText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
          Text(
            '$score ${getScoreText(score, context)}',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            score! >= 2
                ? AppLocalizations.of(context).positiveResult
                : AppLocalizations.of(context).negativeResult,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
