import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
//import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../../../../screens/account/dashboard.dart';
import '../../../../services/p2p.dart';
import '../../../../services/user.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../screens/public/apn/apn.dart';
import '../../../../widgets/common/custom_card.dart';
import '../../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../../widgets/common/custom_horizontal_diver.dart';
import '../../../../widgets/common/custom_list_space_between.dart';
import '../../../../widgets/common/custom_note.dart';
import '../../../../widgets/common/custom_text_input.dart';
import '../../../../models/p2p_transaction.dart';
import '../../../../styles/styles.dart';

class P2PTransactionNotifyScreen extends StatefulWidget {
  final P2PTransactionModel don;
  P2PTransactionNotifyScreen({this.don});
  @override
  _P2PTransactionNotifyScreenState createState() =>
      _P2PTransactionNotifyScreenState();
}

class _P2PTransactionNotifyScreenState
    extends State<P2PTransactionNotifyScreen> {
  final _refController = TextEditingController();
  String channel;
  String currency;
  dynamic amount;
  String account;
  double valueFontSize;
  String ref;
  bool isUserFree;
  bool isLoading;

  void _checkUser(String userKey) async {
    /*ustomAlert().loading(
      context: context,
      dismiss: false,
      isLoading: true,
    );*/
    if (userKey != '5555555') {
      var result = await P2PService().p2pSilverIsUserDueFree(
        userKey: userKey,
      );
      //Navigator.of(context).pop();
      if (result != null && result == true) {
        setState(() {
          isUserFree = true;
        });
      } else {
        setState(() {
          isUserFree = false;
        });
      }
    } else {
      setState(() {
        isUserFree = true;
      });
    }
  }

  void _channel(String value) {
    setState(() {
      if (value == 'Bitcoin' && isUserFree == true) {
        currency = 'BTC';
        channel = 'Bitcoin';
        amount = widget.don.amountBTC;
        account = widget.don.toKey['channel_btc'];
        valueFontSize = 11.0;
      } else if (value == 'Ethereum' && isUserFree == true) {
        currency = 'ETH';
        channel = 'Ethereum';
        amount = widget.don.amountETH;
        account = widget.don.toKey['channel_eth'];
        valueFontSize = 11.0;
      } else if (value == 'Main à main' && isUserFree == true) {
        currency = 'FCFA';
        channel = 'Main à main';
        amount = widget.don.amountXOF;
        account = widget.don.toKey['channel_cash'];
        valueFontSize = 14.0;
      } else if (value == 'Token (Code)') {
        currency = 'FCFA';
        amount = widget.don.amountXOF;
        account = 'Ewallet';
        channel = 'Token';
        valueFontSize = 14.0;
      } else if (value == 'MobileMoney 1' && isUserFree == true) {
        currency = 'FCFA';
        channel = 'Mobile Money';
        amount = widget.don.amountXOF;
        account = widget.don.toKey['channel_mobile1'];
        valueFontSize = 14.0;
      } else if (value == 'MobileMoney 2' && isUserFree == true) {
        currency = 'FCFA';
        channel = 'Mobile Money';
        amount = widget.don.amountXOF;
        account = widget.don.toKey['channel_mobile2'];
        valueFontSize = 14.0;
      } else if (value == 'MobileMoney 3' && isUserFree == true) {
        currency = 'FCFA';
        channel = 'Mobile Money';
        amount = widget.don.amountXOF;
        account = widget.don.toKey['channel_mobile3'];
        valueFontSize = 14.0;
      } else if (value == 'Paypal' && isUserFree == true) {
        currency = 'USD';
        channel = 'Paypal';
        amount = widget.don.amountUSD;
        account = widget.don.toKey['channel_pp'];
        valueFontSize = 12.0;
      } else if (value == 'Payeer' && isUserFree == true) {
        currency = 'USD';
        channel = 'Payeer';
        amount = widget.don.amountUSD;
        account = widget.don.toKey['channel_py'];
        valueFontSize = 14.0;
      } else if (value == 'PerfectMoney' && isUserFree == true) {
        currency = 'USD';
        channel = 'PerfectMoney';
        amount = widget.don.amountUSD;
        account = widget.don.toKey['channel_pm'];
        valueFontSize = 14.0;
      }
    });
  }

  void _submit() async {
    setState(() {
      isLoading = true;
    });
    CustomAlert().loading(
      context: context,
      dismiss: false,
      isLoading: isLoading,
    );
    var result = await P2PService().p2pSilverUpdateTransaction(
      account: account,
      channel: channel,
      key: widget.don.key,
      ref: ref,
      type: 'Notify',
    );
    setState(() {
      isLoading = false;
    });

    if (result != null && result.error == null) {
      // select user
      var user = await AuthService().getThisUser();
      Navigator.of(context).pop();
      if (user != null && user.error == null) {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Succès!',
          'La notification de votre paiement a été envoyée à ${widget.don.toKey['firstName']} ${widget.don.toKey['lastName']} qui dispose de 48h pour l\'approuver ou la rejeter',
          false,
        );
        // redirect after 5 seconds
        await Future.delayed(const Duration(seconds: 6));
        Navigator.of(context).pop();

        /* if (widget.don.toKey['whatsApp'] != null &&
            widget.don.toKey['whatsApp'].toString().length >= 11) {
          
          FlutterOpenWhatsapp.sendSingleMessage(
            widget.don.toKey['whatsApp'],
            '''Bonjour ${widget.don.toKey['firstName']} ${widget.don.toKey['lastName']},
Je m'appelle ${widget.don.fromKey['firstName']} ${widget.don.fromKey['lastName']}, et je viens de vous envoyer l\'équivalent de ${widget.don.amountXOF} FCFA dans le cadre du programme NovaCash ${widget.don.matrix}.

Voulez-vous bien vérifier le paiement et approuver ma notification dans l\'application NovaCash?''',
          );
          Navigator.of(context).pushReplacement(
            CubePageRoute(
              enterPage: DashboardScreen(userObj: user),
              exitPage: DashboardScreen(userObj: user),
              duration: const Duration(milliseconds: 300),
            ),
          );
        } else {
        */
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: DashboardScreen(userObj: user),
            exitPage: DashboardScreen(userObj: user),
            duration: const Duration(milliseconds: 300),
          ),
        );

        //}
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
    } else {
      Navigator.of(context).pop();
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

  void _confirm() {
    if (ref != null && ref.length >= 5) {
      if (channel != 'Token (Code)') {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).confirm(
          cancelFn: () {},
          cancelText: 'Annuler',
          confirmFn: _submit,
          content: Text(
            'Etes-vous sûr d\'avoir envoyé $amount $currency par $channel à ${widget.don.toKey['firstName']} ${widget.don.toKey['lastName']} ? Si vous faites le malin votre compte sera automatiquement bloqué!',
            textAlign: TextAlign.center,
          ),
          context: context,
          submitText: 'D\'accord',
          title: 'Avertissement!',
        );
      } else {
        _submit();
      }
    } else {
      // entrez une reference de paiement d'au moins 5 caracteres
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Attention!',
        'Entrez une référence de paiement ou un token d\'au moins 5 caractères',
        true,
      );
    }
  }

  void _redirectToApnList() {
    Navigator.of(context).push(
      CubePageRoute(
        enterPage: ApnScreen(),
        exitPage: ApnScreen(),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkUser(widget.don.toKey['_key']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'P2P - Envoyer un paiement',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              if (widget.don.status == 'Pending')
                CustomNote(
                  color: Colors.yellow[100],
                  textColor: Colors.black,
                  message:
                      'Vous disposez de 48h pour exécuter ce paiement au risque de perdre votre compte',
                ),
              if (widget.don.status == 'Pending')
                CustomCard(
                  content: Column(
                    children: [
                      isUserFree == true
                          ? Text(
                              'Sélectionnez le moyen de paiement approprié pour effectuer le paiement',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              'NB: Le bénéficiaire n\'étant pas en règle, achetez un Token (Code) et envoyez directement l\'argent dans son ewallet',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                      SizedBox(height: 10),
                      isUserFree == true
                          ? CustomRadioButton(
                              buttonValues: [
                                'Main à main',
                                'Token (Code)',
                                'MobileMoney 1',
                                'MobileMoney 2',
                                'MobileMoney 3',
                                'Paypal',
                                'Bitcoin',
                                'Ethereum',
                                'Payeer',
                                'PerfectMoney'
                              ],
                              buttonLables: [
                                'Main à main',
                                'Token (Code)',
                                'MobileMoney 1',
                                'MobileMoney 2',
                                'MobileMoney 3',
                                'Paypal',
                                'Bitcoin',
                                'Ethereum',
                                'Payeer',
                                'PerfectMoney'
                              ],
                              radioButtonValue: (value) {
                                _channel(value);
                              },
                              unSelectedColor: Colors.black.withOpacity(0.1),
                              selectedColor: MyColors().success,
                              selectedBorderColor: Colors.transparent,
                              unSelectedBorderColor:
                                  Colors.black.withOpacity(0.1),
                              enableShape: true,
                              enableButtonWrap: true,
                              buttonTextStyle: ButtonTextStyle(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: MyFontFamily().family1,
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              width: 125,
                              elevation: 0,
                            )
                          : CustomRadioButton(
                              buttonValues: ['Token (Code)'],
                              buttonLables: ['Token (Code)'],
                              radioButtonValue: (value) {
                                _channel(value);
                              },
                              unSelectedColor: Colors.black.withOpacity(0.1),
                              selectedColor: Colors.green.withOpacity(0.8),
                              selectedBorderColor: Colors.transparent,
                              unSelectedBorderColor:
                                  Colors.black.withOpacity(0.1),
                              enableShape: true,
                              enableButtonWrap: true,
                              buttonTextStyle: ButtonTextStyle(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: MyFontFamily().family1,
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              width: 125,
                              elevation: 0,
                            ),
                    ],
                  ),
                ),
              if (currency != null && amount != null && account != null)
                CustomCard(
                  content: Column(
                    children: [
                      CustomListSpaceBetwen(
                        label: 'Transaction',
                        value: 'SILVER, round#${widget.don.cycle}',
                        valueColor: Colors.green[800],
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Montant à envoyer',
                        value: '$amount $currency',
                        valueColor: Colors.green[800],
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Canal',
                        value: '$channel',
                        valueColor: Colors.green[800],
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: channel != 'Main à main' ? 'Compte' : 'Lieu',
                        value:
                            '${account.length <= 27 ? account : account.substring(0, 27)}',
                        valueColor: Colors.green[800],
                        valueFontSize: valueFontSize,
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Nom',
                        value: '${widget.don.toKey['lastName']}',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Prénom(s)',
                        value: '${widget.don.toKey['firstName']}',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Téléphone',
                        value: '+${widget.don.toKey['username']}',
                      ),
                      //Text('${widget.don.toKey['whatsApp']}'),
                      /*Column(
                        children: [
                          Text(
                            'Vous pouvez discuter avec ${widget.don.toKey['firstName']} en cliquant sur l\'icône WhatsApp',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),*/
                    ],
                  ),
                ),
              if (currency != null && amount != null && account != null)
                if (widget.don.status == 'Pending')
                  CustomCard(
                    content: Column(
                      children: [
                        if (channel != 'Token')
                          Text(
                            'Après avoir effecuté le paiement, écrivez ou copier coller la référence de la transaction dans le champ suivant, puis envoyez la notification',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: 8),
                        if (channel != 'Token')
                          Text(
                            'Si vous envoyez une fausse notification et que votre demande est rejetée, votre compte sera automatiquement fermé!',
                            style: TextStyle(
                              color: Colors.red[400],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: 5),
                        CustomTextInput(
                          isObscure: false,
                          maxLines: 1,
                          inputType: TextInputType.text,
                          controller: _refController,
                          labelText: channel != 'Token'
                              ? 'Référence de la transaction'
                              : 'Entrez le token (Code d\'activation)',
                          hintText: '',
                          helpText: 'Ce champ est obligatoire',
                          onChanged: (value) {
                            setState(() {
                              ref = value;
                            });
                          },
                        ),
                        CustomFlatButtonRounded(
                          label: 'Envoyer la notification',
                          borderRadius: 50,
                          function: () {
                            _confirm();
                          },
                          borderColor: Colors.green.withOpacity(0.9),
                          bgColor: Colors.green.withOpacity(0.9),
                          textColor: Colors.white,
                        ),
                        if (channel == 'Token')
                          CustomFlatButtonRounded(
                            label: 'Cliquez pour acheter un token',
                            borderRadius: 50,
                            function: _redirectToApnList,
                            bgColor: Colors.redAccent,
                            textColor: Colors.white,
                            borderColor: Colors.redAccent,
                          ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
