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
    int myId = widget.myAccount.id;
    _chattingListInfo = await _readChattingListInfoJson(myId);
    
    /*if (_profileList.length > 1) {
      List<Profile> tempList = _profileList.sublist(1);
      tempList.sort((a, b) => a.name.compareTo(b.name)); // 오름차순 정렬
      _profileList = _profileList.sublist(0, 1); // TBD - range check
      _profileList.addAll(tempList);
    }*/

    setState(() {});
  }

  Future<List<ChattingListInfo>> _readChattingListInfoJson(int myId) async {
    final String response = await rootBundle.loadString('assets/json/chatting_list.json');
    final data = await json.decode(response);
    List<ChattingListInfo> chattingListInfo = [];

    for (var list in data['chatting_list']) {
      if (list['participants'].contains(myId)) {
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
        _chattingListInfo.sort((a, b) => b.latestChatTime.compareTo(a.latestChatTime));
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
      subtitle: Text(chattingListInfo.latestChat),
      trailing: Text(getStrTimeToPrint(chattingListInfo.latestChatTime)),
      visualDensity: VisualDensity(vertical: 1.0),
    );
  }
}

String getStrTimeToPrint(String time) {
  int currentDay = DateTime.now().day;
  int currentYear = DateTime.now().year;

  int targetDay = DateTime.parse(time).day;
  int targetMonth = DateTime.parse(time).month;
  int targetYear = DateTime.parse(time).year;

  if (currentDay == targetDay) {
    return time.substring(11, 16);
  }
  else if (currentDay - targetDay == 1) {
    return '어제';
  }
  else if (currentYear == targetYear) {
    return targetMonth.toString() + '월 ' + targetDay.toString() + '일';
  }
  return targetYear.toString() + '. ' + targetMonth.toString() + '. ' + targetDay.toString() + '.';
}