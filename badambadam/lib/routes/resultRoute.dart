import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import 'package:badambadam/screens/resultScreen/result_texts_pl.dart';

class ResultRoute extends StatelessWidget {
  const ResultRoute({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> loadAsset(BuildContext context) async {
      return await DefaultAssetBundle.of(context)
          .loadString('assets/result_texts_pl.dart');
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/advancedSurvey');
            },
            child: const Text('Take Advanced Survey'),
          ),
          Text('Wynik Twojego dziecka: '),
          SizedBox(
            height: 10,
          ),
          ScoreDisplayContainer(),
          Text("Your Survey GUIDs ${getGuidList().toString()}"),
        ],
      ),
    );
  }
}

class ScoreDisplayContainer extends StatelessWidget {
  const ScoreDisplayContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text('${getFinalScore().toString()}/20', style: TextStyle(fontSize: 32),),
      ],
    );
  }
}
