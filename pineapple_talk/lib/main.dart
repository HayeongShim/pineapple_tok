import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: GestureDetector(
        onTap: () {
          textFocusId.unfocus();
          textFocusPw.unfocus();
        },
        child: MaterialApp(
          title: 'Pineapple Talk',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          ),
          home: MyHomePage(),
        ),

      ),

    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

// TBD - refactoring
FocusNode textFocusId = FocusNode();
FocusNode textFocusPw = FocusNode();

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          children: [
            SizedBox(height: 70.0),
            Column(
              children: [
                Image.asset('assets/images/Logo.png', height: 130),
                Text(
                  'Fine Apple',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.green,
                  )),
              ],
            ),
            SizedBox(height: 30.0),
            TextField(
              decoration: InputDecoration(
                filled: false,
                labelText: 'Username',
              ),
              focusNode: textFocusId,
            ),
            SizedBox(height: 12.0),
            TextField(
              decoration: InputDecoration(
                filled: false,
                labelText: 'Password',
              ),
              obscureText: true,
              focusNode: textFocusPw,
            ),
            SizedBox(height: 30.0),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {
                    textFocusId.unfocus();
                    textFocusPw.unfocus();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)
                    ),
                    minimumSize: Size(410, 50),
                  ),
                  child: Text("LOGIN"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}