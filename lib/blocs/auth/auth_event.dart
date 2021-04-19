abstract class AuthEvent {
  const AuthEvent();
}

class AuthRequested extends AuthEvent {
  const AuthRequested();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested({this.email, this.password});

  @override
  List<Object> get props => [];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const RegisterRequested({
    this.email,
    this.password,
  });

  @override
  List<Object> get props => [];
}

class LogoutRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}
