import 'package:flutter/material.dart';

class UserProfilePicture extends StatelessWidget {
  final double height;
  final double width;
  final String avatar;
  UserProfilePicture({this.height, this.width, this.avatar});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
      child: FadeInImage(
        placeholder: AssetImage('assets/images/placeholder.png'),
        image: NetworkImage(avatar) == null
            ? Image.asset('assets/images/placeholder.png')
            : NetworkImage(avatar),
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
    );
  }
}
