import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';

import '../../../models/reload.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/reload.dart';
import '../../../services/user.dart';
import '../../../services/withdraw.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../helpers/common.dart';
import '../../../widgets/common/custom_text_input_leading.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_text_input.dart';
import 'withdrawals.dart';

class WithdrawalAddScreen extends StatefulWidget {
  @override
  _WithdrawalAddScreenState createState() => _WithdrawalAddScreenState();
}

class _WithdrawalAddScreenState extends State<WithdrawalAddScreen> {
  MobileNetworkModel _mobileOperator;
  String _mobileOperatorKey;
  String _mobileAccount;
  dynamic _amount;
  List<MobileNetworkModel> _mobileNetworks = [];
  List<dynamic> _mobileNetworksLabels = [];
  List<dynamic> _mobileNetworksValues = [];
  bool isLoading = false;
  bool _isLocal = false;
  UserModel _thisUser;
  var _selectedChannel;
  dynamic _minimToWithdraw = 3500;
  final dynamic _maximumToWithdraw = 100000;
  String firstName;
  String lastName;
  String city;
  String country;

  void _buildSelectChannel(String value) async {
    setState(() {
      _selectedChannel = value;
    });
    if (value == 'Mobile') {
      setState(() {
        _minimToWithdraw = 3500;
      });
      _getMobileNetowks();
    } else {
      setState(() {
        _minimToWithdraw = 10000;
        _mobileNetworksLabels = [];
        _mobileNetworksValues = [];
      });
    }
  }

