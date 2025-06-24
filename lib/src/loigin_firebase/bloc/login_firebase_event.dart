part of 'login_firebase_bloc.dart';

abstract class LoginFirebaseEvent extends Equatable {
  const LoginFirebaseEvent();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginFirebaseEvent {
  const LoginInitial();
}

class LoginWithEmail extends LoginFirebaseEvent {
  final String email;
  final String password;

  const LoginWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends LoginFirebaseEvent {
  const LogoutRequested();
}

class SignUpWithEmail extends LoginFirebaseEvent {
  final String email;
  final String password;

  const SignUpWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
