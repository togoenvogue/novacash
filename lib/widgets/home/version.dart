import 'package:flutter/material.dart';
import '../../models/config.dart';
import '../../styles/styles.dart';
import '../../widgets/common/custom_alert.dart';

class AppVersion extends StatelessWidget {
  final AppConfigModel app;
  final String internalVersion;
  AppVersion({
    this.app,
    this.internalVersion,
  });

  @override
  Widget build(BuildContext context) {
    final String version = 'v${app.version_current}';
    final String appBy = '${app.company}';
    final String appByDetails = """${app.desc}

Email: ${app.email}
WhatsApp: ${app.phone1}""";

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                version,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: MyFontFamily().family3,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  CustomAlert(
                    colorBg: MyColors().bgColor,
                    colorText: Colors.white.withOpacity(0.9),
                    titleStyle: TextStyle(
                      fontFamily: MyFontFamily().family2,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ).alert(
                    context,
                    appBy,
                    appByDetails,
                    true,
                  );
                },
                child: Text(
                  appBy,
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: MyFontFamily().family3,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
