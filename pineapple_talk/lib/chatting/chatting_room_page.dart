import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pineapple_talk/chatting/chatting_info.dart';
import 'package:pineapple_talk/login/account.dart';
import 'package:pineapple_talk/friends/profile.dart';
import 'dart:convert';

class ChattingRoomPage extends StatelessWidget {
  Account myAccount = Account();
  ChattingInfo chattingInfo = ChattingInfo(-1, '', '', '', []);

  ChattingRoomPage(this.myAccount, this.chattingInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chattingInfo.title),
        backgroundColor: Colors.green.shade100,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ChatBubbles(chattingInfo, myAccount),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble {
  int id = -1;
  String name = '';
  String photo = '';
  String message = '';
  String chatTime = '';

  ChatBubble(this.id, this.name, this.photo, this.message, this.chatTime);
}

class ChatBubbles extends StatefulWidget {
  ChatBubbles(this.chattingInfo, this.myAccount, {Key? key}) : super(key: key);

  Account myAccount = Account();
  ChattingInfo chattingInfo = ChattingInfo(-1, '', '', '', []);

  @override
  _ChatBubblesState createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  List<ChatBubble> _chatBubble = [];

  @override
  void initState() {
    super.initState();
    _readJson();
  }

  void _readJson() async {
    List<Profile> participants = await _readProfileListJson(widget.chattingInfo.participants);
    
    int chatRoomId = widget.chattingInfo.id;
    _chatBubble = await _readChatBubbleJson(chatRoomId, participants);

    setState(() {});
  }

  Future<List<Profile>> _readProfileListJson(List<int> participants) async {
    final String response = await rootBundle.loadString('assets/json/profile_list.json');
    final data = await json.decode(response);
    List<Profile> profileList = [];

    for (var id in participants){
      for (var list in data['profile_list']){
        if (id == list['id']){
          profileList.add(Profile(list['id'], list['name'], list['photo']));
          break;
        }
      }
    }
    return profileList;
  }

  Future<List<ChatBubble>> _readChatBubbleJson(int chatRoomId, List<Profile> participants) async {
    final String chattingMsgDataRsp = await rootBundle.loadString('assets/json/chatting_message.json');
    final chattingMsgData = await json.decode(chattingMsgDataRsp);

    List<ChatBubble> chatBubble = [];

    for (var list in chattingMsgData['chatting_message']) {
      if (list['id'] == chatRoomId) {
        for (var l in list['messages']) {
          // TBD - refactoring (remove for loop)
          String name = '';
          String photo = '';
          for (var p in participants) {
            if (p.id == l['id']) {
              name = p.name;
              photo = p.photo;
            }
          }
          chatBubble.add(ChatBubble(l['id'], name, photo, l['message'], l['time']));
        }
      }
    }
    return chatBubble;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: _buildChatBubbles(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChatBubbles(BuildContext context){
    if (_chatBubble.isNotEmpty) {
      return List.generate(_chatBubble.length, (index) {
        if (_chatBubble[index].id == widget.myAccount.id) {
          return _buildChatBubble(_chatBubble[index], true);
        }
        else {
          return _buildChatBubble(_chatBubble[index], false);
        }
      });
    }
    else {
      return [ CircularProgressIndicator() ];
    }
  }

  // TBD - refactoring
  Widget _buildChatBubble(ChatBubble chatBubble, bool isMyChat){
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: isMyChat ? null :      
          chatBubble.photo == '' ?
            AssetImage('assets/images/Logo.png') : AssetImage(chatBubble.photo),
          radius: 25,
      ),
      title: isMyChat ? null : Text(chatBubble.name),
      subtitle: Container (
        decoration: BoxDecoration(
          color: Colors.yellow.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        width: 50,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          chatBubble.message,
          //style: TextStyle
        )
      ),
      trailing: Text(DateTime.parse(chatBubble.chatTime).hour.toString() + '시 ' +
                     DateTime.parse(chatBubble.chatTime).minute.toString() + '분'),
      visualDensity: VisualDensity(vertical: 1.0),
    );
  }
}