import 'package:flutter/material.dart';

import '../../../helpers/common.dart';
import '../../../models/notification.dart';
import '../../../services/notification.dart';
import '../../../widgets/common/custom_list_vertical_clickable.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/empty_folder.dart';

class MessageInboxScreen extends StatefulWidget {
  final String userKey;
  MessageInboxScreen({this.userKey});
  @override
  _MessageInboxScreenState createState() => _MessageInboxScreenState();
}

class _MessageInboxScreenState extends State<MessageInboxScreen> {
  List<NotificationModel> records = [];
  bool isLoading = false;

  void _getRecords({String userKey}) async {
    setState(() {
      isLoading = true;
    });
    var result =
        await NotificationService().getMyNotifications(userKey: userKey);
    setState(() {
      isLoading = false;
    });

    if (result != null && result[0].error != 'No data') {
      setState(() {
        records = result;
      });
    } else {
      setState(() {
        records = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.userKey != null) {
      _getRecords(userKey: widget.userKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 90,
                child: records != null &&
                        records.length > 0 &&
                        isLoading == false
                    ? ListView.builder(
                        itemBuilder: (ctx, index) {
                          return CustomListVerticalClickable(
                            callBack: null,
                            id: records[index].id,
                            label1Color: Color(0xffccebc5),
                            label2Color: Colors.white,
                            label1: DateHelper()
                                .formatTimeStampFull(records[index].timeStamp),
                            label2: records[index].message,
                          );
                        },
                        itemCount: records.length,
                      )
                    : EmptyFolder(
                        isLoading: isLoading,
                        message: 'Aucune notification',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
