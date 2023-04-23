import 'package:flutter/material.dart';
import 'package:pineapple_talk/bottom_navigator.dart';

class FriendsPage extends StatelessWidget {
  int _navBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '   Friends',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          )
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Center(
          child: FriendsList(),
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

const data = [
  "권본권",
  "모하메드",
  "심하영",
  "빌게이츠",
  "이승현",
  "김충연",
  "임규완",
  "서지호",
  "명희권",
  "김민택",
  "김경훈",
];

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: data.length, itemBuilder: _buildRow,);
  }
  Widget _buildRow(BuildContext ctxt, int idx){
    return ListTile(
      leading : const Icon(
          Icons.person,
      ),
      title : Text(data[idx],),
    );
  }
}