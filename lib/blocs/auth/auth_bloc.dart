import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teachers/services/FirebaseService.dart';

import '../../constants.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseService firebaseService = FirebaseService();
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthRequested) {
      yield AuthLoadInProgress();
      try {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        bool isAuth = false;
        if (sharedPreferences.containsKey('isAuth')) {
          isAuth = await sharedPreferences.getBool('isAuth');
          ID = sharedPreferences.getString('user_id');
          ISAuth = isAuth;
        }

        if (isAuth) {
          yield Authenticated();
        } else {
          yield NotAuthenticated();
        }
      } catch (_) {
        yield AuthLoadFailure();
      }
    } else if (event is LoginRequested) {
      yield AuthLoadInProgress();
      try {
        bool ans = await firebaseService.login(event.email, event.password);
        if (ans) {
          yield Authenticated();
        } else {
          yield NotAuthenticated();
        }
      } catch (_) {
        yield AuthLoadFailure();
      }
    }
    //  else if (event is RegisterRequested) {
    //   yield AuthLoadInProgress();
    //   try {
    //     var data = {
    //       'email': event.email,
    //       'password': event.password,
    //       'phone': event.phone,
    //       'first_name': event.fname,
    //       'last_name': event.lname,
    //       'city_id': event.city_id
    //     };
    //     Map ans = await authApi.register(data);
    //     if (ans['status']) {
    //       yield NotAuthenticated();
    //     } else {
    //       yield NotAuthenticated();
    //     }
    //   } catch (_) {
    //     yield AuthLoadFailure();
    //   }
    // } else if (event is LogoutRequested) {
    //   yield AuthLoadInProgress();
    //   try {
    //     SharedPreferences sharedPreferences =
    //         await SharedPreferences.getInstance();
    //     sharedPreferences.remove('token');
    //     sharedPreferences.setBool('isAuth', false);
    //     sharedPreferences.remove('user');
    //     bool ans = false;
    //     ISAuth = false;

    //     if (ans) {
    //       yield Authenticated();
    //     } else {
    //       yield NotAuthenticated();
    //     }
    //   } catch (_) {
    //     yield AuthLoadFailure();
    //   }
    // }
  }
}
