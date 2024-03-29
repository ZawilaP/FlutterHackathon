import 'package:badambadam/routes/adminAdvancedSurveyListRoute.dart';
import 'package:badambadam/routes/adminBasicSurveyListRoute.dart';
import 'package:badambadam/routes/advancedMetricRoute.dart';
import 'package:badambadam/routes/metricRoute.dart';
import 'package:badambadam/routes/newAdminRoute.dart';
import 'package:badambadam/screens/homePageScreen/StartSurveyForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
        child: Consumer<MyAppState>(builder: (context, myAppState, child) {
          return MaterialApp(
              title: 'M-CHAT-RF',
              theme: ThemeData(
                scrollbarTheme: ScrollbarThemeData(
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
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
                '/survey': (context) => const SurveyRoute(),
                '/advancedSurvey': (context) => const AdvancedSurveyRoute(),
                '/surveys': (context) => SurveysRoute(),
                '/result': (context) => const ResultRoute(),
                '/advancedResult': (context) => const AdvancedResultRoute(),
                '/login': (context) => LoginFormValidation(),
                '/admin': (context) => AdminPanelRoute(),
                '/questions': (context) => FetchData(),
                '/newAdmin': (context) => NewAdminRoute(),
                '/adminBasicSurvey': (context) => AdminBasicSurveyListRoute(),
                '/adminAdvancedSurvey': (context) =>
                    AdminAdvancedSurveyListRoute(),
                '/metric': (context) => MetricRoute(),
                '/advancedMetric': (context) => AdvancedMetricRoute()
              },
              locale: myAppState.locale,
              localizationsDelegates: [
                AppLocalizations.delegate, // Add this line
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en'), // English
                Locale('pl') // Polish
              ],
              home: MyHomePage());
        }));
  }
}

class MyAppState extends ChangeNotifier {
  Locale _locale = Locale('pl');
  Locale get locale => _locale;

  void changeLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myAppState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'graphics/SYNAPSIS_herb_2.png',
          fit: BoxFit.cover,
          scale: 2,
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            style: IconButton.styleFrom(hoverColor: Colors.transparent),
            icon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'graphics/flag_pl.png',
              ),
            ),
            onPressed: () {
              // setCurrentLanguage("PL");
              myAppState.changeLocale(Locale('pl'));
            },
          ),
          IconButton(
            style: IconButton.styleFrom(hoverColor: Colors.transparent),
            icon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('graphics/flag_eng.png'),
            ),
            onPressed: () {
              myAppState.changeLocale(Locale('en'));
            },
          ),
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
              child: Text(
                AppLocalizations.of(context).helloWorld,
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  children: AppLocalizations.of(context)
                      .entryText
                      .split("\n")
                      .map((e) {
                return ListTile(
                  leading: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Linkify(
                    onOpen: (link) async {
                      if (!await launchUrl(Uri.parse(link.url))) {
                        throw Exception('Could not launch ${link.url}');
                      }
                    },
                    text: e,
                    textAlign: TextAlign.justify,
                  ),
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
