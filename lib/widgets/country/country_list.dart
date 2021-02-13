import 'package:flutter/material.dart';
import '../../models/country.dart';
import '../../widgets/common/empty_folder.dart';
import 'country_list_item.dart';

class CountryList extends StatelessWidget {
  final List<CountryModel> records;
  final Function callBack;

  CountryList({this.records, this.callBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: records != null && records.length == 0
          ? EmptyFolder()
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return CountryListItem(
                  country: records[index],
                  callBack: callBack,
                );
              },
              itemCount: records.length,
            ),
    );
  }
}
