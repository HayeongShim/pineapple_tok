import 'package:flutter/material.dart';
import 'package:pineapple_talk/friends/friends_page.dart';
import 'package:pineapple_talk/login/account.dart';
import 'package:pineapple_talk/chatting/chatting_page.dart';

class MainPage extends StatefulWidget {
  final Account myAccount;
  const MainPage(this.myAccount);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Widget> _pages = <Widget>[];

  @override
  void initState() {
    _pages.add(FriendsPage());
    _pages.add(ChattingPage());
  }

  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people),label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.chat),label: 'Chatting'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'FineApples'),
        ],
        backgroundColor: Colors.green.shade100,
        selectedItemColor: Colors.green,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 35.0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}