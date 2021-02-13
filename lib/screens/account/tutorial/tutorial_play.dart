import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/common/custom_alert.dart';
import '../../../models/tutorial.dart';
import '../../../styles/styles.dart';

class TutorialPlayScreen extends StatefulWidget {
  final TutorialModel tutorial;
  TutorialPlayScreen({this.tutorial});

  @override
  _TutorialPlayScreenState createState() => _TutorialPlayScreenState();
}

class _TutorialPlayScreenState extends State<TutorialPlayScreen> {
  bool isLoading = false;

  _downloadPdf() async {
    final url = widget.tutorial.url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        'Nous avons un problème à récupérer le PDF',
        true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tutorial.title,
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
          child: Column(
            children: [
              Text(
                widget.tutorial.transcript,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Cliquez sur l\'icône ci-dessous pour télécharger ce tutoriel en PDF',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  _downloadPdf();
                },
                splashColor: Colors.black26,
                child: Image.asset(
                  'assets/images/icon-pdf.png',
                  height: 80,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
