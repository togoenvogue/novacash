import 'package:flutter/material.dart';

import '../../components/countryPicker/country_list.dart';
import '../../models/country.dart';
import '../../services/country.dart';
import '../../widgets/common/empty_folder.dart';

class CountryPicker extends StatefulWidget {
  final Function selectedCountry;
  CountryPicker({this.selectedCountry});

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  bool isLoading = false;
  List<CountryModel> records = [];

  void _getCountries() async {
    setState(() {
      isLoading = true;
    });
    var result = await CountryService().getCountries();
    setState(() {
      isLoading = false;
    });

    if (result != null && result[0].error != 'No data') {
      setState(() {
        records = result;
      });
    } else {
      // error alert
    }
  }

  void _countryCode(dynamic selectedCountryCode, String selectedCountryFlag) {
    widget.selectedCountry(selectedCountryCode, selectedCountryFlag);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        child: records != null && records.length == 0
            ? EmptyFolder(isLoading: isLoading)
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return CountryPickerList(
                    country: records[index],
                    selectedCountry: _countryCode,
                  );
                },
                itemCount: records.length,
              ),
      ),
    );
  }
}
