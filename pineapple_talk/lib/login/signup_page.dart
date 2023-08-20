import 'package:flutter/material.dart';
import 'package:pineapple_talk/login/account.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container (  
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SignUpScreen(),
        )
      )
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  Account account = Account();
  
  bool _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if (isValid){
      _formKey.currentState!.save();
    }
    return isValid;
  }

  Future<bool> _signup(BuildContext context, Account account) async {
    bool isValid = await account.signup();
    print ("kkkkk");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Form (
          key: _formKey,
          child: Column (
            children: [
              SizedBox(height: 100.0),
              Text(
                '회원가입',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.green,
                )
              ),
              SizedBox(height: 30.0),
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
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                key: ValueKey(2),
                validator: (value){
                  if (value!.isEmpty){
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                onSaved: (value){
                  account.name = value!;
                },
                decoration: InputDecoration(
                  filled: false,
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                key: ValueKey(3),
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
              ElevatedButton(
                onPressed: () async {
                  if (!_tryValidation()) return;
                  _signup(context, account);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('확인'),
              ),
            ]
          )
        ),
      ),
    );
  }
}