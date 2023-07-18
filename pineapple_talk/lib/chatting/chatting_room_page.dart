import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pineapple_talk/chatting/chatting_info.dart';
import 'package:pineapple_talk/friends/profile.dart';

class ChattingRoomPage extends StatelessWidget {
  ChattingInfo chattingInfo = ChattingInfo('', '', '', '', []);

  ChattingRoomPage(this.chattingInfo, {Key? key}) : super(key: key);

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
              child: ChatBubbles(chattingInfo),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble {
  String id = '';
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
    
    for (var msg in message.docs)
    {
      var profile = await profileHandler.getProfileById(msg['id']);
      chatBubble.add(ChatBubble(msg['id'], profile.item1, profile.item2, msg['message'], msg['time']));
    }

    return chatBubble;
  }

  Widget buildMyChatBubble(ChatBubble chatBubble) {
    return ListTile(
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\n' + DateTime.parse(chatBubble.chatTime).hour.toString() + '시 ' +
            DateTime.parse(chatBubble.chatTime).minute.toString() + '분',
            style: TextStyle(fontSize: 12)
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                chatBubble.message,
                softWrap: true,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
      visualDensity: VisualDensity(vertical: 1.0),
    );
  }

  Widget buildFriendsChatBubble(ChatBubble chatBubble) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: chatBubble.photo == '' ?
          AssetImage('assets/images/Logo.png') : AssetImage(chatBubble.photo),
          radius: 25,
      ),
      title: Text(chatBubble.name),
      subtitle: Row (
        children: [
          Flexible (
            child: Container (
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                chatBubble.message,
                softWrap: true,
                textAlign: TextAlign.left,
              )
            )
          ),
          Text (
            '\n' + DateTime.parse(chatBubble.chatTime).hour.toString() + '시 ' +
            DateTime.parse(chatBubble.chatTime).minute.toString() + '분',
            style: TextStyle(fontSize: 12)
          ),
        ]
      ),
      visualDensity: VisualDensity(vertical: 1.0),
    );
  }

  Widget buildChatBubble(ChatBubble chatBubble) {
    final curUser = _authentication.currentUser;
    
    if (chatBubble.id == curUser!.uid) {
      return buildMyChatBubble(chatBubble);
    }
    else {
      return buildFriendsChatBubble(chatBubble);
    }
  }
}

class ChatBubbles extends StatefulWidget {
  ChatBubbles(this.chattingInfo, {Key? key}) : super(key: key);

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
        ChatBubbleHandler chatBubbleHandler = ChatBubbleHandler();
        return chatBubbleHandler.buildChatBubble(_chatBubble![index]);
      });
    }
    else {
      return [ CircularProgressIndicator() ];
    }
  }
}