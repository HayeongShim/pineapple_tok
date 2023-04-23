import 'package:flutter/material.dart';
import 'package:pineapple_talk/login_page.dart';
import 'package:pineapple_talk/friends_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pineapple Talk',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      //home: LoginPage(),
      home: FriendsPage(),
    );
  }
}