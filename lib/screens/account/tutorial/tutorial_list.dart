import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../models/tutorial.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../screens/account/tutorial/tutorial_play.dart';

class TutorialList extends StatelessWidget {
  final TutorialModel tutorial;
  TutorialList({this.tutorial});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          CubePageRoute(
            enterPage: TutorialPlayScreen(tutorial: tutorial),
            exitPage: TutorialPlayScreen(tutorial: tutorial),
            duration: const Duration(milliseconds: 300),
          ),
        );
      },
      splashColor: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              tutorial.title,
              style: TextStyle(
                fontSize: 16,
                fontFamily: MyFontFamily().family2,
                fontWeight: FontWeight.bold,
                color: MyColors().primary,
              ),
            ),
          ),
          CustomHorizontalDiver(),
        ],
      ),
    );
  }
}
