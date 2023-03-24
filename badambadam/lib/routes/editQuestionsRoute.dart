import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../screens/editQuestionsScreen/updateRecord.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  Query dbRef = FirebaseDatabase.instance.ref().child('questions');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('questions');

  Widget listItem({required Map question}) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: Theme.of(context).colorScheme.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black45, width: 0.75),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Text(
            question['id'].toString().replaceAll('_0', '.'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("Pytanie: ${question['questions'].join(',')}"),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          UpdateRecord(questionKey: question['key'])));
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edycja pytań'),
      ),
      body: FirebaseAnimatedList(
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map question = snapshot.value as Map;
          question['key'] = snapshot.key;

          return listItem(question: question);
        },
      ),
    );
  }
}
