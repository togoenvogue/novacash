import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import '../../widgets/common/custom_button.dart';
import '../../models/country.dart';
import '../../config/configuration.dart';

class CountryListItem extends StatelessWidget {
  final CountryModel country;
  final Function callBack;

  CountryListItem({
    this.country,
    this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
          //top: BorderSide(width: 0, color: MyColors().normal),
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            decoration: BoxDecoration(
              color: Colors.white,
              //borderRadius: BorderRadius.circular(100),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Image.network(
                '$flagUrl/${country.countryFlag.toLowerCase()}.png'),
            height: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                country.countryName,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              //Text('Cliquez sur choisir'),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CustomButton(
                    buttonRadius: 10,
                    color: Colors.white,
                    textStyle: TextStyle(
                      color: MyColors().info,
                      fontSize: 12,
                    ),
                    borderColor: MyColors().info,
                    text: 'Choisir',
                    onPressed: () {
                      callBack(
                        countryFlag: country.countryFlag,
                        countryName: country.countryName,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
