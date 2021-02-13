import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class CustomFaq extends StatelessWidget {
  final String question;
  final String response;
  CustomFaq({this.question, this.response});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpandablePanel(
        header: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            question,
            style: TextStyle(
              fontSize: 16,
              color: MyColors().primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        expanded: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Text(
            response,
            softWrap: true,
            style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.9),
                height: 1.2),
          ),
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: MyColors().primary.withOpacity(0.4),
          ),
        ),
      ),
      margin: EdgeInsets.only(
        bottom: 10,
      ),
    );
  }
}
