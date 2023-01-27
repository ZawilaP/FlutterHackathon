import 'package:flutter/material.dart';

class AgeCheckRoute extends StatelessWidget {
  const AgeCheckRoute({super.key});

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
          YesNoButtons()
        ],
      ),
    );
  }
}

class YesNoButtons extends StatelessWidget {
  const YesNoButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: style,
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/survey');
            },
            child: const Text('Age within 16-30 months'),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: style,
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pop(context);
            },
            child: const Text('Age not within 16-30 months'),
          ),
        )
      ],
    );
  }
}