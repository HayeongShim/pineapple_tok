import 'package:flutter/material.dart';
import 'package:pineapple_talk/login/account.dart';
import 'package:pineapple_talk/friends/profile.dart';
import 'package:pineapple_talk/friends/profile_page.dart';

class FriendsPage extends StatelessWidget {
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
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FriendsList(myAccount,),
            ),
          ],
        ),
      ),
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
  bool isDataLoading = true;
  List<Profile> _profileList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    ProfileHandler profileHandler = ProfileHandler();
    _profileList = await profileHandler.getProfileList();

    /*
    if (_profileList.length > 1) {
      List<Profile> tempList = _profileList.sublist(1);
      tempList.sort((a, b) => a.name.compareTo(b.name)); // 오름차순 정렬
      _profileList = _profileList.sublist(0, 1); // TBD - range check
      _profileList.addAll(tempList);
    }
    */
    
    setState(() { isDataLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (isDataLoading) {
      return Center (
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_profileList.isNotEmpty)
              _buildProfile(_profileList.first, 35), // TBD - null check
            Divider(thickness: 1, height: 20),
            Text(
              '     친구 ${_profileList.length - 1}',
              style: TextStyle(fontSize: 15, color: Colors.black, height: 1.0,),
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: ListView(
                children: _buildFriendsProfile(context),
              ),
            ),
          ],
        ),
      );
    }
  }

  List<Widget> _buildFriendsProfile(BuildContext context){
    print("size");
    print(_profileList.length);
    if (_profileList.length > 1) {
      return List.generate(_profileList.length - 1, (index) {
        return _buildProfile(_profileList[index + 1]);
      });
    }
    else {
      return [ SizedBox.shrink() ];
    }
  }

  Widget _buildProfile(Profile profile, [double radius = 25]){
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProfilePage(profile))
        );
      },
      leading: CircleAvatar(
          backgroundImage: profile.photo == '' ?
            AssetImage('assets/images/Logo.png') : AssetImage(profile.photo),
          radius: radius,
      ),
      title: Text(profile.name),
      visualDensity: VisualDensity(vertical: 1.0),
    );
  }
}