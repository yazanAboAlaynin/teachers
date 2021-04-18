import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:teachers/blocs/auth/auth_bloc.dart';
import 'package:teachers/blocs/auth/auth_event.dart';
import 'package:teachers/blocs/auth/auth_state.dart';
import 'package:teachers/blocs/home/home_bloc.dart';
import 'package:teachers/blocs/home/home_event.dart';
import 'package:teachers/blocs/home/home_state.dart';
import 'package:teachers/constants.dart';
import 'package:teachers/models/Teacher.dart';
import 'package:teachers/services/FirebaseService.dart';

import '../config.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc homeBloc;
  AuthBloc authBloc;
  List<Teacher> teachers = [];

  @override
  void initState() {
    homeBloc = HomeBloc();
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(AuthRequested());
    homeBloc.add(TeachersRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
        centerTitle: true,
        backgroundColor: Config.primaryColor,
      ),
      body: BlocBuilder(
        cubit: homeBloc,
        builder: (context, state) {
          if (state is HomeLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HomeLoadFailure) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (state is TeachersLoadSuccess || state is AddReviewLoadSuccess) {
            if (state is TeachersLoadSuccess) {
              teachers = state.teachers;
            }
            if (state is AddReviewLoadSuccess) {
              for (int i = 0; i < teachers.length; i++) {
                if (state.teacher.id == teachers[i].id) {
                  teachers[i] = state.teacher;
                }
              }
            }
            return SingleChildScrollView(
              child: Column(
                children: teachers
                    .map(
                      (e) => TeacherCard(
                        teacher: e,
                        homeBloc: homeBloc,
                        authBloc: authBloc,
                      ),
                    )
                    .toList(),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class TeacherCard extends StatefulWidget {
  final Teacher teacher;
  final HomeBloc homeBloc;
  final AuthBloc authBloc;

  TeacherCard({Key key, this.teacher, this.homeBloc, this.authBloc})
      : super(key: key);

  @override
  _TeacherCardState createState() => _TeacherCardState();
}

class _TeacherCardState extends State<TeacherCard> {
  double rating = 1;

  TextEditingController review = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeAware = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.black26,
              offset: Offset(1, 2),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(widget.teacher.name)),
              IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/singleTeacher', arguments: {
                    'teacher': widget.teacher,
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              BlocBuilder(
                cubit: widget.authBloc,
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      if (state is Authenticated) {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text("Rate this teacher"),
                              content: Container(
                                height: 300,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SmoothStarRating(
                                        rating: rating,
                                        size: sizeAware.width * 0.08,
                                        filledIconData: Icons.star,
                                        halfFilledIconData: Icons.star_half,
                                        defaultIconData: Icons.star_border,
                                        starCount: 5,
                                        allowHalfRating: false,
                                        spacing: 2.0,
                                        color: Colors.amber,
                                        onRated: (value) {
                                          value = value.roundToDouble();
                                          print("rating value -> $value");
                                          // setState(() {
                                          rating = value;
                                          // });
                                        },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          hintText: 'Write your review here...',
                                          fillColor: Colors.grey[100],
                                          border: InputBorder.none,
                                        ),
                                        controller: review,
                                        minLines: 5,
                                        maxLines: 10,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      RaisedButton(
                                        color: Config.primaryColor,
                                        onPressed: () {
                                          if (review.text.length > 0) {
                                            widget.homeBloc
                                                .add(StoreReviewRequested(
                                              ratedTeacher: widget.teacher.id,
                                              date: DateTime.now(),
                                              rating: rating,
                                              ratingUser: ID,
                                              review: review.text,
                                            ));
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text(
                                          'ADD',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      } else {
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text("You have to login first"),
                            content: Container(
                              height: 100,
                              child: Column(
                                children: [
                                  RaisedButton(
                                    color: Config.primaryColor,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
