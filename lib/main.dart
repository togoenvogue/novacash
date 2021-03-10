import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/configuration.dart';
import 'screens/public/home/home.dart';
import 'styles/styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blueGrey;
    return MaterialApp(
      title: '$appName',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: MyFontFamily().family1,
        backgroundColor: MyColors().bgColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: themeColor,
        brightness: Brightness.dark,
      ).copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: themeColor,
        ),
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('fr')],
    );
  }
}
