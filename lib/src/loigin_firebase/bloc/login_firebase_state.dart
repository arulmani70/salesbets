part of 'login_firebase_bloc.dart';

enum LoginFirebaseStatus { initial, loading, loggedIn, failure, loggedOut }

class LoginFirebaseState extends Equatable {
  final LoginFirebaseStatus status;
  final String message;
  final UsersModel user;
  const LoginFirebaseState({
    required this.status,
    required this.message,
    required this.user,
  });

  factory LoginFirebaseState.initial() => LoginFirebaseState(
    status: LoginFirebaseStatus.initial,
    message: "",
    user: UsersModel.empty(),
  );

  LoginFirebaseState copyWith({
    LoginFirebaseStatus? status,
    String Function()? message,
    UsersModel Function()? user,
  }) {
    return LoginFirebaseState(
      status: status ?? this.status,
      message: message != null ? message() : this.message,
      user: user != null ? user() : this.user,
    );
  }

  @override
  List<Object?> get props => [status];
}
