import 'package:flutter/material.dart';
import '../../../../helpers/common.dart';
import '../../../../models/jackpot.dart';
import 'paris_item.dart';

class MesParisJackpotList extends StatelessWidget {
  final JackpotPlayModel pariObj;
  MesParisJackpotList({this.pariObj});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          width: 40,
          child: Column(
            children: [
              pariObj.amountGained > 0
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    )
                  : Icon(
                      Icons.clear,
                      color: Colors.redAccent[100],
                      size: 30,
                    ),
              SizedBox(height: 5),
            ],
          ),
          margin: EdgeInsets.only(bottom: 5, top: 20),
        ),
        SizedBox(width: 0),
        Expanded(
          child: Container(
            child: Column(
              children: [
                MesParisJackpotListItem(
                  label: 'Date',
                  value: DateHelper().formatTimeStampFull(pariObj.timeStamp),
                ),
                MesParisJackpotListItem(
                  label: 'Système : Vous',
                  value:
                      '${pariObj.systemChoice.toString()} : ${pariObj.userChoice.toString()}',
                ),
                MesParisJackpotListItem(
                  label: 'Montant gagné',
                  value:
                      '${NumberHelper().formatNumber(pariObj.amountGained).toString()} FCFA',
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          ),
        ),
      ],
    );
  }
}
