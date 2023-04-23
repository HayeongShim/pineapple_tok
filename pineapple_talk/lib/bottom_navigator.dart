import 'package:flutter/material.dart';

class BottomNavigator extends StatelessWidget {
  BottomNavigator._privateConstructor();
  static final BottomNavigator _instance = BottomNavigator._privateConstructor();
  factory BottomNavigator() {
    return _instance;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.green.shade100,
        selectedItemColor: Colors.green,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 35.0,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.people),label: 'Friends'),
          const BottomNavigationBarItem(icon: Icon(Icons.chat),label: 'Chatting'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'FineApples'),
        ],
    );
  }
}