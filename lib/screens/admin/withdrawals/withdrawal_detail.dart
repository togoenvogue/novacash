import 'package:flutter/material.dart';

import '../../../services/withdraw.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../helpers/common.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';
import '../../../models/withdrawal.dart';

class AdminWithdrawalDetail extends StatefulWidget {
  final WithdrawalModel retrait;
  AdminWithdrawalDetail({this.retrait});

  @override
  _AdminWithdrawalDetailState createState() => _AdminWithdrawalDetailState();
}

class _AdminWithdrawalDetailState extends State<AdminWithdrawalDetail> {
  String _txid;
  String _note;
  bool isLoading = false;

  void _closePayment() async {
    if (_note != null && _txid != null) {
      setState(() {
        isLoading = true;
      });

      CustomAlert().loading(
        context: context,
        dismiss: false,
        isLoading: isLoading,
      );
      var result = await WithdrawService().withdrawalClose(
        key: widget.retrait.key,
        note: _note,
        txid: _txid,
      );
      Navigator.of(context).pop(); // wave off the loading

      if (result != null && result.error == null) {
        setState(() {
          _note = null;
          _txid = null;
        });
        // success
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Succès!',
          'La demande de retrait a été cloturée avec succès',
          false,
        );
        await Future.delayed(const Duration(seconds: 5));
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
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
      // error
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            Text(
              widget.retrait.channel,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.retrait.txid == null &&
                widget.retrait.channel != 'Bitcoin' &&
                widget.retrait.channel != 'Ethereum')
              Column(
                children: [
                  CustomTextInput(
                    isObscure: false,
                    //maxLength: 16,
                    maxLines: 1,
                    inputType: TextInputType.number,
                    labelText: 'Entrez le TXID / MTCN',
                    helpText: 'Ex: 161-903-933-123',
                    onChanged: (value) {
                      setState(() {
                        _txid = value;
                      });
                    },
                  ),
                  CustomTextInput(
                    labelText: 'Entrez une note / instructions',
                    isObscure: false,
                    maxLines: 3,
                    inputType: TextInputType.multiline,
                    //maxLength: 70,
                    borderRadius: 10,
                    helpText: 'Ex: Details de l\'expediteur',
                    onChanged: (value) {
                      setState(() {
                        _note = value;
                      });
                    },
                  ),
                  CustomFlatButtonRounded(
                    label: 'Cloturer le paiement',
                    borderRadius: 50,
                    function: _closePayment,
                    borderColor: Colors.transparent,
                    bgColor: MyColors().bgColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            Text(
              DateHelper().formatTimeStampFull(widget.retrait.timeStamp),
              style: TextStyle(
                  fontSize: 14, color: Colors.redAccent.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
            CustomListSpaceBetwen(
              label: 'Key',
              value: '${widget.retrait.key}',
            ),
            CustomListSpaceBetwen(
              label: 'Montant',
              value:
                  '${NumberHelper().formatNumber(widget.retrait.amount)} FCFA',
            ),
            if (widget.retrait.channel == 'Mobile') CustomHorizontalDiver(),
            if (widget.retrait.channel == 'Mobile')
              CustomListSpaceBetwen(
                label: 'Téléphone',
                value:
                    '+${widget.retrait.countryCode}${widget.retrait.account}',
              ),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomHorizontalDiver(),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomListSpaceBetwen(
                label: 'Nom',
                value: '${widget.retrait.lastName}',
              ),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomHorizontalDiver(),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomListSpaceBetwen(
                label: 'Prénom(s)',
                value: '${widget.retrait.firstName}',
              ),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomHorizontalDiver(),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomListSpaceBetwen(
                label: 'Ville',
                value: '${widget.retrait.city}',
              ),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomHorizontalDiver(),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomListSpaceBetwen(
                label: 'Pays',
                value: '${widget.retrait.country}',
              ),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomHorizontalDiver(),
            if (widget.retrait.channel == 'Ria' ||
                widget.retrait.channel == 'MoneyGram' ||
                widget.retrait.channel == 'WesternUnion')
              CustomListSpaceBetwen(
                label: 'Téléphone',
                value: '+${widget.retrait.userKey['username']}',
              ),
            if (widget.retrait.txid != null &&
                widget.retrait.status != 'Pending' &&
                widget.retrait.channel != 'Bitcoin' &&
                widget.retrait.channel != 'Ethereum')
              CustomHorizontalDiver(),
            if (widget.retrait.txid != null &&
                widget.retrait.status != 'Pending' &&
                widget.retrait.channel != 'Bitcoin' &&
                widget.retrait.channel != 'Ethereum')
              CustomListSpaceBetwen(
                label: 'REF/TXID/MTCN',
                value: '${widget.retrait.txid}',
              ),
            if (widget.retrait.status == 'Pending') CustomHorizontalDiver(),
            if (widget.retrait.status == 'Pending')
              CustomListSpaceBetwen(
                label: 'Statut',
                value: 'En attente de traitement',
              ),
            if (widget.retrait.status != 'Pending') CustomHorizontalDiver(),
            if (widget.retrait.status != 'Pending')
              CustomListSpaceBetwen(
                label: 'Statut',
                value: 'Paiement traité',
              ),
            if (widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Bitcoin' ||
                widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Ethereum')
              CustomHorizontalDiver(),
            if (widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Bitcoin' ||
                widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Ethereum')
              SizedBox(height: 10),
            if (widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Bitcoin' ||
                widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Ethereum')
              Text('ADRESSE'),
            if (widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Bitcoin' ||
                widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Ethereum')
              Text(
                widget.retrait.account,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            if (widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Bitcoin' ||
                widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Ethereum')
              SizedBox(height: 20),
            if (widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Bitcoin' ||
                widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Ethereum')
              Text('TXID'),
            if (widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Bitcoin' ||
                widget.retrait.txid != null &&
                    widget.retrait.status != 'Pending' &&
                    widget.retrait.channel == 'Ethereum')
              SelectableText(
                widget.retrait.txid,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            if (widget.retrait.txid != null &&
                widget.retrait.status != 'Pending' &&
                widget.retrait.channel != 'Bitcoin' &&
                widget.retrait.channel != 'Ethereum')
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Colors.green.withOpacity(0.4),
                width: double.infinity,
                child: Text(
                  '${widget.retrait.mobileMoney}',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
