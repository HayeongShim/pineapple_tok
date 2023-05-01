import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:pineapple_talk/friends_page.dart';
import 'package:pineapple_talk/account.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: MainScreen(),
      )
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 150.0),
              Image.asset('assets/images/Logo.png', height: 130),
              Text(
                'Fine Apple',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.green,
                )
              ),
              SizedBox(height: 30.0),
              LoginForm(),
            ]
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  List _accounts = [];
  Account myAccount = Account();

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/account_list.json');
    final data = await json.decode(response);
    setState(() {
      _accounts = data["account_list"];
    });
  }

  bool _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if (isValid){
      _formKey.currentState!.save();
    }
    return isValid;
  }

  bool _login() {
    for (var account in _accounts){
      if (account['id'] == myAccount.id && account['pw'] == myAccount.pw){
        myAccount.name = account['name'];
        myAccount.idx = account['idx'];
        return true;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('invalid account')),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: ValueKey(1),
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if (value!.isEmpty || !value.contains('@')){
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value){
                  myAccount.id = value!;
                },
                decoration: InputDecoration(
                  filled: false,
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                key: ValueKey(2),
                validator: (value){
                  if (value!.isEmpty || value.length < 6){
                    return 'Please enter at least 6 characters';
                  }
                  return null;
                },
                onSaved: (value){
                  myAccount.pw = value!;
                },
                decoration: InputDecoration(
                  filled: false,
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        Positioned(
          child: Column(
            children: [
              SizedBox(height: 200.0),
              ElevatedButton(
                onPressed: () async {
                  if (!_tryValidation()) return;
                  if (!_login()) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendsPage(myAccount)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("LOGIN"),
              ),
            ]
          )
        )
      ]
    );
  }
}