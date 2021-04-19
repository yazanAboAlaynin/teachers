import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teachers/blocs/auth/auth_bloc.dart';
import 'package:teachers/blocs/auth/auth_event.dart';
import 'package:teachers/blocs/auth/auth_state.dart';

import '../config.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isVis = true;

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final sizeAware = MediaQuery.of(context).size;
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener(
      cubit: authBloc,
      listener: (context, state) {
        if (state is Authenticated) {
          Fluttertoast.showToast(msg: 'you are logged in');
          Navigator.popUntil(context, (route) => route.isFirst);
        }
        if (state is NotAuthenticated) {
          Fluttertoast.showToast(msg: 'Wrong email');
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Config.primaryColor,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                width: sizeAware.width,
                height: sizeAware.height,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: sizeAware.height * 0.1,
                    ),
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Config.primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: sizeAware.height * 0.01,
                    ),
                    TextFormField(
                      controller: emailTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (String arg) {
                        if (arg.length <= 0)
                          return 'Email is required';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordTextEditingController,
                      obscureText: isVis,
                      validator: (String arg) {
                        if (arg.length <= 0)
                          return 'Password is required';
                        else
                          return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              isVis = !isVis;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeAware.height * 0.03,
                    ),
                    Container(
                      width: sizeAware.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BlocBuilder(
                            cubit: authBloc,
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    authBloc.add(
                                      RegisterRequested(
                                        email: emailTextEditingController.text
                                            .trim(),
                                        password: passwordTextEditingController
                                            .text
                                            .trim(),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: sizeAware.width * 0.85,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Config.primaryColor,
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(40),
                                      right: Radius.circular(40),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        state is AuthLoadInProgress
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Text(
                                                'Register',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: sizeAware.height * 0.02,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Container(
                              width: sizeAware.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Config.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: sizeAware.height * 0.2,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