  void _getMobileNetowks() async {
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    var result =
        await ReloadService().getMobileNetworks(code: _thisUser.countryCode);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop(); // take off the loading

    if (result != null && result[0].error != 'No data') {
      setState(() {
        _mobileNetworks = result;
        //_mobileNumberLength = result[0].local_number_length;
        for (var item in result) {
          _mobileNetworksLabels.add('${item.name}');
          _mobileNetworksValues.add('${item.key}');
          //print(item.key);
        }
      });
      //print(_mobileNetworksLabels);
    } else if (result != null && result[0].error == 'No data') {
      setState(() {
        _mobileNetworks = [];
      });
      Navigator.of(context).pop();
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Désolé!',
        'Aucun opérateur mobile n\'a été configuré dans votre pays pour traiter les paiements mobiles. Contactez-nous pour assistance',
        true,
      );
    } else {
      setState(() {
        _mobileNetworks = [];
      });
      Navigator.of(context).pop();
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        result[0].error,
        true,
      );
    }
  }

  void _selectedOperator({String key}) {
    setState(() {
      _mobileOperator = _mobileNetworks.firstWhere((op) => op.key == key);
      _mobileOperatorKey = key;
    });
    //print(_mobileOperator.mobile_money_name);
  }

  void _process() async {
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    // submit
    var result = await WithdrawService().withdraw(
      account: _mobileAccount,
      amount: _amount,
      channel: _selectedChannel,
      countryCode: _thisUser.countryCode,
      isLocal: _isLocal,
      userKey: _thisUser.key,
      mobileMoney: _selectedChannel == 'Mobile'
          ? _mobileOperator.mobile_money_name
          : _selectedChannel,
      firstName: firstName,
      lastName: lastName,
      city: city,
      country: country,
    );

    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();

    if (result != null && result.error == null) {
      // success
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Succes!',
        'Votre demande de retrait a été initialisée et sera traitée dans un maximum de 72 heures',
        false,
      );
      setState(() {
        _amount = null;
        _mobileOperator = null;
        _mobileOperatorKey = null;
        _mobileAccount = null;
        _mobileNetworks = [];
        _mobileNetworksLabels = [];
        _mobileNetworksValues = [];
        _thisUser = null;
        _selectedChannel = null;
      });

      // delay, redirect
      await Future.delayed(const Duration(seconds: 5));
      Navigator.of(context).pop();
      // redirect to login
      Navigator.of(context).pushReplacement(
        CubePageRoute(
          enterPage: WithdrawalsScreen(),
          exitPage: WithdrawalsScreen(),
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        result.error,
        true,
      );
    }
  }

  void _submitConfirm() {
    if (_thisUser.ewallet_balance > _amount) {
      if (_amount >= _minimToWithdraw && _amount <= _maximumToWithdraw) {
        // check if the user phone number belongs to the network
        if (_selectedChannel == 'Mobile') {
          if (_mobileOperator.codes.contains(_mobileAccount.substring(0, 2)) &&
              _mobileAccount.toString().length ==
                  _mobileOperator.local_number_length) {
            CustomAlert(colorBg: Colors.white, colorText: Colors.black).confirm(
              context: context,
              content: Text(
                'Voulez-vous vraiment retirer ${NumberHelper().formatNumber(_amount)} FCFA sur votre numéro $_mobileAccount ?',
                textAlign: TextAlign.center,
              ),
              cancelFn: () {},
              confirmFn: _process,
              title: 'Confirmez!',
              cancelText: 'Non',
              submitText: 'Oui',
            );
            // isLocal
            if (_thisUser.countryCode == _mobileOperator.countryCode) {
              setState(() {
                _isLocal = true;
              });
            }
          } else {
            CustomAlert(
              colorBg: Colors.white,
              colorText: Colors.black,
            ).alert(
              context,
              'Désolé!',
              'Il nous semble que $_mobileAccount n\'appartient pas à ${_mobileOperator.name}',
              true,
            );
          }
        } else {
          CustomAlert(colorBg: Colors.white, colorText: Colors.black).confirm(
            context: context,
            content: Text(
              'Voulez-vous vraiment retirer ${NumberHelper().formatNumber(_amount)} FCFA par $_selectedChannel ?',
              textAlign: TextAlign.center,
            ),
            cancelFn: () {},
            confirmFn: _process,
            title: 'Confirmez!',
            cancelText: 'Non',
            submitText: 'Oui',
          );
        }
      } else {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Attention!',
          'Entrez un montant compris entre ${NumberHelper().formatNumber(_minimToWithdraw)} et ${NumberHelper().formatNumber(_maximumToWithdraw)} FCFA',
          true,
        );
      }
    } else {
      // not enough balance
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Attention!',
        'Vous ne disposez pas de fonds nécessaires pour effectuer un retrait de ${NumberHelper().formatNumber(_amount)} FCFA',
        true,
      );
    }
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        _thisUser = uzr;
      });
      // do any other stuff here
      //_getMobileNetowks();
    } else if (uzr.error == 'AUTH_EXPIRED') {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Accès refusé',
        'Vous essayez d\'accéder à un espace sécurisé. Connectez-vous et essayez de nouveau',
        false,
      );

      await Future.delayed(const Duration(seconds: 5));
      Navigator.of(context).pop();
      // redirect to login
      Navigator.of(context).pushReplacement(
        CubePageRoute(
          enterPage: LoginScreen(),
          exitPage: LoginScreen(),
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      // show error
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        uzr.error,
        true,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Effectuer un retrait',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/icon-wallet.png',
                  fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 70,
                //width: double.infinity,
              ),
              if (_thisUser != null)
                Text(
                  '${NumberHelper().formatNumber(_thisUser.ewallet_balance)} FCFA',
                  style: TextStyle(
                    color: MyColors().primary,
                    fontWeight: FontWeight.normal,
                    fontSize: 22,
                  ),
                ),
              SizedBox(height: 10),
              CustomCard(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sélectionnez un canal de retrait',
                      style: MyStyles().textInputLabel,
                    ),
                    SizedBox(height: 3),
                    CustomRadioButton(
                      buttonValues: [
                        'Mobile',
                        'Bitcoin',
                        'Ethereum',
                        'MoneyGram',
                        'WesternUnion',
                        'Ria'
                      ],
                      buttonLables: [
                        'Mobile',
                        'Bitcoin',
                        'Ethereum',
                        'MoneyGram',
                        'WesternUnion',
                        'Ria'
                      ],
                      radioButtonValue: (value) {
                        _buildSelectChannel(value);
                      },
                      unSelectedColor: MyColors().bgColor.withOpacity(0.2),
                      selectedColor: MyColors().bgColor.withOpacity(0.8),
                      selectedBorderColor: Colors.transparent,
                      unSelectedBorderColor: Colors.transparent,
                      enableShape: true,
                      enableButtonWrap: true,
                      buttonTextStyle: ButtonTextStyle(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: MyFontFamily().family2,
                        ),
                      ),
                      width: 140,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              if (_selectedChannel != null)
                CustomTextInput(
                  labelText: 'Montant à retirer (FCFA) sans esapce',
                  isObscure: false,
                  maxLines: 1,
                  inputType: TextInputType.number,
                  maxLength: 7,
                  onChanged: (value) {
                    setState(() {
                      _amount = int.parse(value);
                    });
                  },
                  helpText: 'Minimum à retirer: $_minimToWithdraw F',
                ),
              if (_mobileNetworks != null &&
                  _selectedChannel != null &&
                  _selectedChannel == 'Mobile' &&
                  _mobileNetworks.length > 0 &&
                  _amount != null &&
                  _amount >= _minimToWithdraw &&
                  _amount <= _maximumToWithdraw)
                CustomCard(
                  content: Column(
                    children: [
                      Text(
                        'Avec quel opérateur mobile souhaitez-vous faire le retrait?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: MyColors().normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      CustomRadioButton(
                        buttonLables: _mobileNetworksLabels.cast<String>(),
                        buttonValues: _mobileNetworksValues.cast<String>(),
                        radioButtonValue: (value) {
                          _selectedOperator(key: value);
                        },
                        unSelectedColor: MyColors().bgColor.withOpacity(0.2),
                        selectedColor: MyColors().bgColor.withOpacity(0.8),
                        selectedBorderColor: Colors.transparent,
                        unSelectedBorderColor: Colors.transparent,
                        enableShape: true,
                        enableButtonWrap: true,
                        buttonTextStyle: ButtonTextStyle(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFontFamily().family2,
                          ),
                        ),
                        width: 180,
                        elevation: 0,
                      ),
                      if (_mobileOperator != null)
                        Text(
                          'Expéditeur: ${_mobileOperator.system_benef_name}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red.withOpacity(0.9),
                            fontFamily: MyFontFamily().family4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              if (_selectedChannel != null &&
                  _selectedChannel == 'Mobile' &&
                  _mobileOperator != null &&
                  _mobileOperatorKey != null &&
                  _amount != null &&
                  _amount >= _minimToWithdraw)
                CustomTextInputLeading(
                  labelText:
                      'Sur quel numéro souhaitez-vous recevoir l\'argent? (ce numéro doit disposer d\'un compte Mobile Money!)',
                  isObscure: false,
                  leadingText: _mobileOperator.countryCode.toString(),
                  maxLines: 1,
                  inputType: TextInputType.number,
                  maxLength: _mobileOperator.local_number_length,
                  helpText: 'Entez le numéro sans espace',
                  onChanged: (value) {
                    setState(() {
                      _mobileAccount = value;
                    });
                  },
                ),
              if (_selectedChannel != null &&
                      _selectedChannel == 'Bitcoin' &&
                      _amount != null &&
                      _amount >= _minimToWithdraw ||
                  _selectedChannel == 'Ethereum' &&
                      _amount != null &&
                      _amount >= _minimToWithdraw)
                CustomTextInput(
                  labelText: 'Entrez votre adresses $_selectedChannel',
                  isObscure: false,
                  maxLines: 2,
                  inputType: TextInputType.multiline,
                  maxLength: 70,
                  borderRadius: 10,
                  helpText: 'Entrez une adresse valide',
                  onChanged: (value) {
                    setState(() {
                      _mobileAccount = value;
                    });
                  },
                ),
              if (_selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'Ria' ||
                  _selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'MoneyGram' ||
                  _selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'WesternUnion')
                CustomTextInput(
                  labelText: 'NOM DE FAMILLE du bénéficiaire',
                  isObscure: false,
                  maxLines: 1,
                  inputType: TextInputType.text,
                  maxLength: 60,
                  borderRadius: 50,
                  helpText: 'Tel sur votre pièce d\'identité',
                  onChanged: (value) {
                    setState(() {
                      lastName = value;
                    });
                  },
                ),
              if (_selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'Ria' ||
                  _selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'MoneyGram' ||
                  _selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'WesternUnion')
                CustomTextInput(
                  labelText: 'PRENOM(S) du bénéficiaire',
                  isObscure: false,
                  maxLines: 1,
                  inputType: TextInputType.text,
                  maxLength: 60,
                  borderRadius: 50,
                  helpText: 'Tel sur votre pièce d\'identité',
                  onChanged: (value) {
                    setState(() {
                      firstName = value;
                    });
                  },
                ),
              if (_selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'Ria' ||
                  _selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'MoneyGram' ||
                  _selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'WesternUnion')
                CustomTextInput(
                  labelText: 'Ville de réception',
                  isObscure: false,
                  maxLines: 1,
                  inputType: TextInputType.text,
                  maxLength: 60,
                  borderRadius: 50,
                  helpText: 'Ecrivez la ville en majuscule',
                  onChanged: (value) {
                    setState(() {
                      city = value;
                    });
                  },
                ),
              if (_selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'Ria' ||
                  _selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'MoneyGram' ||
                  _selectedChannel != null &&
                      _amount != null &&
                      _amount >= _minimToWithdraw &&
                      _amount <= _maximumToWithdraw &&
                      _selectedChannel == 'WesternUnion')
                CustomTextInput(
                  labelText: 'Pays de réception',
                  isObscure: false,
                  maxLines: 1,
                  inputType: TextInputType.text,
                  maxLength: 60,
                  borderRadius: 50,
                  helpText: 'Ecrivez le pays en majuscule',
                  onChanged: (value) {
                    setState(() {
                      country = value;
                    });
                  },
                ),
              if (_amount != null &&
                  _amount >= _minimToWithdraw &&
                  _selectedChannel != null)
                CustomFlatButtonRounded(
                  label: 'Lancer le retrait',
                  borderRadius: 50,
                  function: _submitConfirm,
                  borderColor: Colors.transparent,
                  bgColor: Colors.green.withOpacity(0.6),
                  textColor: Colors.white,
                ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
