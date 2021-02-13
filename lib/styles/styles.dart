import 'package:flutter/material.dart';

class MyColors {
  final bgColor = const Color(0xfff7f9ff);
  final primary = const Color(0xff7c90d9);
  final success = const Color(0xff5BC266);
  final warning = const Color(0xffFFAD32);
  final danger = const Color(0xffFF3F6D);
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
    fontFamily: 'MarkPro',
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  final textInputContent = const TextStyle(
    fontFamily: 'MarkPro',
    color: Color(0xff2e2e2e),
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  final hint = const TextStyle(
    fontFamily: 'MarkPro',
    color: Color(0xff222222),
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  final appBarTextStyle = const TextStyle(
    color: Colors.white,
  );
}
