import 'package:flutter/material.dart';

import '../../../config/configuration.dart';
import '../../../models/apn.dart';
import '../../../models/country.dart';
import '../../../styles/styles.dart';
import '../../../widgets/apn/apn_list.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/country/country_list.dart';

class ApnScreen extends StatefulWidget {
  @override
  _ApnScreenState createState() => _ApnScreenState();
}

class _ApnScreenState extends State<ApnScreen> {
  final List<CountryModel> countryList = [];

  List<ApnModel> apnList = [];

  void _getCountryFlag({String countryFlag, String countryName}) {
    setState(() {
      selectedCountryFlag = countryFlag;
      selectedCountryName = countryName;
    });

    Navigator.of(context).pop();
    // call the list of apn
  }

  void _openContryListModal(BuildContext ctx) {
    setState(() {
      apnList = [];
    });
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return CountryList(
            records: countryList,
            callBack: _getCountryFlag,
          );
        }).then((value) {});
  }

  String selectedCountryName;
  String selectedCountryFlag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contactez-nous',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            //Logo(),
            Container(
              child: Text(
                'Pour créer votre compte $appName gratuitement, ayez la liberté de contacter un gestionnaire de votre choix qui vous communiquera son code d\'invitation',
                style: MyStyles().paragraph,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CustomCard(
              content: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Sélectionnez un pays',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: selectedCountryName == null
                                ? Text('')
                                : Image.network(
                                    '$flagUrl/${selectedCountryFlag.toLowerCase()}.png',
                                    height: 50,
                                  ),
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              //color: Colors.white,
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 30,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _openContryListModal(context);
                            },
                            child: Container(
                              child: selectedCountryName == null
                                  ? Text('Cliquez ici')
                                  : Text(
                                      selectedCountryName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MyColors().primary,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            selectedCountryFlag != null ? ApnList(records: apnList) : Text(''),
          ],
        ),
      ),
    );
  }
}
