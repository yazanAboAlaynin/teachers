import 'package:flutter/material.dart';
import 'package:teachers/screens/HomePage.dart';
import 'package:teachers/screens/LoginPage.dart';
import 'package:teachers/screens/SingleTeacherPage.dart';

class Routes {
  static Map<String, WidgetBuilder> getAll() {
    return {
      "/homePage": (context) => HomePage(),
      "/singleTeacher": (context) => SingleTeacherPage(),
      "/login": (context) => LoginPage(),
    };
  }
}
