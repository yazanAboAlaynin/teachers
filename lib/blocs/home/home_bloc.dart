import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:teachers/models/Review.dart';
import 'package:teachers/models/Teacher.dart';
import 'package:teachers/services/FirebaseService.dart';

import '../../constants.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  FirebaseService firebaseService = FirebaseService();
  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is TeachersRequested) {
      yield HomeLoadInProgress();
      try {
        List<Teacher> teachers = await firebaseService.getTeachers();

        yield TeachersLoadSuccess(
          teachers: teachers,
        );
      } catch (_) {
        yield HomeLoadFailure();
      }
    } else if (event is RefreshTeachersRequested) {
      try {
        List<Teacher> teachers = await firebaseService.getTeachers();
        teachers.sort((a, b) => a.rating < b.rating ? 1 : 0);

        yield TeachersLoadSuccess(
          teachers: teachers,
        );
      } catch (_) {
        yield HomeLoadFailure();
      }
    } else if (event is TeacherReviewsRequested) {
      yield HomeLoadInProgress();
      try {
        List<Review> reviews =
            await firebaseService.getTeacherReviews(event.id);

        yield TeacherReviewsLoadSuccess(
          reviews: reviews,
        );
      } catch (_) {
        yield HomeLoadFailure();
      }
    } else if (event is StoreReviewRequested) {
      yield HomeLoadInProgress();
      try {
        Teacher teacher = await firebaseService.addReview(
          date: event.date,
          ratedTeacher: event.ratedTeacher,
          rating: event.rating,
          ratingUser: event.ratingUser,
          review: event.review,
        );

        yield AddReviewLoadSuccess(
          teacher: teacher,
        );
      } catch (_) {
        yield HomeLoadFailure();
      }
    }
  }
}
