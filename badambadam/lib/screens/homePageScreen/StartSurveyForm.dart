import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class StartSurveyForm extends StatefulWidget {
  const StartSurveyForm({Key? key, required this.onSubmit}) : super(key: key);
  final ValueChanged<String> onSubmit;

  @override
  State createState() => _StartSurveyForm();
}

class _StartSurveyForm extends State<StartSurveyForm> {
  final _dateKey = GlobalKey<FormState>();
  TextEditingController selectDate = TextEditingController();

  String _birthDateString = '';
  String _postalCode = '';

  void _submit() {
    if (_dateKey.currentState!.validate()) {
      print(getBirthDateString());
      print(getPostalCode());
      Navigator.pushNamed(context, '/survey');
    }
  }

  @override
  Widget build(BuildContext context) {
    final myAppState = context.watch<MyAppState>();

    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 8);

    return Form(
      key: _dateKey,
      child: Column(children: [
        SizedBox(
          width: 500,
          child: TextFormField(
            controller: selectDate,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_today_rounded),
              labelText: 'Wprowadź datę urodzenia dziecka',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (selectDate) {
              if (selectDate == null || selectDate.isEmpty) {
                return 'Wprowadź datę.';
              }
              if (DateTime.tryParse(selectDate) == null) {
                return 'Wprowadź datę w formacie rrrr-mm-dd.';
              }
              if (DateTime.parse(selectDate)
                      .isAfter(DateTime.now().subtract(Duration(days: 487))) ||
                  DateTime.parse(selectDate)
                      .isBefore(DateTime.now().subtract(Duration(days: 913)))) {
                return 'Dziecko powinno mieć między 16 a 30 miesięcy.';
              }
              return null;
            },
            onTap: () async {
              DateTime? pickeddate = await showDatePicker(
                  locale: const Locale("pl"),
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 365 * 5)),
                  lastDate: DateTime.now());
              if (pickeddate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickeddate);
                setState(() {
                  selectDate.text = formattedDate;
                  _birthDateString = formattedDate;
                });
              }
            },
            onChanged: (formattedDate) {
              setBirthDateString(formattedDate);
              setState(() => _birthDateString = formattedDate);
            },
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
            width: 500,
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.home),
                labelText: AppLocalizations.of(context)!.zipCodePlaceholder,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              inputFormatters: [PostalCodeFormatter()],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // The validator receives the text that the user has entered.
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
              onChanged: (text) => setState(() {
                _postalCode = text;
                setPostalCode(text);
              }),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                if (_birthDateString.isEmpty) {
                  return;
                }
                if (_postalCode.isEmpty) {
                  return;
                }
                _submit();
              },
              style: style,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11),
                child: Text('Rozpocznij ankietę',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
            ),
          ),
        )
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
