import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';
import '../../styles/styles.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../config/configuration.dart';

class CustomAlert {
  final TextStyle titleStyle;
  @required
  final Color colorBg;
  @required
  final Color colorText;

  //final Widget icon;

  CustomAlert({
    //this.icon,
    this.titleStyle,
    this.colorBg,
    this.colorText,
  });

  alert(BuildContext context, String title, String message, bool showOK) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff).withOpacity(0.8),
          ),
          child: AlertDialog(
            contentPadding: EdgeInsets.only(
              top: 5.0,
              left: 25.0,
              right: 25.0,
              bottom: 5.0,
            ),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
              side: BorderSide(
                width: 0,
                color: colorBg,
              ),
            ),
            backgroundColor: colorBg,
            title: Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            titlePadding: EdgeInsets.only(
              top: 15.0,
              bottom: 10.0,
              left: 15.0,
              right: 15.0,
            ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 15.0,
                color: colorText,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            actions: <Widget>[
              if (showOK)
                CustomButton(
                  color: Colors.white,
                  buttonRadius: 20.0,
                  text: 'OK',
                  onPressed: () {
                    Navigator.pop(context);
                    //print('should be off');
                  },
                  borderColor: Colors.black.withOpacity(0.2),
                ),
            ],
          ),
        );
      },
    );
  }

  // confirm
  confirm({
    BuildContext context,
    String title,
    Widget content,
    Function confirmFn,
    Function cancelFn,
    String submitText,
    String cancelText,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff).withOpacity(0.8),
          ),
          child: AlertDialog(
            contentPadding: EdgeInsets.only(
              top: 5.0,
              left: 25.0,
              right: 25.0,
              bottom: 5.0,
            ),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
              side: BorderSide(
                width: 0,
                color: Colors.transparent,
              ),
            ),
            title: Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            titlePadding: EdgeInsets.only(
              top: 15.0,
              bottom: 3.0,
              left: 15.0,
              right: 15.0,
            ),
            content: content,
            actions: <Widget>[
              CustomButton(
                color: MyColors().warning,
                buttonRadius: 20.0,
                text: cancelText,
                textStyle: MyStyles().buttonTextStyle,
                onPressed: () {
                  Navigator.pop(context);
                  cancelFn();
                },
              ),
              CustomButton(
                color: MyColors().success,
                buttonRadius: 20.0,
                text: submitText,
                textStyle: MyStyles().buttonTextStyle,
                onPressed: () {
                  Navigator.of(context).pop();
                  confirmFn();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // loading
  loading({
    BuildContext context,
    bool isLoading = false,
    bool dismiss = false,
  }) {
    //print(isLoading);
    /*
    if (!isLoading && dismiss == true) {
      Navigator.pop(context);
    }
    */

    return isLoading
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xff99a9c7).withOpacity(0.5),
                ),
                child: AlertDialog(
                  contentPadding: EdgeInsets.only(
                    top: 5.0,
                    left: 15.0,
                    right: 15.0,
                    bottom: 5.0,
                  ),
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  content: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  actions: <Widget>[
                    if (isLoading)
                      Text(
                        '... Patientez',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: MyFontFamily().family1,
                        ),
                      ),
                  ],
                ),
              );
            },
          )
        : Navigator.pop(context);
  } // end loading

  // updater
  appUpdater(
      {BuildContext context,
      String oldVersion,
      String newVersion,
      String message,
      Function fnc}) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff).withOpacity(0.8),
          ),
          child: AlertDialog(
            contentPadding: EdgeInsets.only(
              top: 5.0,
              left: 25.0,
              right: 25.0,
              bottom: 5.0,
            ),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
              side: BorderSide(
                width: 0,
                color: colorBg,
              ),
            ),
            backgroundColor: colorBg,
            title: Text(
              newVersion,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            titlePadding: EdgeInsets.only(
              top: 15.0,
              bottom: 3.0,
              left: 15.0,
              right: 15.0,
            ),
            content: Container(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/icon-update.png',
                      height: 60,
                    ),
                    Text(
                      'Désinstallez $appName v$oldVersion et installez la nouvelle version $newVersion',
                      style: TextStyle(
                        color: MyColors().primary,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: colorText,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    SizedBox(height: 9),
                    CustomFlatButtonRounded(
                      label: 'Télécharger $newVersion',
                      borderRadius: 50,
                      function: fnc,
                      bgColor: MyColors().primary,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  } // end updater

  // offline
  offline(
      {BuildContext context,
      String oldVersion,
      String newVersion,
      String message,
      Function fnc}) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff).withOpacity(0.8),
          ),
          child: AlertDialog(
            contentPadding: EdgeInsets.only(
              top: 5.0,
              left: 25.0,
              right: 25.0,
              bottom: 5.0,
            ),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
              side: BorderSide(
                width: 0,
                color: colorBg,
              ),
            ),
            backgroundColor: colorBg,
            title: Text(
              newVersion,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            titlePadding: EdgeInsets.only(
              top: 15.0,
              bottom: 3.0,
              left: 15.0,
              right: 15.0,
            ),
            content: Container(
              height: 200,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/icon-update.png',
                      height: 60,
                    ),
                    Text(
                      'Verifiez votre connexion internet',
                      style: TextStyle(
                        color: MyColors().primary,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  } // end offline

}
