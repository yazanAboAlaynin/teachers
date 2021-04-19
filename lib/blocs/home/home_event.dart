import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class TeachersRequested extends HomeEvent {
  const TeachersRequested();

  @override
  List<Object> get props => [];
}

class RefreshTeachersRequested extends HomeEvent {
  const RefreshTeachersRequested();

  @override
  List<Object> get props => [];
}

class TeacherReviewsRequested extends HomeEvent {
  final String id;
  const TeacherReviewsRequested({this.id});

  @override
  List<Object> get props => [];
}

class StoreReviewRequested extends HomeEvent {
  final String ratedTeacher;
  final String ratingUser;
  final double rating;
  final String review;
  final DateTime date;
  const StoreReviewRequested(
      {this.ratedTeacher,
      this.ratingUser,
      this.rating,
      this.review,
      this.date});

  @override
  List<Object> get props => [];
}
