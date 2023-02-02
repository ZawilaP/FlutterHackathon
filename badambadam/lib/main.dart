import 'package:badambadam/screens/homePageScreen/TextSubmitForm.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
              seedColor: Color.fromRGBO(255, 178, 0, 1),
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
          '/surveys': (context) => const SurveysRoute(),
          '/result': (context) => const ResultRoute(),
          '/advancedResult': (context) => const AdvancedResultRoute(),
          '/login': (context) => LoginFormValidation(),
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
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 50.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Icon(Icons.login),
              )),
        ],
      ),
      body: ListView(
        children: [
          Text.rich(TextSpan(
              style: TextStyle(
                fontSize: 14,
              ),
              children: [
                TextSpan(text: """Szanowni Państwo,

wiemy, że to właśnie Rodzice mają najlepsze intuicje, co do rozwoju swoich dzieci. Większość ich spostrzeżeń dotyczy umiejętności oraz zainteresowań dzieci i jest powodem do radości. Czasem, jako rodzice, mamy jednak także jakieś intuicje i obserwacje budzące nasz niepokój. Zawsze warto je rozwiać, żeby nic nie burzyło przygody, jaką jest wspólne odkrywania świata z naszym Maluchem.

Oddajemy w Państwa ręce narzędzie M-CHAT-R, które zostało stworzone w celu oceny ryzyka wystąpienia zaburzeń ze spektrum autyzmu i pozwala na wstępną ocenę prawidłowości rozwoju dziecka w zakresie rozwoju społecznego oraz umiejętności komunikowania się. W większości przypadków, jeśli nawet występują jakieś nieprawidłowości rozwojowe, kończą się one wizytami u logopedy lub prostymi ćwiczeniami w zaciszu domowym. Tylko 1% badanych dzieci wymaga dalszej diagnostyki i terapii w kierunku zaburzeń ze spektrum autyzmu. Dla tych dzieci jest to szansa na szybszą pomoc.

Zachęcamy więc do wypełnienia kwestionariusza, szczególnie, że można to zrobić w najbardziej wygodnym dla siebie czasie i miejscu, ze względu na dostępność badania online.

The Modified Checklist for Autism in Toddlers (M-CHAT-R), powiązane z nim materiały oraz wszelkie informacje o możliwości ich użytkowania dostępne są na stronie """),
                TextSpan(
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    //make link blue and underline
                    text: "www.mchatscreen.com",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        //on tap code here, you can navigate to other page or URL
                        String url = "https://www.mchatscreen.com";
                        var urllaunchable = await canLaunch(
                            url); //canLaunch is from url_launcher package
                        if (urllaunchable) {
                          await launch(
                              url); //launch is from url_launcher package to launch URL
                        } else {
                          print("URL can't be launched.");
                        }
                      }),
                TextSpan(
                  text: """


Narzędzie M-CHAT-R przeznaczone jest dla dzieci w wieku 16 do 30 miesięcy. Wypełnienie kwestionariusza dla dzieci młodszych niż 16 miesięcy da nieprawdziwe wyniki, gdyż mają one prawo nie opanować jeszcze wielu umiejętności, jakie posiadają dzieci starsze. Rodziców młodszych dzieci (pomiędzy 12 a 18 miesiącem życia) zachęcamy do zapoznania się z listą umiejętności rozwojowych odpowiadających temu wiekowi """,
                ),
                TextSpan(
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    //make link blue and underline
                    text: "tutaj.",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        //on tap code here, you can navigate to other page or URL
                        String url =
                            "http://synapsis.org.pl/zycie-z-autyzmem/dla-rodzicow-i-opiekunow/12-18-miesiac";
                        var urllaunchable = await canLaunch(
                            url); //canLaunch is from url_launcher package
                        if (urllaunchable) {
                          await launch(
                              url); //launch is from url_launcher package to launch URL
                        } else {
                          print("URL can't be launched.");
                        }
                      }),
                TextSpan(
                    text:
                        "\n\nBy wziąć udział w ankiecie wypełnij wiek swojego dziecka w miesiącach poniżej:"),
              ])),
          TextSubmitForm(onSubmit: (value) => print(value))
        ],
      ),
    );
  }
}
