import 'package:flutter/material.dart';

import '../model.dart';

class NewAdminRoute extends StatefulWidget {
  const NewAdminRoute({super.key});

  @override
  State<NewAdminRoute> createState() => _NewAdminRouteState();
}

class _NewAdminRouteState extends State<NewAdminRoute> {
  final formKey = GlobalKey<FormState>();
  dynamic _email = '';
  dynamic _password = '';

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sukces!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Dodano nowego admina!'),
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

    final ButtonStyle style =  ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          );

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => Navigator.pushNamed(context, '/admin'),
          child: Image.asset(
            'graphics/SYNAPSIS_herb_2.png',
            fit: BoxFit.cover,
            scale: 2,
          ),
        ),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: 400,
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'E-mail nie może być pusty';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text)) {
                        return 'Wprowadź poprawny adres e-mail';
                      }
                      return null;
                    },
                    onSaved: (text) => _email = text,
                    decoration: InputDecoration(
                        labelText: "Adres e-mail", hintText: "Wprowadź adres e-mail"),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 400,
                  child: TextFormField(
                    obscureText: true,
                    onSaved: (text) => _password = text,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Hasło nie może być puste';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Hasło", hintText: "Wprowadź hasło"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                    style: style,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11),
                      child: Text(
                        "Dodaj nowego admina",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        saveNewAdmin(_email, _password);
                        formKey.currentState!.reset();
                        _showMyDialog();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
