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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.yellow.shade100,
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
            bottom: 160,
            right: 0,
            left: 0,
            child: Text(profile.name,
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
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
          Positioned(
            bottom: 45,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                profileIconButton(Icon(Icons.chat_bubble)),
                profileIconButton(Icon(Icons.call)),
                profileIconButton(Icon(Icons.video_call)),
              ]
            )
          )
        ],
      ),
    );
  }
}

Widget profileIconButton(Icon icon) {
  return IconButton(
    iconSize: 50,
    icon: icon,
    color: Colors.black,
    onPressed: (){},
  );
}