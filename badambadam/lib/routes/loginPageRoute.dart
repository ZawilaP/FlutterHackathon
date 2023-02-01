import 'package:flutter/material.dart';

class LoginFormValidation extends StatefulWidget {
  @override
  _LoginFormValidation createState() => _LoginFormValidation();
}

class _LoginFormValidation extends State<LoginFormValidation> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  dynamic _email = '';
  dynamic _state = '';

  @override
  Widget build(BuildContext context) {
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
      if (text != 'sample@admin.com') {
        return 'Your user ID or password is incorrect';
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
      onSaved: (text) => _state = text,
      validator: (text) {
        if (text == null || text.isEmpty) {
    return 'Can\'t be empty';
    }
    if (text != 'admin') {
    return 'Your user ID or password is incorrect';
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
                onPressed: () {
                  if(formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      Navigator.pushNamed(context, '/admin');
                    }
                  }
    ),
    ),
    ],
    ),
    ),
    );
  }
}