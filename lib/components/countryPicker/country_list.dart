import 'package:flutter/material.dart';

import '../../config/configuration.dart';
import '../../models/country.dart';
import '../../widgets/common/custom_horizontal_diver.dart';

class CountryPickerList extends StatefulWidget {
  final CountryModel country;
  final Function selectedCountry;
  CountryPickerList({this.country, this.selectedCountry});

  @override
  _CountryPickerListState createState() => _CountryPickerListState();
}

class _CountryPickerListState extends State<CountryPickerList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.selectedCountry(
          widget.country.countryCode,
          widget.country.countryFlag,
        );
      },
      splashColor: Colors.white,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Container(
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  image: NetworkImage(
                            '$flagUrl/${widget.country.countryFlag.toLowerCase()}.png',
                          ) ==
                          null
                      ? Image.asset('assets/images/placeholder.png')
                      : NetworkImage(
                          '$flagUrl/${widget.country.countryFlag.toLowerCase()}.png',
                        ),
                ),
                width: 40,
              ),
              SizedBox(width: 5),
              Container(
                child: Text(
                  '+${widget.country.countryCode.toString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width: 55,
              ),
              Container(
                child: Text(
                  widget.country.countryName.length <= 26
                      ? widget.country.countryName
                      : widget.country.countryName.substring(0, 26),
                ),
              ),
              CustomHorizontalDiver(),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.15),
            ),
          ),
        ),
      ),
    );
  }
}
