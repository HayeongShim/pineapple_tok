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
}