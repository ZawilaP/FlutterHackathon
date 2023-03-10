import 'package:badambadam/screens/homePageScreen/DatePick.dart';
import 'package:badambadam/screens/homePageScreen/TextSubmitForm.dart';
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
          '/surveys': (context) => SurveysRoute(),
          '/result': (context) => const ResultRoute(),
          '/advancedResult': (context) => const AdvancedResultRoute(),
          '/login': (context) => LoginFormValidation(),
          '/admin': (context) => AdminPanelRoute(),
          '/questions': (context) => FetchData(),
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
          IconButton(
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
          TextSubmitForm(onSubmit: (value) => print(value)),
          DatePick(onSubmit: (value) => print(value))
        ],
      ),
    );
  }
}

const entryTextPl = [
  "Szanowni Pa??stwo, \nwiemy, ??e to w??a??nie Rodzice maj?? najlepsze intuicje, co do rozwoju swoich dzieci. Wi??kszo???? ich spostrze??e?? dotyczy umiej??tno??ci oraz zainteresowa?? dzieci i jest powodem do rado??ci. Czasem, jako rodzice, mamy jednak tak??e jakie?? intuicje i obserwacje budz??ce nasz niepok??j. Zawsze warto je rozwia??, ??eby nic nie burzy??o przygody, jak?? jest wsp??lne odkrywania ??wiata z naszym Maluchem.",
  "Oddajemy w Pa??stwa r??ce narz??dzie M-CHAT-R, kt??re zosta??o stworzone w celu oceny ryzyka wyst??pienia zaburze?? ze spektrum autyzmu i pozwala na wst??pn?? ocen?? prawid??owo??ci rozwoju dziecka w zakresie rozwoju spo??ecznego oraz umiej??tno??ci komunikowania si??. W wi??kszo??ci przypadk??w, je??li nawet wyst??puj?? jakie?? nieprawid??owo??ci rozwojowe, ko??cz?? si?? one wizytami u logopedy lub prostymi ??wiczeniami w zaciszu domowym. Tylko 1% badanych dzieci wymaga dalszej diagnostyki i terapii w kierunku zaburze?? ze spektrum autyzmu. Dla tych dzieci jest to szansa na szybsz?? pomoc.",
  "Zach??camy wi??c do wype??nienia kwestionariusza, szczeg??lnie, ??e mo??na to zrobi?? w najbardziej wygodnym dla siebie czasie i miejscu, ze wzgl??du na dost??pno???? badania online.",
  "The Modified Checklist for Autism in Toddlers (M-CHAT-R), powi??zane z nim materia??y oraz wszelkie informacje o mo??liwo??ci ich u??ytkowania dost??pne s?? na stronie https://www.mchatscreen.com .",
  "Narz??dzie M-CHAT-R przeznaczone jest dla dzieci w wieku 16 do 30 miesi??cy. Wype??nienie kwestionariusza dla dzieci m??odszych ni?? 16 miesi??cy da nieprawdziwe wyniki, gdy?? maj?? one prawo nie opanowa?? jeszcze wielu umiej??tno??ci, jakie posiadaj?? dzieci starsze. Rodzic??w m??odszych dzieci (pomi??dzy 12 a 18 miesi??cem ??ycia) zach??camy do zapoznania si?? z list?? umiej??tno??ci rozwojowych odpowiadaj??cych temu wiekowi http://synapsis.org.pl/zycie-z-autyzmem/dla-rodzicow-i-opiekunow/12-18-miesiac",
  "By wzi???? udzia?? w ankiecie podaj kod pocztowy oraz dat?? urodzenia swojego dziecka:"
];
