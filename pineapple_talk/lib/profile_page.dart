import 'package:flutter/material.dart';
import 'package:pineapple_talk/profile.dart';

class ProfilePage extends StatelessWidget {
  Profile profile = Profile('', '', '');
  ProfilePage(this.profile, {Key? key}) : super(key: key);

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
      extendBodyBehindAppBar: true,
      body: Container(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
            Positioned(
              bottom: 200,
              right: 0,
              left: 0,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  image: DecorationImage(
                    image: profile.photo == '' ?
                      AssetImage('assets/images/Logo.png') : AssetImage(profile.photo),
                    ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 140,
              right: 0,
              left: 0,
              child: Container( // divider
                height: 1,
                width: double.infinity,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}