import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../styles/styles.dart';
import '../../../screens/admin/messages/incoming_list.dart';
import '../../../services/ussd.dart';

class AdminIncomingUssdScreen extends StatefulWidget {
  @override
  _AdminIncomingUssdScreenState createState() =>
      _AdminIncomingUssdScreenState();
}

class _AdminIncomingUssdScreenState extends State<AdminIncomingUssdScreen> {
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> messages = [];
  bool isLoading = false;

  void _sendToServer({String sender, String message}) async {
    setState(() {
      isLoading = true;
    });
    var result = await UssdService().processNewPaymentMessage(
      message: message,
      sender: sender,
    );
    setState(() {
      isLoading = false;
    });
    if (result.error != null) {
      CustomAlert(
        colorBg: Colors.yellow[100],
        colorText: Colors.black,
      ).alert(
        context,
        'Server Said',
        result.error,
        true,
      );
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Succès',
        'La transaction a été enregistrée avec succès sur le serveur',
        true,
      );
    }
  }

  void _getMessages() async {
    setState(() {
      isLoading = true;
    });
    var result = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
        filter: SmsFilter.where(SmsColumn.ADDRESS)
            .equals("OrangeMoney")
            .or(SmsColumn.ADDRESS)
            .equals("MOOV MONEY"),
        sortOrder: [
          OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC),
          OrderBy(SmsColumn.BODY)
        ]);
    setState(() {
      isLoading = false;
    });
    // get the result
    if (result != null) {
      setState(() {
        messages = result;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'USSD Incoming Message',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: messages.length > 0 && isLoading == false
              ? Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return IncomingUssdList(
                            callBack: _sendToServer,
                            message:
                                messages[index].body.replaceAll("\n", ". "),
                            sender: messages[index].address,
                          );
                        },
                        itemCount: messages.length,
                      ),
                    ),
                  ],
                )
              : EmptyFolder(
                  isLoading: isLoading,
                  message: 'Aucun SMS dans ce téléphone',
                ),
        ),
      ),
    );
  }
}
