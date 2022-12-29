import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:steamtimespent/gamedatasource.dart';

import '../game.dart';

part 'gamelist_event.dart';
part 'gamelist_state.dart';

//https://medium.com/flutter-community/flutter-bloc-for-beginners-839e22adb9f5

class GamelistBloc extends Bloc<GamelistEvent, AllGamesState> {
  GamelistBloc({
    required this.steamID,
  }) : super(const AllGamesState(
            status: AllGamesStatus.initial, games: GameDataSource.empty)) {
    on<GetGames>(_fetchGamesData);
  }

  String steamID;

  void _fetchGamesData(GetGames event, Emitter<AllGamesState> emit) async {
    try {
      print('Fetching game data');
      emit(state.copyWith(status: AllGamesStatus.loading));
      final gamesResult = await GameDataSource.fetchGames(event.steamid);
      emit(
        state.copyWith(
          status: AllGamesStatus.success,
          games: gamesResult,
        ),
      );
    } catch (error) {
      print(error.toString());
      emit(state.copyWith(status: AllGamesStatus.error));
    }
  }
}
