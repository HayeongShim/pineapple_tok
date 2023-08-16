import 'package:flutter/material.dart';
import 'package:pineapple_talk/main/main_page.dart';
import 'package:pineapple_talk/login/account.dart';

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
  Account account = Account();

  bool _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if (isValid){
      _formKey.currentState!.save();
    }
    return isValid;
  }

  Future<bool> _login(BuildContext context, Account account) async {
    bool isValid = await account.checkValidity();

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('invalid account')),
      );
      return false;
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage(account,)),
      );
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  account.email = value!;
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
                  account.pw = value!;
                },
                decoration: InputDecoration(
                  filled: false,
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_tryValidation()) return;
                        _login(context, account);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('LOG IN'),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('SIGN UP'),
                    ),
                  ),
                ]
              )
            ],
          ),
        ),
      ]
    );
  }
}