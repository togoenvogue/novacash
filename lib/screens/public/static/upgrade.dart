import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/configuration.dart';
import '../../../widgets/common/logo.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../styles/styles.dart';

class UpgradeScreen extends StatefulWidget {
  final String oldVersion;
  final String newVersion;
  final String url;
  final String message;

  UpgradeScreen({
    this.message,
    this.url,
    this.oldVersion,
    this.newVersion,
  });
  @override
  _UpgradeScreenState createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  _launchURL() async {
    if (await canLaunch(widget.url)) {
      await launch(widget.url);
    } else {
      throw 'Could not launch $widget.url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Logo(),
              SizedBox(height: 14),
              Image.asset(
                'assets/images/icon-update.png',
                height: 50,
              ),
              Text(
                'Nouvelle version $appName',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: MyColors().primary,
                  fontSize: 16,
                ),
              ),
              Text(
                'v${widget.newVersion}',
                style: TextStyle(
                  color: MyColors().primary,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                widget.message,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(height: 9),
              CustomFlatButtonRounded(
                label: 'Télécharger ${widget.newVersion}',
                borderRadius: 50,
                function: _launchURL,
                borderColor: Colors.transparent,
                bgColor: Colors.green.withOpacity(0.3),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
