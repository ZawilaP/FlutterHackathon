import 'package:badambadam/model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginFormValidation extends StatefulWidget {
  @override
  _LoginFormValidation createState() => _LoginFormValidation();
}

class _LoginFormValidation extends State<LoginFormValidation> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  dynamic _email = '';
  dynamic _password = '';

  _LoginFormValidation() {
    // Register for login changes upon LoginFormValidation instance creation.
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.pushNamed(context, '/admin');
      }
    });
  }

  
  @override
  Widget build(BuildContext context) {

    final ButtonStyle style =  ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          );
          
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Failure'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Your user ID or password is incorrect'),
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

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Logowanie Administratora"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('graphics/SYNAPSIS_herb.png')),
              ),
            ),
            Center(
              child: SizedBox(
                width: 400,
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Adres e-mail nie może być pusty';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(text)) {
                      return 'Wprowadź adres e-mail';
                    }
                    return null;
                  },
                  onSaved: (text) => _email = text,
                  decoration: InputDecoration(
                      labelText: "Email", hintText: "Wprowadź adres e-mail"),
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
                    "Zaloguj",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      // sign in the user, disregarding exceptions for now
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _email, password: _password);
                      Navigator.pushNamed(context, '/admin');
                    } on FirebaseAuthException catch (e) {
                      _showMyDialog();
                    } on Error catch (_) {
                      _showMyDialog();
                    }
                  }
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
