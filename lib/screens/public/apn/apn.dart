import 'package:flutter/material.dart';

import '../../../services/apn.dart';
import '../../../services/country.dart';
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
  List<CountryModel> countryList = [];
  bool isLoading = false;

  List<ApnModel> apnList = [];
  String selectedCountryName;
  String selectedCountryFlag;

  void _getCountries() async {
    setState(() {
      isLoading = true;
    });
    var result = await CountryService().getApnCountries();
    setState(() {
      isLoading = false;
    });
    if (result != null && result[0].error != 'No data') {
      setState(() {
        countryList = result;
      });
    } else {
      setState(() {
        countryList = [];
      });
    }
  }

  void _getApns(String countryFlag) async {
    setState(() {
      isLoading = true;
    });

    var result = await ApnService().getApns(flag: countryFlag);
    setState(() {
      isLoading = false;
    });
    if (result != null && result[0].error != 'No data') {
      setState(() {
        apnList = result;
      });
    } else {
      setState(() {
        apnList = [];
      });
    }
  }

  void _getCountryFlag({String countryFlag, String countryName}) {
    setState(() {
      selectedCountryFlag = countryFlag;
      selectedCountryName = countryName;
    });

    _getApns(countryFlag);
    Navigator.of(context).pop();
    // call the list of apn
  }

  void _openContryListModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return CountryList(
            records: countryList,
            callBack: _getCountryFlag,
          );
        }).then((value) {});
  }

  @override
  void initState() {
    super.initState();
    _getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nos points focaux',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'assets/images/icon-location.png',
              ),
              //decoration: BoxDecoration(color: Colors.green),
              height: 50,
              //width: double.infinity,
            ),
            SizedBox(
              height: 10,
            ),
            //Logo(),
            Text(
              'Pour acheter un Token (Code d\'activation), prenez contact avec l\'un de nos points focaux',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            Text(
              'Important: Pour un Token de 5 000F ou 7 000F, vous devez ajouter les frais de 500F',
              style: TextStyle(
                color: Color(0xffd4f7a6),
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
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
                            fontWeight: FontWeight.normal,
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
                                : InkWell(
                                    onTap: () {
                                      _openContryListModal(context);
                                    },
                                    child: Image.network(
                                      '$flagUrl/${selectedCountryFlag.toLowerCase()}.png',
                                      height: 50,
                                    ),
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
                                      '$selectedCountryName',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
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

            selectedCountryName != null
                ? Container(
                    height: MediaQuery.of(context).size.height - 425,
                    child: ApnList(
                      records: apnList,
                      countryName: selectedCountryName,
                    ),
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }
}
