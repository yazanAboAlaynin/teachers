import 'package:meta/meta.dart';
import 'package:teachers/models/Review.dart';
import 'package:teachers/models/Teacher.dart';

abstract class HomeState {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadInProgress extends HomeState {}

class TeachersLoadSuccess extends HomeState {
  final List<Teacher> teachers;

  TeachersLoadSuccess({
    this.teachers,
  });
}

class AddReviewLoadSuccess extends HomeState {
  final Teacher teacher;

  AddReviewLoadSuccess({
    this.teacher,
  });
}

class TeacherReviewsLoadSuccess extends HomeState {
  final List<Review> reviews;

  TeacherReviewsLoadSuccess({
    this.reviews,
  });
}

class HomeLoadFailure extends HomeState {}
