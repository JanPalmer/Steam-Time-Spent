import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:steamtimespent/gamedatasource.dart';

import '../game.dart';

part 'gamelist_event.dart';
part 'gamelist_state.dart';

//https://medium.com/flutter-community/flutter-bloc-for-beginners-839e22adb9f5

class GameListBloc extends Bloc<GameListEvent, GameListLoadedState> {
  GameListBloc({
    required this.steamID,
  }) : super(const GameListLoadedState(
            status: GameListStatus.initial, games: GameDataSource.empty)) {
    on<GetAllGames>(_fetchGames);
    on<GetRecentGames>(_fetchGames);
  }

  String steamID;

  void _fetchGames(
      GameListEvent event, Emitter<GameListLoadedState> emit) async {
    try {
      final bool fetchAllGames = event.IsAllGamesEvent();

      if (fetchAllGames)
        print('Fetching ALL games');
      else
        print('Fetching RECENT games');

      emit(state.copyWith(status: GameListStatus.loading));
      final gamesResult =
          await GameDataSource.fetchGames(steamID, fetchAllGames);
      emit(
        state.copyWith(
          status: GameListStatus.success,
          games: gamesResult,
        ),
      );
    } catch (error) {
      print(error.toString());
      emit(state.copyWith(status: GameListStatus.error));
    }
  }

  // void _fetchRecentGames(
  //     GetRecentGames event, Emitter<GameListLoadedState> emit) {
  //   _fetchGames(event.steamid, emit, false);
  // }

  // void _fetchGames(
  //   String steamID,
  //   Emitter<GameListLoadedState> emit,
  //   bool fetchAllGames,
  // ) async {
  //   try {
  //     if (fetchAllGames)
  //       print('Fetching ALL games');
  //     else
  //       print('Fetching RECENT games');

  //     emit(state.copyWith(status: GameListStatus.loading));
  //     final gamesResult =
  //         await GameDataSource.fetchGames(steamID, fetchAllGames);
  //     emit(
  //       state.copyWith(
  //         status: GameListStatus.success,
  //         games: gamesResult,
  //       ),
  //     );
  //   } catch (error) {
  //     print(error.toString());
  //     emit(state.copyWith(status: GameListStatus.error));
  //   }
  // }
}
