import 'package:flutter/material.dart';
import '../../components/drawer/drawer_list.dart';
import '../../models/user.dart';

class MainDrawer extends StatelessWidget {
  final UserModel userObj;
  MainDrawer({this.userObj});

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        Container(
          child: Column(
            
            children: [
              SizedBox(height: 30),
              Image.asset(
                'assets/images/novabets_logo.png',
                height: 70,
              ),
              SizedBox(height: 10)
              /*  UserProfilePicture(
                avatar: userObj.picture,
                height: 80,
                width: 80,
              ),
              Text(
                userObj.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: MyFontFamily().family2,
                  fontSize: 11,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
               if (userObj.isSupport == true) SizedBox(height: 4),
               if (userObj.isSupport)
                Text(
                  'Vous êtes pronostiqueur',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: MyFontFamily().family2,
                  ),
                ),
              SizedBox(height: 10),*/
            ],
          ),
          width: double.infinity,
        ),
        SizedBox(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: DrawerList(userObj: userObj),
        ),
      ],
    );
  }
}
