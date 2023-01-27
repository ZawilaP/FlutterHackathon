import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/surveyRoute.dart';
import 'routes/surveysRoute.dart';
import 'routes/resultRoute.dart';
import 'routes/advancedSurveyRoute.dart';
import 'routes/advancedResultRoute.dart';
import 'routes/adminPanelRoute.dart';
import 'routes/editQuestionsRoute.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // print("czytam survey z backendu");
    // Survey s = FakeBackendSingleton().getSurvey(null);
    // print("nodes count = ${s.nodes.length}");
    // s.nodes.forEach((element) {
    //   log(element.toString());
    // });
    // print("koniec");
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'M-CHAT-RF',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromRGBO(255, 222, 0, 1)),
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/survey': (context) => const SurveyRoute(),
          '/advancedSurvey': (context) => const AdvancedSurveyRoute(),
          '/surveys': (context) => const SurveysRoute(),
          '/result': (context) => const ResultRoute(),
          '/advancedResult': (context) => const AdvancedResultRoute(),
          '/admin': (context) => const AdminPanelRoute(),
          '/questions': (context) => const EditQuestionsRoute(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Navigator.pushNamed(context, '/age');
            },
            child: const Text("Check age"),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/surveys');
            },
            child: const Text("Past Surveys"),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/admin');
            },
            child: const Text("Admin Panel (will be separate page later)"),
          ),
          TextSubmitForm(onSubmit: (value) => print(value))
        ],
      ),
    );
  }
}

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
              SizedBox(height: 10,),
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
