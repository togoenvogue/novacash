import 'package:flutter/material.dart';
import '../../models/apn.dart';
import '../../widgets/common/empty_folder.dart';
import 'apn_item.dart';

class ApnList extends StatelessWidget {
  final List<ApnModel> records;
  final String countryName;
  ApnList({this.records, this.countryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 380,
      child: records != null && records.length == 0
          ? EmptyFolder(
              message: 'Nous n\avons aucun point focal au $countryName',
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return ApnListItem(
                  apn: records[index],
                );
              },
              itemCount: records.length,
            ),
    );
  }
}
