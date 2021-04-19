abstract class AuthState {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoadInProgress extends AuthState {}

class Authenticated extends AuthState {}

class NotAuthenticated extends AuthState {}

class AuthLoadFailure extends AuthState {}
