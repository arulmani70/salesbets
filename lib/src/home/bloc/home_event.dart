part of "home_bloc.dart";

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class InitializeHomePage extends HomePageEvent {
  const InitializeHomePage();
}

class PlaceBet extends HomePageEvent {
  final BetModel bet;

  const PlaceBet(this.bet);

  @override
  List<Object> get props => [bet];
}

class LoadBets extends HomePageEvent {
  const LoadBets();
}
