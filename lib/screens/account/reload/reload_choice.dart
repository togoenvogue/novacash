import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../screens/account/reload/reload_ewallet.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../screens/account/reload/reload_crypto.dart';
import '../../../screens/account/reload/reload_mobile.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';

class ReloadChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Effectuer un dépôt',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'Cliquez sur le cannal le plus adapté pour effectuer un dépôt sur votre compte',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              /*Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                child: CustomFlatButtonRounded(
                  label: 'Nova Tokens',
                  borderRadius: 50,
                  function: () {
                    Navigator.of(context).push(
                      CubePageRoute(
                        enterPage: ReloadEwalletScreen(),
                        exitPage: ReloadEwalletScreen(),
                        duration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  bgColor: MyColors().primary,
                  textColor: MyColors().white,
                  //borderColor: MyColors().primary,
                ),
              ),
              SizedBox(height: 10),*/
              CustomHorizontalDiver(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_moov_africa.png',
                    height: 40,
                  ),
                  SizedBox(width: 15),
                  Image.asset(
                    'assets/images/logo_orange_money.png',
                    height: 40,
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: CustomFlatButtonRounded(
                  label: 'Mobile Money',
                  borderRadius: 50,
                  function: () {
                    Navigator.of(context).push(
                      CubePageRoute(
                        enterPage: ReloadMobileScreen(),
                        exitPage: ReloadMobileScreen(),
                        duration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  bgColor: MyColors().warning,
                  textColor: MyColors().white,
                  //borderColor: MyColors().primary,
                ),
              ),
              SizedBox(height: 10),
              CustomHorizontalDiver(),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_bitcoin.png',
                    height: 45,
                  ),
                  Image.asset(
                    'assets/images/logo_ethereum.png',
                    height: 45,
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: CustomFlatButtonRounded(
                  label: 'Crypto (BTC, ETH)',
                  borderRadius: 50,
                  function: () {
                    Navigator.of(context).push(
                      CubePageRoute(
                        enterPage: ReloadCryptoScreen(),
                        exitPage: ReloadCryptoScreen(),
                        duration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  bgColor: MyColors().normal,
                  textColor: Colors.white,
                  //borderColor: MyColors().primary,
                ),
              ),
              SizedBox(height: 10),
              CustomHorizontalDiver(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icon_ewallet.png',
                    height: 45,
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: CustomFlatButtonRounded(
                  label: 'Avec mes gains',
                  borderRadius: 50,
                  function: () {
                    Navigator.of(context).push(
                      CubePageRoute(
                        enterPage: ReloadEwalletScreen(),
                        exitPage: ReloadEwalletScreen(),
                        duration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  bgColor: MyColors().success,
                  textColor: MyColors().white,
                  //borderColor: MyColors().primary,
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
