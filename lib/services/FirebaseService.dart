import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teachers/constants.dart';
import 'package:teachers/models/Review.dart';
import 'package:teachers/models/Teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //get all teachers
  Future<List<Teacher>> getTeachers() async {
    QuerySnapshot teachers =
        await FirebaseFirestore.instance.collection('teachers').get();
    return teachers.docs
        .map((qShot) => Teacher(
              id: qShot.id,
              email: qShot.data()['email'],
              name: qShot.data()['name'],
              phone: qShot.data()['phone'],
              rating: double.parse(qShot.data()['rating'].toString()),
              username: qShot.data()['username'],
            ))
        .toList();
  }

  //get reviews of single teacher
  Future<List<Review>> getTeacherReviews(teacher_id) async {
    QuerySnapshot reviews = await FirebaseFirestore.instance
        .collection('reviews')
        .where("ratedTeacher", isEqualTo: teacher_id)
        .get();
    return reviews.docs
        .map((qShot) => Review(
              id: qShot.id,
              date: qShot.data()['date'].toString(),
              ratedTeacher: qShot.data()['ratedTeacher'],
              ratingUser: qShot.data()['ratingUser'],
              review: qShot.data()['review'],
              rating: double.parse(
                qShot.data()['rating'].toString(),
              ),
            ))
        .toList();
  }

  Future<bool> login(email, password) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('user_id', user.uid);
        sharedPreferences.setBool('isAuth', true);
        ID = user.uid;
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (_) {}
    return false;
  }

  Future<bool> register(email, password) async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('user_id', user.uid);
        sharedPreferences.setBool('isAuth', true);
        ID = user.uid;
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (_) {}
    return false;
  }

  // add review for teacher
  Future<Teacher> addReview(
      {ratedTeacher, ratingUser, rating, review, date}) async {
    DocumentReference ref =
        await FirebaseFirestore.instance.collection("reviews").add({
      'ratedTeacher': ratedTeacher,
      'ratingUser': ratingUser,
      'rating': rating,
      'review': review,
      'date': date,
    });
    //get all teacher reviews to calculate the new rating avg
    QuerySnapshot reviews = await FirebaseFirestore.instance
        .collection('reviews')
        .where("ratedTeacher", isEqualTo: ratedTeacher)
        .get();
    double avg = 0;

    reviews.docs.forEach((e) {
      avg += e.data()['rating'];
    });
    avg /= reviews.docs.length;
    //update teacher rating
    await FirebaseFirestore.instance
        .collection("teachers")
        .doc(ratedTeacher)
        .update({
      'rating': avg,
    });
    DocumentSnapshot teacher = await FirebaseFirestore.instance
        .collection("teachers")
        .doc(ratedTeacher)
        .get();

    return Teacher(
      id: teacher.id,
      email: teacher.data()['email'],
      name: teacher.data()['name'],
      phone: teacher.data()['phone'],
      rating: double.parse(teacher.data()['rating'].toString()),
      username: teacher.data()['username'],
    );
  }
}
