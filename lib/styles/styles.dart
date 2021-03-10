import 'package:flutter/material.dart';

class MyColors {
  final bgColor = const Color(0xff075c45);
  final primary = const Color(0xffedfff7);
  final success = const Color(0xff5BC266);
  final warning = const Color(0xffFFAD32);
  final danger = const Color(0xfff23d3d);
  final info = const Color(0xff5A73CB);
  final normal = const Color(0xff676767);
  final white = const Color(0xfffcfffd);
  final primary2 = Color(0xffD6DAFF);
  final cardBackgroundColor = Color(0xff5A73CB).withOpacity(0.18);
}

class MyFontFamily {
  final family1 = 'Aeonik';
  final family2 = 'MarkPro';
  final family3 = 'Aduma';
  final family4 = 'Brandon';
  final family5 = 'MiniSystem';
}

class MyStyles {
  final paragraph = TextStyle(
    fontSize: 16,
    fontFamily: 'MarkPro',
    color: Colors.black.withOpacity(0.9),
    height: 1.3,
  );

  final header = TextStyle(
    fontSize: 25,
    fontFamily: 'Aeonik',
    color: MyColors().primary,
  );

  final buttonTextStyle = const TextStyle(
    color: Colors.white,
  );

  final textInputLabel = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Aeonik',
  );

  final textInputContent = const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'Aeonik',
  );

  final hint = const TextStyle(
    color: Color(0xffffffff),
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  final appBarTextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 19,
  );
}
