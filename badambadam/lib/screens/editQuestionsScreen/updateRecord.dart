import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateRecord extends StatefulWidget {

  const UpdateRecord({Key? key, required this.questionKey}) : super(key: key);

  final String questionKey;

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {

  final  userIdController = TextEditingController();
  final  userQuestionController = TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('questions');
    getQuestionData();
  }

  void getQuestionData() async {
    DataSnapshot snapshot = await dbRef.child(widget.questionKey).get();

    Map question = snapshot.value as Map;

    userIdController.text = question['id'].toString();
    userQuestionController.text = question['questions'].join("[do_not_remove]");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edycja pytania'),
      ),
      body:  Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: userQuestionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pytanie',
                    hintText: 'Podaj treść pytania',
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  Map<String, dynamic> questions = {
                    'id': userIdController.text.toString(),
                    'questions': userQuestionController.text.split("[do_not_remove]"),
                  };

                  dbRef.child(widget.questionKey).update(questions)
                      .then((value) => {
                  Navigator.pushNamed(context, '/questions')
                  });

                },
                color: Theme.of(context).colorScheme.primary,
                minWidth: 300,
                height: 40,
                child: Text('Zapisz zmiany'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}