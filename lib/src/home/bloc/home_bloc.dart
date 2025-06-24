import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesbets/src/home/repo/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:salesbets/src/common/models/models.dart';
import 'package:logger/logger.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final HomePageRepository _repository;
  final log = Logger();

  HomePageBloc({required HomePageRepository repository})
    : _repository = repository,
      super(HomePageState.initial) {
    on<InitializeHomePage>(_onInitializeHomePageToState);
    on<PlaceBet>(_onPlaceBet);
    on<LoadBets>(_onLoadBets);
  }

  Future<void> _onInitializeHomePageToState(
    HomePageEvent event,
    Emitter<HomePageState> emit,
  ) async {
    try {
      log.d("HomePageBloc:::_onInitializeHomePageToState::event: $event");
      emit(state.copyWith(status: () => HomePageStatus.loading));

      Map<String, dynamic> homePageData = await _repository.getHomePageData();
      final bets = await _repository.getAllBets();
      final user = await _repository.getUserFromPreferences();

      emit(
        state.copyWith(
          status: () => HomePageStatus.success,
          homePageData: () => homePageData,
          bets: bets,
          user: user,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: () => HomePageStatus.failure,
          message: () => error.toString(),
        ),
      );
    }
  }

  Future<void> _onPlaceBet(PlaceBet event, Emitter<HomePageState> emit) async {
    try {
      await _repository.addBet(event.bet);
      add(const LoadBets());
    } catch (e) {
      log.e("Failed to place bet: $e");
    }
  }

  Future<void> _onLoadBets(LoadBets event, Emitter<HomePageState> emit) async {
    try {
      final bets = await _repository.getAllBets();
      log.d("HomePageBloc:::_onLoadBets::bets: $bets");
      emit(state.copyWith(bets: bets, status: () => HomePageStatus.success));
    } catch (e) {
      log.e("Failed to load bets: $e");
    }
  }
}
