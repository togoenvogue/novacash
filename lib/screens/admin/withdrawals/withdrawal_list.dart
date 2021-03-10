import 'package:flutter/material.dart';

import '../../../screens/admin/withdrawals/withdrawal_detail.dart';
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
  void _openDetailModal({BuildContext ctx, WithdrawalModel retrait}) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return AdminWithdrawalDetail(retrait: retrait);
      },
    );
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
            label: 'Channel',
            value: '${widget.wdl.channel}',
          ),
          CustomHorizontalDiver(),
          SizedBox(height: 7),
          widget.wdl.status == 'Pending'
              ? CustomFlatButtonRounded(
                  label: 'Attente de paiement',
                  borderRadius: 50,
                  function: () {
                    _openDetailModal(
                      ctx: context,
                      retrait: widget.wdl,
                    );
                  },
                  bgColor: MyColors().warning,
                  textColor: Colors.white,
                )
              : CustomFlatButtonRounded(
                  label: 'Déjà payé',
                  borderRadius: 50,
                  function: () {
                    _openDetailModal(
                      ctx: context,
                      retrait: widget.wdl,
                    );
                  },
                  bgColor: MyColors().success,
                  textColor: Colors.white,
                ),
        ],
      ),
    );
  }
}
