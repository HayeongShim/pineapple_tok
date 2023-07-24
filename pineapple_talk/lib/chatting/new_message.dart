import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  final String chatRoomId;
  NewMessage({required this.chatRoomId});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var _userEnterMessage = '';
  final _controller = TextEditingController();

  void _sendMessage() {
    FocusScope.of(context).unfocus();

    _firestore.collection('chatting')
      .doc('chatroom').collection(widget.chatRoomId)
      .doc('chat').collection('messages').add({
      'id': _authentication.currentUser!.uid,
      'message': _userEnterMessage,
      'time': DateTime.now().toString(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
              ),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              }
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.green)
        ],
      )
    );
  }   
}   