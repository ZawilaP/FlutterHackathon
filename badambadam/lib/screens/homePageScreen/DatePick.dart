import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePick extends StatefulWidget {
  const DatePick({Key? key, required this.onSubmit}) : super(key: key);
  final ValueChanged<String> onSubmit;

  @override
  State createState() => _DatePick();
}

class _DatePick extends State<DatePick> {
  final _dateKey = GlobalKey<FormState>();
  TextEditingController selectDate = TextEditingController();

  bool _submitted = false;
  String _name = '';

  void _submit() {
    setState(() => _submitted = true);
    if (_dateKey.currentState!.validate()) {
      widget.onSubmit(_name);
      Navigator.pushNamed(context, '/survey');
    }
  }

  @override
  Widget build(BuildContext context) {

    final ButtonStyle style = ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 8);
    return Form(
      key: _dateKey,
      child: Column(children: [
        TextFormField(
          controller: selectDate,
          decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today_rounded),
              labelText: 'Select date of birth of your child'),
          autovalidateMode: _submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: (selectDate) {
            if (selectDate == null || selectDate.isEmpty) {
              return 'Please enter a date';
            }
            if (DateTime.parse(selectDate)
                    .isAfter(DateTime.now().subtract(Duration(days: 487))) ||
                DateTime.parse(selectDate)
                    .isBefore(DateTime.now().subtract(Duration(days: 913)))) {
              return 'Your child needs to be between 16 and 30 months to be eligible for survey';
            }
            return null;
          },
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 10000)),
                lastDate: DateTime.now());
            if (pickeddate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickeddate);
              setState(() {
                selectDate.text = formattedDate;
                _name = formattedDate;
              });
            }
          },
          onChanged: (formattedDate) => setState(() => _name = formattedDate),
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed: _name.isNotEmpty ? _submit : null,
              style: style,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'SUBMIT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
