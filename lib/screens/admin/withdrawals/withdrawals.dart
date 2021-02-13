import 'package:flutter/material.dart';

import '../../../styles/styles.dart';
import '../../../helpers/common.dart';
import '../../../models/withdrawal.dart';
import '../../../screens/admin/withdrawals/withdrawal_list.dart';
import '../../../services/ussd.dart';
import '../../../widgets/common/empty_folder.dart';

class AdminWithdrawalsScreen extends StatefulWidget {
  @override
  _AdminWithdrawalsScreenState createState() => _AdminWithdrawalsScreenState();
}

class _AdminWithdrawalsScreenState extends State<AdminWithdrawalsScreen> {
  bool isLoading = false;
  int _selectedDate;
  List<WithdrawalModel> records = [];

  void _getRecords({int day, int month, int year}) async {
    setState(() {
      isLoading = true;
    });
    var result = await UssdService()
        .mobileWithdrawals(day: day, month: month, year: year);
    setState(() {
      isLoading = false;
    });
    if (result != null && result[0].error != 'No data') {
      setState(() {
        records = result;
      });
    }
  }

  void _openDatePicker() {
    showDatePicker(
      context: context,
      locale: const Locale("fr", "FR"),
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now().add(Duration(days: 2)),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        var year = int.parse(value.toString().substring(0, 4));
        var month = int.parse(value.toString().substring(5, 7));
        var day = int.parse(value.toString().substring(8, 10));

        setState(() {
          _selectedDate = DateTime.parse(value.toString())
              .millisecondsSinceEpoch; // 1609718400000
          isLoading = true;
        });
        _getRecords(day: day, month: month, year: year);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    var date = new DateTime.now();
    var year = int.parse(date.toString().substring(0, 4));
    var month = int.parse(date.toString().substring(5, 7));
    var day = int.parse(date.toString().substring(8, 10));
    _selectedDate = DateTime.now().millisecondsSinceEpoch;
    _getRecords(day: day, month: month, year: year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedDate == null
              ? 'Demandes de retrait'
              : DateHelper().formatTimeStamp(_selectedDate),
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              _openDatePicker();
            },
            tooltip: 'Chercher',
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: records.length > 0 && isLoading == false
              ? Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return AdminWithdrawalList(
                            wdl: records[index],
                          );
                        },
                        itemCount: records.length,
                      ),
                    ),
                  ],
                )
              : EmptyFolder(
                  isLoading: isLoading,
                  message: 'Aucune demande de retrait',
                ),
        ),
      ),
    );
  }
}
