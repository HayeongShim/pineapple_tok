import 'package:flutter/material.dart';
import 'package:pineapple_talk/login/account.dart';
import 'package:pineapple_talk/chatting/chatting_room_page.dart';
import 'package:pineapple_talk/chatting/chatting_info.dart';

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
  bool isDataLoading = true;
  List<ChattingInfo>? _chattingInfo = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    ChattingInfoHandler chattingInfoHandler = ChattingInfoHandler();
    _chattingInfo = await chattingInfoHandler.getChattingInfoList();
    
    setState(() { isDataLoading = false; });

    if (_chattingInfo!.length > 1) {
      List<ChattingInfo> tempList = _chattingInfo!;
      tempList.sort((a, b) => a.latestChatTime.compareTo(b.latestChatTime));
      _chattingInfo = tempList;
    }
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
            Expanded(
              child: ListView(
                children: _buildChattingList(context),
              ),
            ),
          ],
        ),
      );
    }
  }

  List<Widget> _buildChattingList(BuildContext context){
    return List.generate(_chattingInfo!.length, (index) {
      _chattingInfo!.sort((a, b) => b.latestChatTime.compareTo(a.latestChatTime));
      return _buildProfile(_chattingInfo![index]);
    });
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
      trailing: Text(chattingInfo.getStrTimeToPrint()),
      visualDensity: VisualDensity(vertical: 1.0),
    );
  }
}

