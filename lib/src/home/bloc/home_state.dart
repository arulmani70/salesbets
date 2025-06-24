part of 'home_bloc.dart';

enum HomePageStatus {
  initial,
  loading,
  success,
  failure,
  updateMenu,
  updateContent,
}

enum MenuStatus { open, shrunk, closed }

final class HomePageState extends Equatable {
  final HomePageStatus status;
  final String? message;
  final Map<String, dynamic> homePageData;
  final List<BetModel> bets;
  final UsersModel user;

  const HomePageState({
    required this.status,
    required this.homePageData,
    required this.bets,
    required this.user,

    this.message,
  });

  static final initial = HomePageState(
    message: "",
    homePageData: const {},
    status: HomePageStatus.initial,

    bets: const [],
    user: UsersModel.empty(),
  );

  HomePageState copyWith({
    String Function()? message,

    Map<String, dynamic> Function()? homePageData,
    List<BetModel>? bets,
    HomePageStatus Function()? status,
    UsersModel? user,
    String Function()? selectedDataFilter,
  }) {
    return HomePageState(
      status: status != null ? status() : this.status,

      homePageData: homePageData != null ? homePageData() : this.homePageData,
      bets: bets ?? this.bets,
      user: user ?? this.user,
      message: message != null ? message() : this.message,
    );
  }

  @override
  List<Object?> get props => [status, homePageData, bets, user];
}
