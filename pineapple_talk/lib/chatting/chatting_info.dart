import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:tuple/tuple.dart';

class ChattingInfo {
  String id = '';
  String title = '';
  String latestChat = '';
  String latestChatTime = '';
  List<String> participants = [];

  ChattingInfo(this.id, this.title, this.latestChat, this.latestChatTime, this.participants);

  String getStrTimeToPrint() {
    int currentDay = DateTime.now().day;
    int currentYear = DateTime.now().year;

    int targetDay = DateTime.parse(latestChatTime).day;
    int targetMonth = DateTime.parse(latestChatTime).month;
    int targetYear = DateTime.parse(latestChatTime).year;

    if (currentDay == targetDay) {
      return latestChatTime.substring(11, 16);
    }
    else if (currentDay - targetDay == 1) {
      return '어제';
    }
    else if (currentYear == targetYear) {
      return targetMonth.toString() + '월 ' + targetDay.toString() + '일';
    }
    return targetYear.toString() + '. ' + targetMonth.toString() + '. ' + targetDay.toString() + '.';
  }
}

class ChattingInfoHandler {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  
  Future<List<ChattingInfo>?> getChattingInfoList() async {
    List<ChattingInfo> chattingInfoList = [];

    // get my chatroom list
    final curUser = _authentication.currentUser;
    final docRef = _firestore.collection('user').doc('profile').collection(curUser!.uid).doc('data');
    final doc = await docRef.get();
    List<dynamic> chatrooms = List.from(doc['chatroom']);

    for (var chatroom in chatrooms)
    {
      final chattingRef = _firestore.collection('chatting').doc('chatroom').collection(chatroom).doc('info');
      final chatting = await chattingRef.get();
      if (!chatting.exists) {
        continue;
      }

      var lastChat = await getLastChat(chatroom);
      List<String> member = List.from(chatting['member']);

      chattingInfoList.add(ChattingInfo(chatroom, chatting['title'], lastChat.item1, lastChat.item2, member));
    }

    return chattingInfoList;
    
  }

  Future<Tuple2<String, String>> getLastChat(String chatroom) async {
    final chatRef = _firestore.collection('chatting').doc('chatroom').collection(chatroom).doc('chat')
                              .collection('messages').orderBy('time', descending: true);
    final chat = await chatRef.get();
    final lastChat = chat.docs[0];
    return Tuple2<String, String>(lastChat['message'], lastChat['time']);  
  }
}