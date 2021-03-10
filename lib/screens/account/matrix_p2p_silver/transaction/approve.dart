import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';

import '../../../../screens/account/dashboard.dart';
import '../../../../screens/account/matrix_core/expiration/renew.dart';
import '../../../../services/p2p.dart';
import '../../../../services/user.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../widgets/common/custom_card.dart';
import '../../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../../widgets/common/custom_horizontal_diver.dart';
import '../../../../widgets/common/custom_list_space_between.dart';
import '../../../../widgets/common/custom_note.dart';
import '../../../../models/p2p_transaction.dart';
import '../../../../styles/styles.dart';

class P2PTransactionApproveScreen extends StatefulWidget {
  final P2PTransactionModel don;
  P2PTransactionApproveScreen({this.don});
  @override
  _P2PTransactionApproveScreenState createState() =>
      _P2PTransactionApproveScreenState();
}

class _P2PTransactionApproveScreenState
    extends State<P2PTransactionApproveScreen> {
  String channel;
  String currency;
  dynamic amount;
  String account;
  double valueFontSize;
  String ref;
  String action;

  void _setAction(String value) {
    setState(() {
      action = value;
    });
  }

  void _channel() {
    setState(() {
      ref = widget.don.payRef;
      if (widget.don.toChannel == 'Bitcoin') {
        currency = 'BTC';
        channel = 'Bitcoin';
        amount = widget.don.amountBTC;
        account = widget.don.toKey['channel_btc'];
        valueFontSize = 12.0;
      } else if (widget.don.toChannel == 'Ethereum') {
        currency = 'ETH';
        channel = 'Ethereum';
        amount = widget.don.amountETH;
        account = widget.don.toKey['channel_eth'];
        valueFontSize = 10.0;
      } else if (widget.don.toChannel == 'Main à main') {
        currency = 'FCFA';
        channel = 'Main à main';
        amount = widget.don.amountXOF;
        account = widget.don.toKey['channel_cash'];
        valueFontSize = 14.0;
      } else if (widget.don.toChannel == 'Token') {
        currency = 'FCFA';
        amount = widget.don.amountXOF;
        account = 'Ewallet';
        channel = 'Token';
        valueFontSize = 14.0;
      } else if (widget.don.toChannel == 'Mobile Money') {
        currency = 'FCFA';
        channel = 'Mobile Money';
        amount = widget.don.amountXOF;
        account = widget.don.toKey['channel_mobile1'];
        valueFontSize = 16.0;
      } else if (widget.don.toChannel == 'Paypal') {
        currency = 'USD';
        channel = 'Paypal';
        amount = widget.don.amountUSD;
        account = widget.don.toKey['channel_pp'];
        valueFontSize = 12.0;
      } else if (widget.don.toChannel == 'Payeer') {
        currency = 'USD';
        channel = 'Payeer';
        amount = widget.don.amountUSD;
        account = widget.don.toKey['channel_py'];
        valueFontSize = 14.0;
      } else if (widget.don.toChannel == 'PerfectMoney') {
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
      type: action == 'Approuver' ? 'Approve' : 'Reject',
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
          'La notification de paiement de ${widget.don.fromKey['firstName']} ${widget.don.fromKey['lastName']} a été ${action == 'Approuver' ? 'approuvée' : 'rejetée'}',
          false,
        );
        // redirect after 5 seconds
        await Future.delayed(const Duration(seconds: 6));
        Navigator.of(context).pop();
        //Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: DashboardScreen(userObj: user),
            exitPage: DashboardScreen(userObj: user),
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
    if (action != null) {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).confirm(
        cancelFn: () {},
        cancelText: 'Annuler',
        confirmFn: _submit,
        content: Text(
          'Voulez-vous vraiment continuer avec cette option? Cette action est irréversible!',
          textAlign: TextAlign.center,
        ),
        context: context,
        submitText: action,
        title: 'Avertissement!',
      );
    } else {
      _submit();
    }
  }

  @override
  void initState() {
    super.initState();
    _channel();
    //print(widget.don.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'P2P - Traiter un paiement',
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
              if (widget.don.status == 'Waiting')
                CustomNote(
                  color: Colors.red[100],
                  textColor: Colors.black,
                  message:
                      'Vous disposez de 48h pour approuver ou rejeter ce paiement au risque d\'une validation automatique par le système',
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
                        label: 'Montant reçu',
                        value: '$amount $currency',
                        valueColor: Colors.green[800],
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Canal',
                        value: '${widget.don.toChannel}',
                        valueColor: Colors.green[800],
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: channel != 'Main à main' ? 'Compte' : 'Lieu',
                        value: '${widget.don.toAccount}',
                        valueColor: Colors.green[800],
                        valueFontSize: valueFontSize,
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Nom',
                        value: '${widget.don.fromKey['lastName']}',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Prénom(s)',
                        value: '${widget.don.fromKey['firstName']}',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Téléphone',
                        value: '+${widget.don.fromKey['username']}',
                      ),
                    ],
                  ),
                ),
              if (widget.don.status == 'Waiting')
                CustomCard(
                  content: Column(
                    children: [
                      Text(
                        'Sélectionnez une action',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      CustomRadioButton(
                        buttonValues: ['Rejeter', 'Approuver'],
                        buttonLables: ['Rejeter', 'Approuver'],
                        radioButtonValue: (value) {
                          _setAction(value);
                        },
                        unSelectedColor: Colors.black.withOpacity(0.1),
                        selectedColor: Colors.green.withOpacity(0.8),
                        selectedBorderColor: Colors.transparent,
                        unSelectedBorderColor: Colors.black.withOpacity(0.1),
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
                        width: 110,
                        elevation: 0,
                      ),
                      if (action != null) SizedBox(height: 10),
                      if (action != null)
                        Text(
                          'Assurez-vous d\'avoir sélectionné la bonne option car cette action est irréversible!',
                          style: TextStyle(
                            color: Colors.red[400],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (action != null) SizedBox(height: 5),
                      if (action != null)
                        CustomFlatButtonRounded(
                          label: action,
                          borderRadius: 50,
                          function: () {
                            _confirm();
                          },
                          borderColor: action == 'Approuver'
                              ? Colors.green.withOpacity(0.9)
                              : Colors.red,
                          bgColor: action == 'Approuver'
                              ? Colors.green.withOpacity(0.9)
                              : Colors.red,
                          textColor: Colors.white,
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
