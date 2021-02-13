import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class CustomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'Chargement en cours',
            style: TextStyle(
              color: MyColors().primary,
            ),
          ),
          SizedBox(height: 6),
          CircularProgressIndicator(
            backgroundColor: MyColors().primary,
            strokeWidth: 3,
          ),
        ],
      ),
    );
  }
}
