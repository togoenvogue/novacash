import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';

import '../../../models/reload.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/reload.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_note.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../styles/styles.dart';

class ReloadCryptoScreen extends StatefulWidget {
  @override
  _ReloadCryptoScreenState createState() => _ReloadCryptoScreenState();
}

class _ReloadCryptoScreenState extends State<ReloadCryptoScreen> {
  List<String> _paymentOptionsName = [];
  List<String> _paymentOptionsSymbol = [];
  String _selectedChannel;
  String _payTo;
  dynamic _amount;
  final dynamic _minimumToLoad = 5000;

  List<CryptoNetworkModel> records = [];
  CryptoPayinModel _payin;
  UserModel _thisUser;
  bool isLoading = false;
  bool hasPendingPayin = false;
  //final snackBar = SnackBar(content: Text('Adresse copiée'));

  void _cryptoPayinCreate(
      {String userKey, String currency, dynamic amount}) async {
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    var result = await ReloadService().cryptoPayinCreate(
        amount: amount, currency: currency, userKey: userKey);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop(); // take off the loading

    if (result.error == null) {
      setState(() {
        _payin = result;
        _payTo = result.systemAddress;
        hasPendingPayin = true;
      });
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

  void _getPendingPayin({String userKey}) async {
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    var result = await ReloadService().payinPending(userKey: userKey);

    setState(() {
      isLoading = false;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    if (result.error == null) {
      if (result.key != null) {
        setState(() {
          hasPendingPayin = true;
          _payin = result;
          _payTo = result.systemAddress;
          _selectedChannel = result.currency;
        });
      } else {
        hasPendingPayin = false;
        _payin = null;
        _payTo = null;
        _selectedChannel = null;
      }
    } else {
      // alert
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

  void _getRecords() async {
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    var result = await ReloadService().getCryptoNetworks();
    setState(() {
      isLoading = false;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    if (result != null && result[0].error != 'No data') {
      setState(() {
        records = result;
        for (var item in result) {
          _paymentOptionsName.add(item.name);
          _paymentOptionsSymbol.add(item.currency);
        }
      });
    } else {
      // alert
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

  void _copyAdress(String value) {
    CustomAlert(
      colorBg: Colors.white,
      colorText: Colors.black,
    ).alert(
      context,
      'Bravo!',
      'L\'adresse $_selectedChannel a été copiée dans le presse-papier. Procédez au paiement',
      true,
    );
  }

  void _getSelectedPaymentOption({String selectedOption}) {
    setState(() {
      _selectedChannel = selectedOption;
    });
    _cryptoPayinCreate(
        amount: _amount, userKey: _thisUser.key, currency: selectedOption);
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        _thisUser = uzr;
      });
      // do any other stuff here
      _getRecords();
      _getPendingPayin(userKey: uzr.key);
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

  void _cancelConfirm() {
    CustomAlert(
      colorBg: Colors.white,
      colorText: Colors.black,
    ).confirm(
      cancelFn: () {},
      confirmFn: _cancel,
      submitText: 'Oui, supprimer!',
      cancelText: 'Non',
      context: context,
      title: 'Attention!',
      content: Text(
        'Voulez-vous vraiment supprimer cette transaction? Si vous avez déja envoyé les fonds, votre compte ne sera pas crédité!',
        textAlign: TextAlign.center,
      ),
    );
  }

  void _cancel({String payinKey}) async {
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    var result = await ReloadService()
        .payinCancel(userKey: _thisUser.key, payinKey: _payin.key);
    setState(() {
      isLoading = false;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    if (result.error == null) {
      setState(() {
        hasPendingPayin = false;
        _payin = null;
        _payTo = null;
        _selectedChannel = null;
      });
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Succes!',
        'Votre transaction a été annulée avec succès. Vous pouvez initier une nouveller transaction selon vos besoins',
        true,
      );
    } else {
      // alert
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
          'Dépôt par Crypto',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              if (hasPendingPayin == true)
                CustomCard(
                  content: Column(
                    children: [
                      Text(
                        'La transaction suivante est en attente de votre paiement. Suivez les instructions pour envoyer le paiement si ce n\'est pas encore fait',
                        style: TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                      CustomFlatButtonRounded(
                        bgColor: Colors.redAccent,
                        borderRadius: 50,
                        label: 'Supprimer cette transaction',
                        function: _cancelConfirm,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              if (hasPendingPayin == false && _payin == null)
                CustomTextInput(
                  labelText: 'Entrez le montant à créditer (FCFA)',
                  isObscure: false,
                  maxLines: 1,
                  inputType: TextInputType.number,
                  maxLength: 7,
                  helpText: 'Minimum à créditer: $_minimumToLoad',
                  onChanged: (value) {
                    setState(() {
                      _amount = int.parse(value);
                    });
                  },
                ),
              if (_paymentOptionsName.length > 0 &&
                  _amount != null &&
                  _amount >= _minimumToLoad &&
                  hasPendingPayin == false &&
                  _payin == null)
                CustomCard(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sélectionnez un canal de paiement',
                        style: MyStyles().textInputLabel,
                      ),
                      SizedBox(height: 3),
                      CustomRadioButton(
                        buttonValues: _paymentOptionsSymbol,
                        buttonLables: _paymentOptionsName,
                        radioButtonValue: (value) {
                          _getSelectedPaymentOption(selectedOption: value);
                        },
                        unSelectedColor: MyColors().primary.withOpacity(0.2),
                        selectedColor: MyColors().primary,
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
                        width: 150,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              if (_selectedChannel != null)
                if (_payin != null)
                  CustomCard(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Montant à envoyer (les éventuels frais sont à votre charge. Assurez-vous de les payer)',
                          style: MyStyles().textInputLabel,
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${_payin.amountCrypto} ${_payin.currency}',
                          style:
                              TextStyle(fontSize: 26, color: MyColors().danger),
                        ),
                      ],
                    ),
                  ),
              if (_selectedChannel != null && _payin != null && _payTo != null)
                CustomCard(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Envoyez votre paiement à',
                        style: MyStyles().textInputLabel,
                      ),
                      SizedBox(height: 3),
                      SelectableText(
                        _payTo,
                        style: TextStyle(
                          fontSize: 13,
                          color: MyColors().danger,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () {
                          _copyAdress(_payTo);
                        },
                      ),
                      Text('Cliquez sur l\'adresse pour la copier'),
                    ],
                  ),
                ),
              if (_selectedChannel != null)
                if (_payin != null)
                  CustomCard(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vous recevrez sur votre compte',
                          style: MyStyles().textInputLabel,
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${_payin.amountXOF} FCFA',
                          style:
                              TextStyle(fontSize: 26, color: MyColors().danger),
                        ),
                      ],
                    ),
                  ),
              CustomNote(
                message:
                    'Votre compte sera automatiquement crédité dans les 5 minutes qui suivent la réception de votre paiement',
                icon: Icons.info,
                color: MyColors().info,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
