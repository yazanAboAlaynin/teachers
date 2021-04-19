import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:teachers/models/Review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({Key key, this.review}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sizeAware = MediaQuery.of(context).size;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(review.ratingUser),
              SmoothStarRating(
                rating: review.rating,
                size: sizeAware.width * 0.06,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                starCount: 5,
                spacing: 2.0,
                isReadOnly: true,
                color: Colors.amber,
                onRated: (value) {
                  value = value.roundToDouble();
                  print("rating value -> $value");
                },
              ),
              // Text(review.date),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(review.review),
          Divider(),
        ],
      ),
    );
  }
}
