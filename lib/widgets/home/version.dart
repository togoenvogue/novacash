import 'package:flutter/material.dart';
import '../../models/config.dart';
import '../../styles/styles.dart';
import '../../widgets/common/custom_alert.dart';

class AppVersion extends StatelessWidget {
  final AppConfigModel app;
  AppVersion({
    this.app,
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
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  CustomAlert(
                    colorBg: Colors.white,
                    colorText: Colors.black.withOpacity(0.7),
                    titleStyle: TextStyle(
                      fontFamily: MyFontFamily().family2,
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
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
