part of 'base_bloc.dart';

enum BaseStatus { initial, syncing, completed, error, requestPermission }

class BaseState extends Equatable {
  final BaseStatus status;
  final List<UserRole> userRoleList;
  final String? message;

  const BaseState({
    required this.status,
    required this.userRoleList,
    this.message,
  });

  static const initial = BaseState(
    status: BaseStatus.initial,
    userRoleList: [],
    message: null,
  );

  BaseState copyWith({
    BaseStatus Function()? status,
    List<UserRole> Function()? userRoleList,
    String Function()? message,
  }) {
    return BaseState(
      status: status != null ? status() : this.status,
      userRoleList: userRoleList != null ? userRoleList() : this.userRoleList,
      message: message != null ? message() : this.message,
    );
  }

  @override
  List<Object?> get props => [status, userRoleList, message];
}
