import 'package:flutter/material.dart';

class AdminPanelRoute extends StatelessWidget {
  const AdminPanelRoute({super.key});

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
              Navigator.pushNamed(context, '/questions');
            },
            child: const Text('Edit Questions'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/surveys');
            },
            child: const Text('See all surveys'),
          )
        ],
      ),
    );
  }
}