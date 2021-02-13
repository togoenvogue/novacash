import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';

import '../../../helpers/common.dart';

class ReviewDetail extends StatelessWidget {
  final String detail;
  final int rating;
  final String name;
  final String country;
  final int date;
  ReviewDetail({
    this.detail,
    this.rating,
    this.country,
    this.date,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            DateHelper().formatTimeStampFull(date),
            style: TextStyle(
                fontSize: 14, color: Colors.redAccent.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
          Text(
            country,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            detail,
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          RatingBar(
            rating: rating * 1.0,
            icon: Icon(
              Icons.star,
              size: 40,
              color: Colors.grey,
            ),
            starCount: 5,
            spacing: 5.0,
            size: 40,
            isIndicator: true,
            allowHalfRating: true,
            onRatingCallback: null,
            color: Colors.amber,
          )
        ],
      ),
    );
  }
}
