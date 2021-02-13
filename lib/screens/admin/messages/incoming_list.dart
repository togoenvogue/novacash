import 'package:flutter/material.dart';

import '../../../styles/styles.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';

class IncomingUssdList extends StatefulWidget {
  final String sender;
  final String message;
  final Function callBack;
  IncomingUssdList({this.callBack, this.message, this.sender});

  @override
  _IncomingUssdListState createState() => _IncomingUssdListState();
}

class _IncomingUssdListState extends State<IncomingUssdList> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Colors.white,
      content: Column(
        children: [
          CustomListSpaceBetwen(
            label: 'Sender',
            value: widget.sender,
          ),
          CustomHorizontalDiver(),
          SizedBox(height: 5),
          SelectableText(widget.message),
          SizedBox(height: 5),
          CustomFlatButtonRounded(
            label: 'Send to Server',
            borderRadius: 50,
            function: () {
              widget.callBack(sender: widget.sender, message: widget.message);
            },
            bgColor: MyColors().primary,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
