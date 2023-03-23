import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model.dart';

class AdminPanelRoute extends StatefulWidget {
  @override
  _AdminPanelRoute createState() => _AdminPanelRoute();
}

class _AdminPanelRoute extends State<AdminPanelRoute> {
  final formKey = new GlobalKey<FormState>();

  dynamic _email = '';
  dynamic _password = '';

  _AdminPanelRoute() {
    // Register for login changes upon LoginFormValidation instance creation.
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamed(context, '/');
      }
    });
  }

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

    createSurveysBuild() {
      return FutureBuilder(
          future: getSurveyAnswers(),
          initialData: "Loading surveys..",
          builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
            return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text.data
                      .toString()
                      .replaceAll("],", "],\n")
                      .replaceAll("{", "")
                      .replaceAll("}", ""),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                ));
          });
    }

    createAdvancedSurveysBuild() {
      return FutureBuilder(
          future: getAdvancedSurveyAnswers(),
          initialData: "Loading advanced surveys..",
          builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
            return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text.data
                      .toString()
                      .replaceAll("],", "],\n")
                      .replaceAll("{", "")
                      .replaceAll("}", ""),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                ));
          });
    }

    createAdvancedRawSurveysBuild() {
      return FutureBuilder(
          future: getAdvancedSurveyRawAnswers(),
          initialData: "Loading advanced surveys..",
          builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
            return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text.data
                      .toString()
                      .replaceAll("],", "],\n")
                      .replaceAll("{", "")
                      .replaceAll("}", ""),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                ));
          });
    }

    Future<void> showSurveys() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('All surveys:'),
            content: SingleChildScrollView(child: createSurveysBuild()),
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

    Future<void> showAdvancedSurveys() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('All advanced surveys:'),
            content: SingleChildScrollView(child: createAdvancedSurveysBuild()),
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

    Future<void> showAdvancedRawSurveys() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('All advanced raw surveys:'),
            content:
                SingleChildScrollView(child: createAdvancedRawSurveysBuild()),
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

    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2)),
        backgroundColor: Colors.white,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 1);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'graphics/SYNAPSIS_herb_2.png',
          fit: BoxFit.cover,
          scale: 2,
        ),
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        padding: const EdgeInsets.all(20),
        // Generate 100 widgets that display their index in the List.
        children: <Widget>[
          OutlinedButton(
            style: style,
            child: const Text(
              "Edytuj pytania",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/questions');
            },
          ),
          OutlinedButton(
            style: style,
            child: const Text(
              "Przeglądaj ankiety podstawowe",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              print(await getAnswers());
              showSurveys();
            },
          ),
          OutlinedButton(
            style: style,
            child: const Text(
              "Przeglądaj ankiety rozszerzone",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              print(await getAdvancedAnswers());
              showAdvancedSurveys();
            },
          ),
          OutlinedButton(
            style: style,
            child: const Text(
              "Dodaj nowego admina",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/newAdmin');
            },
          ),
          OutlinedButton(
            style: style,
            child: const Text(
              "Wyloguj się",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Divider(height: 50),
      // ElevatedButton(
      //   onPressed: () {
      //     // log out user, to avoid strange "immediate log in after first one was successfull"
      //     FirebaseAuth.instance.signOut();
      //     Navigator.pushNamed(context, '/');
      //   },
      //   child: const Text('Wyloguj się'),
      // ),
      //       Divider(height: 50),
      //       ElevatedButton(
      //         onPressed: () {
      //           // Navigate to the second screen using a named route.
      //           Navigator.pushNamed(context, '/questions');
      //         },
      //         child: const Text('Edit Questions'),
      //       ),
      //       Divider(height: 50),
      //       ElevatedButton(
      //         child: Text("Show all past surveys"),
      //         onPressed: () async {
      //           print(await getAnswers());
      //           showSurveys();
      //         },
      //       ),
      //       Divider(height: 50),
      //       ElevatedButton(
      //         child: Text("Show all past advanced surveys"),
      //         onPressed: () async {
      //           print(await getAdvancedAnswers());
      //           showAdvancedSurveys();
      //         },
      //       ),
      //       Divider(height: 50),
      //       ElevatedButton(
      //         child: Text("Show all past raw advanced surveys"),
      //         onPressed: () async {
      //           print(await getAdvancedRawAnswers());
      //           showAdvancedRawSurveys();
      //         },
      //       ),
      //       Divider(height: 50),
      //       ElevatedButton(onPressed: () {

      //       }, child: Text('Dodaj nowego admina')),

      // Form(
      //   key: formKey,
      //   child: Column(
      //     children: [
      //       Center(
      //         child: SizedBox(
      //           width: 400,
      //           child: TextFormField(
      //             validator: (text) {
      //               if (text == null || text.isEmpty) {
      //                 return 'Can\'t be empty';
      //               }
      //               if (!RegExp(
      //                       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //                   .hasMatch(text)) {
      //                 return 'Enter valid email adress';
      //               }
      //               return null;
      //             },
      //             onSaved: (text) => _email = text,
      //             decoration: InputDecoration(
      //                 labelText: "Email", hintText: "Enter Email"),
      //           ),
      //         ),
      //       ),
      //       Center(
      //         child: SizedBox(
      //           width: 400,
      //           child: TextFormField(
      //             obscureText: true,
      //             onSaved: (text) => _password = text,
      //             validator: (text) {
      //               if (text == null || text.isEmpty) {
      //                 return 'Can\'t be empty';
      //               }
      //               return null;
      //             },
      //             decoration: InputDecoration(
      //                 labelText: "Password", hintText: "Enter Password"),
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(15.0),
      //         child: ElevatedButton(
      //             style: ElevatedButton.styleFrom(
      //                 backgroundColor: Colors.black54),
      //             child: Text(
      //               "Add new admin",
      //               style: TextStyle(color: Colors.yellow, fontSize: 20),
      //             ),
      //             onPressed: () {
      //               if (formKey.currentState!.validate()) {
      //                 formKey.currentState!.save();
      //                 saveNewAdmin(_email, _password);
      //                 formKey.currentState!.reset();
      //                 _showMyDialog();
      //               }
      //             }),
      //       ),
      //     ],
      //   ),
      // ),
      // ],
      // ),
    );
  }
}

dynamic getAnswers() async {
  return await getSurveyAnswers().then((id) => [id]);
}

dynamic getAdvancedAnswers() async {
  return await getAdvancedSurveyAnswers().then((id) => [id]);
}

dynamic getAdvancedRawAnswers() async {
  return await getAdvancedSurveyRawAnswers().then((id) => [id]);
}
