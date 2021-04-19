import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:teachers/blocs/auth/auth_bloc.dart';
import 'package:teachers/blocs/auth/auth_event.dart';
import 'package:teachers/blocs/auth/auth_state.dart';
import 'package:teachers/blocs/home/home_bloc.dart';
import 'package:teachers/blocs/home/home_event.dart';
import 'package:teachers/blocs/home/home_state.dart';
import 'package:teachers/models/Teacher.dart';
import 'package:teachers/widgets/TeacherCard.dart';

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
    authBloc.add(AuthRequested()); //get current user status
    homeBloc.add(TeachersRequested()); // get teachers list from firebase
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
        centerTitle: true,
        backgroundColor: Config.primaryColor,
        actions: [
          BlocBuilder(
            cubit: authBloc,
            builder: (context, state) {
              if (state is Authenticated) {
                return IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    authBloc.add(LogoutRequested());
                  },
                );
              }
              if (state is NotAuthenticated) {
                return IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                );
              }
              return Container();
            },
          ),
        ],
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
                  teachers[i] = state.teacher; //update teacher data
                }
              }
            }
            return RefreshIndicator(
              onRefresh: () {
                homeBloc.add(RefreshTeachersRequested());
                return Future.delayed(Duration(seconds: 1));
              },
              child: ListView(
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
