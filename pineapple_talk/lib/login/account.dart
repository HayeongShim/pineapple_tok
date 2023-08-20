import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account {
  final _authentication = FirebaseAuth.instance;

  String email = '';
  int    id = -1;
  String pw = '';
  String name = '';

  Future<bool> checkValidity() async {
    try {
      final account = await _authentication.signInWithEmailAndPassword(
        email: email,
        password: pw,
      );

      if (account.user != null) {
        return true;
      }
    }
    catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> signup() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.
        createUserWithEmailAndPassword(email: email, password: pw);

      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('user').doc('profile').
          collection(userCredential.user!.uid).doc('data').set({
            'name': name,
            'photo': '',
          });
      }
    } on FirebaseAuthException catch (e) {
      print (e.message!);
    }

    return false;
  }
}