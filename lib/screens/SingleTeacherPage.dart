import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:teachers/blocs/home/home_bloc.dart';
import 'package:teachers/blocs/home/home_event.dart';
import 'package:teachers/blocs/home/home_state.dart';
import 'package:teachers/models/Review.dart';
import 'package:teachers/models/Teacher.dart';
import 'package:teachers/widgets/ReviewCard.dart';

import '../config.dart';

class SingleTeacherPage extends StatefulWidget {
  @override
  _SingleTeacherPageState createState() => _SingleTeacherPageState();
}

class _SingleTeacherPageState extends State<SingleTeacherPage> {
  Teacher teacher;
  HomeBloc homeBloc;
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc();
  }

  @override
  Widget build(BuildContext context) {
    final sizeAware = MediaQuery.of(context).size;
    Map args = ModalRoute.of(context).settings.arguments;
    teacher = args['teacher'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Profile'),
        centerTitle: true,
        backgroundColor: Config.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: sizeAware.width,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/teacher.jpg'),
                  radius: sizeAware.width * 0.15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(teacher.name),
              SizedBox(
                height: 10,
              ),
              //avg rating
              SmoothStarRating(
                rating: teacher.rating,
                size: sizeAware.width * 0.08,
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
              SizedBox(
                height: 30,
              ),
              Container(
                width: sizeAware.width,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reviews',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlocBuilder(
                        cubit: homeBloc,
                        builder: (context, state) {
                          if (state is HomeInitial) {
                            homeBloc
                                .add(TeacherReviewsRequested(id: teacher.id));
                          }
                          if (state is HomeLoadInProgress) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is TeacherReviewsLoadSuccess) {
                            reviews = state.reviews;
                            return reviews.length == 0
                                ? Center(
                                    child: Text('No reviews'),
                                  )
                                : ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: reviews
                                        .map(
                                          (e) => ReviewCard(
                                            review: e,
                                          ),
                                        )
                                        .toList(),
                                  );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
