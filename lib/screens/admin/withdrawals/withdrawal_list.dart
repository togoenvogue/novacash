import 'package:flutter/material.dart';
import 'package:ussd/ussd.dart';

import '../../../screens/account/expiration/renew.dart';
import '../../../services/ussd.dart';
import '../../../helpers/common.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../models/withdrawal.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';
import '../../../widgets/common/custom_card.dart';

class AdminWithdrawalList extends StatefulWidget {
  final WithdrawalModel wdl;
  AdminWithdrawalList({this.wdl});

  @override
  _AdminWithdrawalListState createState() => _AdminWithdrawalListState();
}

class _AdminWithdrawalListState extends State<AdminWithdrawalList> {
  void _callUSSD({String key}) async {
    setState(() {
      isLoading = true;
    });
    // get the withdrawal
    var result = await UssdService().getWithdrawal(key: key);

    if (result != null && result.error == null) {
      if (result.status == 'Pending') {
        if (result.mobileMoney == 'OrangeMoney') {
          //print(key);
          final String ussdCode = result.isLocal == true
              ? '*144*2*1*${result.account}*${result.amount}#'
              : '*144*2*2*${result.account}*${result.amount}#';
          Ussd.runUssd(ussdCode);
        } else {
          //print(key);
          final String ussdCode = result.isLocal == true
              ? '*555*2*1*${result.account}*${result.amount}#'
              : '*555*2*2*${result.account}*${result.amount}#';
          Ussd.runUssd(ussdCode);
        }
      } else {}
    } else {
      // error
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Colors.white,
      content: Column(
        children: [
          CustomListSpaceBetwen(
            label: 'Date',
            value: '${DateHelper().formatTimeStampFull(widget.wdl.timeStamp)}',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Withdrawal Key',
            value: '${widget.wdl.key}',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Nom',
            value:
                '${widget.wdl.userKey['lastName'].length <= 22 ? widget.wdl.userKey['lastName'] : widget.wdl.userKey['lastName'].substring(0, 22)}',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Prénom(s)',
            value:
                '${widget.wdl.userKey['firstName'].length <= 22 ? widget.wdl.userKey['firstName'] : widget.wdl.userKey['firstName'].substring(0, 22)}',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Montant',
            value: '${NumberHelper().formatNumber(widget.wdl.amount)} FCFA',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Cpte',
            value:
                '(+${widget.wdl.countryCode}) ${widget.wdl.account} /${widget.wdl.mobileMoney}',
          ),
          CustomHorizontalDiver(),
          SizedBox(height: 7),
          widget.wdl.status == 'Pending'
              ? CustomFlatButtonRounded(
                  label: 'Payer (${widget.wdl.mobileMoney})',
                  borderRadius: 50,
                  function: () {
                    _callUSSD(key: widget.wdl.key);
                  },
                  bgColor: widget.wdl.mobileMoney == 'OrangeMoney'
                      ? MyColors().warning
                      : MyColors().primary,
                  textColor: Colors.white,
                )
              : Text('Payé: ${widget.wdl.txid}'),
        ],
      ),
    );
  }
}
