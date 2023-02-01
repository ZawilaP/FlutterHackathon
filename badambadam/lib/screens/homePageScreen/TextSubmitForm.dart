import 'package:flutter/material.dart';

class TextSubmitForm extends StatefulWidget {
  const TextSubmitForm({Key? key, required this.onSubmit}) : super(key: key);
  final ValueChanged<String> onSubmit;

  @override
  State createState() => _TextSubmitFormState();
}

class _TextSubmitFormState extends State<TextSubmitForm> {
  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  String _name = '';

  void _submit() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_name);
      Navigator.pushNamed(context, '/survey');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 80,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter age of your child in months',
                  ),
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  // The validator receives the text that the user has entered.
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Can\'t be empty';
                    }
                    if (int.tryParse(text) == null) {
                      return 'Please enter a numerical value';
                    }
                    if (int.parse(text) < 16 || int.parse(text) > 30) {
                      return 'Your child needs to be between 16 and 30 months to be eligible for survey';
                    }
                    return null;
                  },
                  onChanged: (text) => setState(() => _name = text),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _name.isNotEmpty ? _submit : null,
                child: Text(
                  'Submit',
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .headline6!
                  //     .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}