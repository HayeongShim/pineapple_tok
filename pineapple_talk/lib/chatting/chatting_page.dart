import 'package:flutter/material.dart';
import 'package:pineapple_talk/login/account.dart';
import 'package:pineapple_talk/chatting/chatting_room_page.dart';
import 'package:pineapple_talk/chatting/chatting_info.dart';
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

class ChattingListState extends State<ChattingList> {
  List<ChattingInfo> _chattingInfo = [];

  @override
  void initState() {
    super.initState();
    _readJson();
  }

  void _readJson() async {
    int myId = widget.myAccount.id;
    _chattingInfo = await _readChattingInfoJson(myId);
    setState(() {});
  }

  Future<List<ChattingInfo>> _readChattingInfoJson(int myId) async {
    final String response = await rootBundle.loadString('assets/json/chatting_list.json');
    final data = await json.decode(response);
    List<ChattingInfo> chattingInfo = [];

    for (var list in data['chatting_list']) {
      if (list['participants'].contains(myId)) {
        chattingInfo.add(ChattingInfo(
          list['id'],
          list['title'],
          list['latest_chat'],
          list['latest_chat_time'],
          List<int>.from(list['participants']))
        );
      }
    }
    return chattingInfo;
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
    if (_chattingInfo.isNotEmpty) {
      return List.generate(_chattingInfo.length, (index) {
        _chattingInfo.sort((a, b) => b.latestChatTime.compareTo(a.latestChatTime));
        return _buildProfile(_chattingInfo[index]);
      });
    }
    else {
      return [ CircularProgressIndicator() ];
    }
  }

  Widget _buildProfile(ChattingInfo chattingInfo, [double radius = 25]){
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChattingRoomPage(widget.myAccount, chattingInfo))
        );
      },
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/Logo.png'),
        radius: radius,
      ),
      title: Text(chattingInfo.title),
      subtitle: Text(chattingInfo.latestChat),
      trailing: Text(getStrTimeToPrint(chattingInfo.latestChatTime)),
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