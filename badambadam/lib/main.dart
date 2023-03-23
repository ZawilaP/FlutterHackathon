import 'package:badambadam/routes/newAdminRoute.dart';
import 'package:badambadam/screens/homePageScreen/StartSurveyForm.dart';
import 'package:badambadam/storage.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:provider/provider.dart';
import 'routes/surveyRoute.dart';
import 'routes/surveysRoute.dart';
import 'routes/resultRoute.dart';
import 'routes/advancedSurveyRoute.dart';
import 'routes/advancedResultRoute.dart';
import 'routes/adminPanelRoute.dart';
import 'routes/editQuestionsRoute.dart';
import 'routes/loginPageRoute.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'M-CHAT-RF',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 118, 114, 105),
              background: Color.fromRGBO(253, 253, 253, 1),
              primary: Color.fromRGBO(255, 178, 0, 1),
              onPrimary: Color.fromRGBO(45, 42, 40, 1)),
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoCondensed'),
            bodyMedium: TextStyle(fontSize: 18.0),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/survey': (context) => const SurveyRoute(),
          '/advancedSurvey': (context) => const AdvancedSurveyRoute(),
          '/surveys': (context) => SurveysRoute(),
          '/result': (context) => const ResultRoute(),
          '/advancedResult': (context) => const AdvancedResultRoute(),
          '/login': (context) => LoginFormValidation(),
          '/admin': (context) => AdminPanelRoute(),
          '/questions': (context) => FetchData(),
          '/newAdmin':(context) => NewAdminRoute(),
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
        actions: <Widget>[
          /*IconButton(
            style: IconButton.styleFrom(hoverColor: Colors.transparent),
            icon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'graphics/flag_pl.png',
              ),
            ),
            onPressed: () {
              setCurrentLanguage("PL");
            },
          ),
          IconButton(
            style: IconButton.styleFrom(hoverColor: Colors.transparent),
            icon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('graphics/flag_eng.png'),
            ),
            onPressed: () {
              setCurrentLanguage("ENG");
            },
          ),*/
          Padding(
              padding: EdgeInsets.only(right: 50.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Icon(Icons.login),
              )),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(entryTextPl[0]),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                children: entryTextPl.sublist(1, entryTextPl.length).map((e) {
              return ListTile(
                leading: Icon(Icons.circle),
                title: LinkText(e),
              );
            }).toList()),
          ),
          //TextSubmitForm(onSubmit: (value) => print(value)),
          StartSurveyForm(onSubmit: (value) => print(value))
        ],
      ),
    );
  }
}

const entryTextPl = [
  "Szanowni Państwo, \nwiemy, że to właśnie Rodzice mają najlepsze intuicje, co do rozwoju swoich dzieci. Większość ich spostrzeżeń dotyczy umiejętności oraz zainteresowań dzieci i jest powodem do radości. Czasem, jako rodzice, mamy jednak także jakieś intuicje i obserwacje budzące nasz niepokój. Zawsze warto je rozwiać, żeby nic nie burzyło przygody, jaką jest wspólne odkrywania świata z naszym Maluchem.",
  "Oddajemy w Państwa ręce narzędzie M-CHAT-R, które zostało stworzone w celu oceny ryzyka wystąpienia zaburzeń ze spektrum autyzmu i pozwala na wstępną ocenę prawidłowości rozwoju dziecka w zakresie rozwoju społecznego oraz umiejętności komunikowania się. W większości przypadków, jeśli nawet występują jakieś nieprawidłowości rozwojowe, kończą się one wizytami u logopedy lub prostymi ćwiczeniami w zaciszu domowym. Tylko 1% badanych dzieci wymaga dalszej diagnostyki i terapii w kierunku zaburzeń ze spektrum autyzmu. Dla tych dzieci jest to szansa na szybszą pomoc.",
  "Zachęcamy więc do wypełnienia kwestionariusza, szczególnie, że można to zrobić w najbardziej wygodnym dla siebie czasie i miejscu, ze względu na dostępność badania online.",
  "The Modified Checklist for Autism in Toddlers (M-CHAT-R), powiązane z nim materiały oraz wszelkie informacje o możliwości ich użytkowania dostępne są na stronie https://www.mchatscreen.com .",
  "Narzędzie M-CHAT-R przeznaczone jest dla dzieci w wieku 16 do 30 miesięcy. Wypełnienie kwestionariusza dla dzieci młodszych niż 16 miesięcy da nieprawdziwe wyniki, gdyż mają one prawo nie opanować jeszcze wielu umiejętności, jakie posiadają dzieci starsze. Rodziców młodszych dzieci (pomiędzy 12 a 18 miesiącem życia) zachęcamy do zapoznania się z listą umiejętności rozwojowych odpowiadających temu wiekowi http://synapsis.org.pl/zycie-z-autyzmem/dla-rodzicow-i-opiekunow/12-18-miesiac",
  "By wziąć udział w ankiecie podaj kod pocztowy oraz datę urodzenia swojego dziecka:"
];
