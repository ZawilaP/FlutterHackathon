import 'package:flutter/material.dart';

class LoginPageRoute extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginPageRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Admin Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('graphics/SYNAPSIS_herb_2.png')),
              ),
            ),
            Center(
              child: SizedBox(
                  width: 400,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter email'),
                ),
               ),
              ),
          Center(
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 5),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter password'),
                ),
            ),
            ),
          ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/admin');
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.yellow, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}