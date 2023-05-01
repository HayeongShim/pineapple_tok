import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pineapple_talk/bottom_navigator.dart';
import 'package:pineapple_talk/account.dart';
import 'package:flutter/services.dart';
import 'package:pineapple_talk/profile.dart';
import 'dart:convert';

class FriendsPage extends StatelessWidget {
  int _navBarIndex = 0;
  Account myAccount = Account();
  FriendsPage(this.myAccount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '친구',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          )
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //buildMyProfile(myAccount),
            //Divider(thickness: 1, height: 20),
            Expanded(
              child: FriendsList(myAccount,),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class FriendsList extends StatefulWidget {
  FriendsList(this.myAccount, {Key? key}) : super(key: key);
  Account myAccount = Account();

  @override
  FriendsListState createState() => FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  List _friendsList = [];
  List<Profile> _profileList = [];

  @override
  void initState() {
    super.initState();
    _readJson();
  }

  void _readJson() async {
    await _readFriendsListJson();
    await _readProfileListJson();
    
    List<Profile> tempList = _profileList.sublist(1);
    tempList.sort((a, b) => a.name.compareTo(b.name)); // 오름차순 정렬
    _profileList = _profileList.sublist(0, 1); // TBD - range check
    _profileList.addAll(tempList);

    setState(() {});
  }

  Future<void> _readFriendsListJson() async {
    final String response = await rootBundle.loadString('assets/json/friends_list.json');
    final data = await json.decode(response);
    for (var list in data["friends_list"]){
      if (widget.myAccount.id == list['id']){
        _friendsList = list['friends'];
        break;
      }
    }
    _friendsList.insert(0, widget.myAccount.idx);
    print(_friendsList);
  }

  Future<void> _readProfileListJson() async {
    final String response = await rootBundle.loadString('assets/json/profile_list.json');
    final data = await json.decode(response);
    for (var list in _friendsList){
      for (var l in data["profile_list"]){
        if (list == l['id']){
          _profileList.add(Profile(l['id'], l['name'], l['photo']));
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // my profile
          //_buildProfile(_profileList[0].photo, _profileList[0].name, 35), // TBD - null check
          Divider(thickness: 1, height: 20),
          Text(
            '     친구 ${_profileList.length}',
            style: TextStyle(fontSize: 15, color: Colors.black, height: 1.0,),
            textAlign: TextAlign.left,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _profileList.length,
              itemBuilder: _buildProfiles,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfiles(BuildContext ctxt, int idx){
    if (_profileList[idx].photo == '')
    {
      return _buildProfile('assets/images/Logo.png', _profileList[idx].name);
    }
    else
    {
      return _buildProfile(_profileList[idx].photo, _profileList[idx].name);
    }
  }

  Widget _buildProfile(String path, String name, [double radius = 25]){
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: AssetImage(path),
          radius: radius,
      ),
      title: Text(name),
      visualDensity: VisualDensity(vertical: 1.0),
    );
  }
}