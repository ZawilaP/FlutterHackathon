import 'package:flutter/material.dart';

import '../model.dart';

class AdminPanelRoute extends StatefulWidget {
  @override
  _AdminPanelRoute createState() => _AdminPanelRoute();
}

class _AdminPanelRoute extends State<AdminPanelRoute> {
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
            title: const Text('Success!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('New admin added to database'),
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

    createFutureBuild() {
      return FutureBuilder(
          future: getSurveyAnswers(),
          initialData: "Loading text..",
          builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
            return new SingleChildScrollView(
                padding: new EdgeInsets.all(8.0),
                child: new Text(
                  text.data.toString().replaceAll("],", "],\n").replaceAll("{", "").replaceAll("}", ""),
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                ));
          });
    }

    Future<void> _showMyDialog2() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('All surveys:'),
            content: SingleChildScrollView(
                child: createFutureBuild()
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
      appBar: AppBar(
        title: Image.asset(
          'graphics/SYNAPSIS_herb_2.png',
          fit: BoxFit.cover,
          scale: 2,
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/questions');
            },
            child: const Text('Edit Questions'),
          ),
          ElevatedButton(
            child: Text("Show all past surveys"),
            onPressed: () async {
              print(await getAnswers());
              _showMyDialog2();
            },
          ),
          Divider(),
          Form(
            key: formKey,
            child: Column(
              children: [

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
                      child: Text("Add new admin",
                        style: TextStyle(color: Colors.yellow, fontSize: 20),),
                      onPressed: () {
                        if(formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          saveNewAdmin(_email, _password);
                          formKey.currentState!.reset();
                          _showMyDialog();
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

dynamic getAnswers() async {
  return await getSurveyAnswers().then((id) => [id]);
}