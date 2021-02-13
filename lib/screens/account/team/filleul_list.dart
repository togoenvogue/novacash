import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../helpers/common.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_vertical.dart';

class DownlineList extends StatelessWidget {
  final UserModel filleul;
  DownlineList({this.filleul});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      content: Column(
        children: [
          CustomListVertical(
            label: 'Nom',
            value: filleul.firstName + ' ' + filleul.lastName,
          ),
          CustomHorizontalDiver(),
          CustomListVertical(
            label: 'Cote d\'invitation',
            value: filleul.key,
          ),
          CustomHorizontalDiver(),
          CustomListVertical(
            label: 'Expiration',
            value: DateHelper().formatTimeStamp(filleul.expiry),
          ),
        ],
      ),
    );
  }
}
