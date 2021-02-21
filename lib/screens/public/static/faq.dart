import 'package:flutter/material.dart';
 
import '../../../models/config.dart';
import '../../../config/configuration.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_faq.dart';

class FaqScreen extends StatelessWidget {
  final AppConfigModel app;
  FaqScreen({this.app});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questions Fréquentes',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: app != null
                ? Column(
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/icon-faq.png',
                          //fit: BoxFit.cover,
                        ),
                        //decoration: BoxDecoration(color: Colors.green),
                        height: 120,
                        //width: double.infinity,
                      ),
                      SizedBox(height: 8),
                      CustomFaq(
                        question: 'Qu\'est-ce que $appName?',
                        response:
                            '$appName est la réponse à tous vos besoins de pari en ligne en Afrique et partout dans le monde (PMU, FOOTBALL, JACKPOT ...)',
                      ),
                    ],
                  )
                : Text('...loading'),
          ),
        ),
      ),
    );
  }
}
