import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:tuple/tuple.dart';

class Profile {
  int id = -1;
  String name = '';
  String photo = '';

  Profile(this.id, this.name, this.photo);
}

class ProfileHandler {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Profile> getProfile(String id) async {
    final docRef = _firestore.collection('user').doc('profile').collection(id).doc('data');
    final doc = await docRef.get();
    return Profile(0, doc['name'], doc['photo']);
  }

  Future<List<Profile>?> getFriendProfileList() async {
    List<Profile> profileList = [];

    // get my profile
    final curUser = _authentication.currentUser;
    profileList.add(await getProfile(curUser!.uid));

    // get my friends  
    final myProfile = _firestore.collection('user').doc('profile').collection(curUser.uid).doc('data');
    final myProfileDoc = await myProfile.get();

    // get my friends' profile
    List<dynamic> friends = List.from(myProfileDoc['friends']);
    for (var element in friends) {
      profileList.add(await getProfile(element));
    }

    return profileList;
  }

  Future<List<Profile>?> getMemberProfileList(String chatRoomId) async {
    List<Profile> memberProfileList = [];

    // get member id
    final chattingRef = _firestore.collection('chatting').doc('chatroom').collection(chatRoomId).doc('info');
    final chatting = await chattingRef.get();

    // get members' profile
    List<String> members = List.from(chatting['member']);
    for (var member in members) {
      memberProfileList.add(await getProfile(member));
    }

    return memberProfileList;
  }

  Future<Tuple2<String, String>> getProfileById(String id) async {
    final profileRef = _firestore.collection('user').doc('profile').collection(id).doc('data');
    final profile = await profileRef.get();
    return Tuple2<String, String>(profile['name'], profile['photo']);
  }
}