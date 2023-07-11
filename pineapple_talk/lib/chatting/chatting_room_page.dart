import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pineapple_talk/chatting/chatting_info.dart';
import 'package:pineapple_talk/login/account.dart';
import 'package:pineapple_talk/friends/profile.dart';
import 'dart:convert';

class ChattingRoomPage extends StatelessWidget {
  Account myAccount = Account();
  ChattingInfo chattingInfo = ChattingInfo('', '', '', '', []);

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

class ChatBubbleHandler {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<List<ChatBubble>?> getChatBubbleList(String chatRoomId, List<Profile>? memberProfileList) async {
    List<ChatBubble> chatBubble = [];
    
    ProfileHandler profileHandler = ProfileHandler();

    // get messages
    final messageRef = _firestore.collection('chatting').doc('chatroom').collection(chatRoomId).doc('chat')
                                 .collection('messages');
    final message = await messageRef.get();
    
    for (int i = 0; i < message.size; i++) {
      final messageInfo = message.docs[i];
      var profile = await profileHandler.getProfileById(messageInfo['id']);
      chatBubble.add(ChatBubble(0, profile.item1, profile.item2, messageInfo['message'], messageInfo['time']));
    }

    return chatBubble;
  }
}

class ChatBubbles extends StatefulWidget {
  ChatBubbles(this.chattingInfo, this.myAccount, {Key? key}) : super(key: key);

  Account myAccount = Account();
  ChattingInfo chattingInfo = ChattingInfo('', '', '', '', []);

  @override
  _ChatBubblesState createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  bool isDataLoading = true;
  List<Profile>? _profileList = [];
  List<ChatBubble>? _chatBubble = [];

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  void _loadJson() async {
    String chatRoomId = widget.chattingInfo.id;

    ProfileHandler profileHandler = ProfileHandler();
    _profileList = await profileHandler.getMemberProfileList(chatRoomId);

    ChatBubbleHandler chatBubbleHandler = ChatBubbleHandler();
    _chatBubble = await chatBubbleHandler.getChatBubbleList(chatRoomId, _profileList);

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
            Expanded(
              child: ListView(
                children: _buildChatBubbles(context),
              ),
            ),
          ],
        ),
      );
    }
  }

  List<Widget> _buildChatBubbles(BuildContext context){
    if (_chatBubble!.isNotEmpty) {
      return List.generate(_chatBubble!.length, (index) {
        if (_chatBubble![index].id == widget.myAccount.id) {
          return _buildChatBubble(_chatBubble![index], true);
        }
        else {
          return _buildChatBubble(_chatBubble![index], false);
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