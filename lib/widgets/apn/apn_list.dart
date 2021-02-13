import 'package:flutter/material.dart';
import 'apn_item.dart';
import '../../models/apn.dart';
import '../../widgets/common/empty_folder.dart';

class ApnList extends StatelessWidget {
  final List<ApnModel> records;
  ApnList({this.records});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 300,
        child: records != null && records.length == 0
            ? EmptyFolder()
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return ApnListItem(
                    apn: records[index],
                  );
                },
                itemCount: records.length,
              ),
      ),
    );
  }
}
