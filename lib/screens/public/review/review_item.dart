import 'package:flutter/material.dart';

import '../../../config/configuration.dart';
import '../../../helpers/common.dart';
import '../../../screens/public/review/review_detail.dart';
import '../../../models/review.dart';

class ReviewListItem extends StatelessWidget {
  final ReviewModel review;

  ReviewListItem({this.review});

  void _openDetailModal({
    BuildContext ctx,
    String detail,
    int rating,
    String name,
    String country,
    int date,
  }) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return ReviewDetail(
          detail: detail,
          rating: rating,
          country: country,
          date: date,
          name: name,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return review != null && review.userKey != null
        ? InkWell(
            onTap: () {
              _openDetailModal(
                ctx: context,
                detail: review.detail,
                rating: review.rate,
                country: review.userKey['countryName'],
                date: review.timeStamp,
                name: review.userKey['fullName'],
              );
            },
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1, color: Colors.black.withOpacity(0.1)),
                  //top: BorderSide(width: 0, color: MyColors().normal),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    child: Image.network(
                      review.userKey['picture'],
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userKey['fullName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        DateHelper().formatTimeStamp(review.timeStamp),
                        style: TextStyle(
                          color: Colors.redAccent.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text('${review.detail.substring(0, 30)} ...'),
                    ],
                  ),
                  Expanded(
                    child: Image.network(
                      '$flagUrl/${review.userKey['countryFlag'].toLowerCase()}.png',
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Text(
              'No data',
            ),
          );
  }
}
