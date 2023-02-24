import 'package:flutter/material.dart';

class AdvancedTextField extends StatefulWidget {
  const AdvancedTextField(
      {Key? key, required this.allAdvancedAnswersDetails, required this.nodeId})
      : super(key: key);

  final ValueNotifier<Map<String, List<String>>> allAdvancedAnswersDetails;
  final String nodeId;

  @override
  State<AdvancedTextField> createState() => _AdvancedTextFieldState();
}

class _AdvancedTextFieldState extends State<AdvancedTextField> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'If you want to add something, do it here'),
      onChanged: (text) {
        widget.allAdvancedAnswersDetails.value[widget.nodeId] =
            ["OPEN_${myController.text}"].toList();
        print(widget.allAdvancedAnswersDetails.toString());
      },
    );
  }
}