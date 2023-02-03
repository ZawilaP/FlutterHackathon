import 'package:badambadam/model.dart';
import 'package:flutter/material.dart';

class LoginFormValidation extends StatefulWidget {
  @override
  _LoginFormValidation createState() => _LoginFormValidation();
}

class _LoginFormValidation extends State<LoginFormValidation> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

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
        title: Text("Admin Login Page"),
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
      return 'Can\'t be empty';
      }
      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(text)) {
        return 'Enter valid email adress';
      }
      return null;
      },
      onSaved: (text) => _email = text,
      decoration: InputDecoration(
      labelText: "Email",
      hintText: "Enter Email"
      ),
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
    return 'Can\'t be empty';
    }
    return null;
    },
      decoration: InputDecoration(
      labelText: "Password",
      hintText: "Enter Password"
      ),
      ),
        ),
      ),
      Padding(
      padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54
                  ),
                child: Text("Login",
                  style: TextStyle(color: Colors.yellow, fontSize: 20),),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      if (await getAdminCredentials(_email
                          .split("@")
                          .first).then((id) =>
                      id["email"] == _email && id["password"] == _password)) {
                        Navigator.pushNamed(context, '/admin');
                      }
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