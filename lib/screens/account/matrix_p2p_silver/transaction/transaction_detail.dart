import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import 'approve.dart';
import 'notify.dart';
import '../../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../../models/p2p_transaction.dart';
import '../../../../helpers/common.dart';
import '../../../../widgets/common/custom_horizontal_diver.dart';
import '../../../../widgets/common/custom_list_space_between.dart';

class P2PSilverTransactionDetail extends StatelessWidget {
  final P2PTransactionModel data;
  final String userKey;
  P2PSilverTransactionDetail({this.data, this.userKey});

  @override
  Widget build(BuildContext context) {
    void _notify() {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        CubePageRoute(
          enterPage: P2PTransactionNotifyScreen(don: data),
          exitPage: P2PTransactionNotifyScreen(don: data),
          duration: const Duration(milliseconds: 300),
        ),
      );
    }

    void _approve() {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        CubePageRoute(
          enterPage: P2PTransactionApproveScreen(don: data),
          exitPage: P2PTransactionApproveScreen(don: data),
          duration: const Duration(milliseconds: 300),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            if (data.status == 'Pending' && data.fromKey['_key'] == userKey)
              CustomFlatButtonRounded(
                label: 'Cliquez pour notifier',
                borderRadius: 50,
                function: _notify,
                bgColor: Colors.redAccent,
                textColor: Colors.white,
                borderColor: Colors.redAccent,
              ),
            if (data.status == 'Waiting' && data.toKey['_key'] == userKey)
              CustomFlatButtonRounded(
                label: 'Cliquez pour approuver',
                borderRadius: 50,
                function: _approve,
                bgColor: Colors.green,
                textColor: Colors.white,
                borderColor: Colors.green,
              ),
            if (data.payRef != null)
              Text(
                data.payRef,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            Text(
              DateHelper().formatTimeStampFull(data.timeStamp),
              style: TextStyle(
                  fontSize: 14, color: Colors.redAccent.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
            if (data.toKey['whatsApp'] != null &&
                data.toKey['whatsApp'].toString().length >= 11)
              Column(
                children: [
                  Text(
                    'Vous pouvez discuter avec ${data.toKey['firstName']} ${data.toKey['lastName']} en cliquant sur l\'icône WhatsApp',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      FlutterOpenWhatsapp.sendSingleMessage(
                          data.toKey['whatsApp'], '');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Image.asset(
                        'assets/images/icon_whatsapp.png',
                        width: 40,
                      ),
                    ),
                  ),
                  SizedBox(width: 0),
                ],
              ),
            CustomListSpaceBetwen(
              label: 'Nom',
              value: userKey == data.fromKey['_key']
                  ? '${data.toKey['firstName']}'
                  : '${data.fromKey['firstName']}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Prénom(s)',
              value: userKey == data.fromKey['_key']
                  ? '${data.toKey['lastName']}'
                  : '${data.fromKey['lastName']}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: userKey == data.fromKey['_key']
                  ? 'Montant envoyé'
                  : 'Montant reçu',
              value: '${NumberHelper().formatNumber(data.amountXOF)} FCFA',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Bitcoin',
              value: '${data.amountBTC} BTC',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Ethereum',
              value: '${data.amountETH} ETH',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Dollar',
              value: '${data.amountUSD} USD',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Canal',
              value: '${data.toChannel}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Compte',
              value:
                  '${data.toAccount.length <= 20 ? data.toAccount : data.toAccount.substring(0, 20)}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Statut',
              value: '${data.status}',
            ),
          ],
        ),
      ),
    );
  }
}
