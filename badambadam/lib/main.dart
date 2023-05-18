import 'package:badambadam/routes/adminAdvancedSurveyListRoute.dart';
import 'package:badambadam/routes/adminBasicSurveyListRoute.dart';
import 'package:badambadam/routes/newAdminRoute.dart';
import 'package:badambadam/screens/homePageScreen/StartSurveyForm.dart';
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
import 'package:flutter_localizations/flutter_localizations.dart';

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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('pl'), // Polish
        ],
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ),
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
          '/adminBasicSurvey':(context) => AdminBasicSurveyListRoute(),
          '/adminAdvancedSurvey': (context) => AdminAdvancedSurveyListRoute(),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(entryTextPl[0], textAlign: TextAlign.justify,),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  children: entryTextPl.sublist(1, entryTextPl.length).map((e) {
                return ListTile(
                  leading: Icon(Icons.check, color: Theme.of(context).colorScheme.primary,),
                  title: LinkText(e, textAlign: TextAlign.justify,),
                );
              }).toList()),
            ),
            StartSurveyForm(onSubmit: (value) => print(value))
          ],
        ),
      ),
    );
  }
}

const entryTextPl = [
  "Drodzy Rodzice, \nwiemy, że to właśnie Wy macie najlepszą wiedzę o swoich dzieciach. Większość Waszych spostrzeżeń dotyczy umiejętności oraz zainteresowań dzieci i jest powodem do radości. Czasami zdarza się jednak, że możecie być zaniepokojeni rozwojem dziecka. Wówczas warto sprawdzić, czy rzeczywiście jest powód do niepokoju. ",
  "Oddajemy w Wasze ręce narzędzie M-CHAT-R, które zostało stworzone w celu oceny ryzyka wystąpienia spektrum autyzmu. Pozwala na wstępną ocenę dziecka w zakresie jego rozwoju społecznego oraz umiejętności komunikowania się. W większości przypadków, jeśli nawet występują jakieś nieprawidłowości rozwojowe, wymagają one jedynie wizyt u logopedy lub prostych ćwiczeń w domowym zaciszu. Tylko niewielki procent badanych dzieci wymaga dalszej diagnostyki w kierunku spektrum autyzmu. Dla tych dzieci jest to szansa na szybszą terapię.",
  "Zachęcamy więc do wypełnienia kwestionariusza online. Pamiętajcie, że warto jest zawsze wyjaśniać wątpliwości, aby nic nie burzyło przygody, jaką jest wspólne odkrywania świata z naszym Maluchem.",
  "The Modified Checklist for Autism in Toddlers (M-CHAT-R), powiązane z nim materiały oraz wszelkie informacje o możliwości ich użytkowania dostępne są na stronie https://www.mchatscreen.com .",
  "Narzędzie M-CHAT-R przeznaczone jest dla dzieci w wieku od 16 do 30 miesięcy. Wypełnienie kwestionariusza dla dzieci młodszych da nieprawdziwe wyniki, gdyż mają one prawo nie opanować jeszcze wielu umiejętności, jakie posiadają dzieci starsze. Rodziców młodszych dzieci (pomiędzy 12 a 18 miesiącem życia) zachęcamy do zapoznania się z listą umiejętności rozwojowych odpowiadających temu wiekowi: http://badabada.pl/dla-rodzicow/rozwoj-dziecka",
  "By wziąć udział w ankiecie podaj kod pocztowy oraz datę urodzenia swojego dziecka:"
];
