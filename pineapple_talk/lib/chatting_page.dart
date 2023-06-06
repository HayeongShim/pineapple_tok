import 'package:flutter/material.dart';
import 'package:pineapple_talk/account.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class ChattingPage extends StatelessWidget {
  Account myAccount = Account();
  ChattingPage(this.myAccount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '채팅',
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
              child: ChattingList(myAccount,),
            ),
          ],
        ),
      ),
    );
  }
}

class ChattingList extends StatefulWidget {
  ChattingList(this.myAccount, {Key? key}) : super(key: key);
  Account myAccount = Account();

  @override
  ChattingListState createState() => ChattingListState();
}

class ChattingListInfo {
  int id = -1;
  String title = '';
  String latestChat = '';
  String latestChatTime = '';
  var participants = [];

  ChattingListInfo(this.id, this.title, this.latestChat, this.latestChatTime, this.participants);
}

class ChattingListState extends State<ChattingList> {
  List<ChattingListInfo> _chattingListInfo = [];

  @override
  void initState() {
    super.initState();
    _readJson();
  }

  void _readJson() async {
    String myIdx = widget.myAccount.idx;
    _chattingListInfo = await _readChattingListInfoJson(myIdx);
    
    /*if (_profileList.length > 1) {
      List<Profile> tempList = _profileList.sublist(1);
      tempList.sort((a, b) => a.name.compareTo(b.name)); // 오름차순 정렬
      _profileList = _profileList.sublist(0, 1); // TBD - range check
      _profileList.addAll(tempList);
    }*/

    setState(() {});
  }

  Future<List<ChattingListInfo>> _readChattingListInfoJson(String myIdx) async {
    final String response = await rootBundle.loadString('assets/json/chatting_list.json');
    final data = await json.decode(response);
    List<ChattingListInfo> chattingListInfo = [];

    for (var list in data["chatting_list"]) {
      if (list['participants'].contains(myIdx)) {
        chattingListInfo.add(ChattingListInfo(
          list['id'],
          list['title'],
          list['latest_chat'],
          list['latest_chat_time'],
          list['participants'])
        );
      }
    }
    return chattingListInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: _buildChattingList(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChattingList(BuildContext context){
    if (_chattingListInfo.isNotEmpty) {
      return List.generate(_chattingListInfo.length, (index) {
        return _buildProfile(_chattingListInfo[index]);
      });
    }
    else {
      return [ CircularProgressIndicator() ];
    }
  }

  Widget _buildProfile(ChattingListInfo chattingListInfo, [double radius = 25]){
    return ListTile(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(
        //  builder: (context) => ProfilePage(profile))
        //);
      },
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/Logo.png'),
        radius: radius,
      ),
      title: Text(chattingListInfo.title),
      visualDensity: VisualDensity(vertical: 1.0),
    );
  }
}