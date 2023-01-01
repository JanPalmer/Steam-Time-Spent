import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:steamtimespent/HLTB/howlongtobeat.dart';
import 'package:steamtimespent/gamedatasource.dart';

import '../game.dart';

part 'gamelist_event.dart';
part 'gamelist_state.dart';

//https://medium.com/flutter-community/flutter-bloc-for-beginners-839e22adb9f5

class GameListBloc extends Bloc<GameListEvent, GameListLoadedState> {
  GameListBloc({
    required this.steamID,
  }) : super(const GameListLoadedState(
          recentGames: GameDataSource.emptyGame,
          allGames: GameDataSource.emptyGame,
          recentGamesEntries: GameDataSource.emptyHLTBEntry,
          allGamesEntries: GameDataSource.emptyHLTBEntry,
          recentStatus: GameListStatus.initial,
          allStatus: GameListStatus.initial,
        )) {
    on<GetGames>(_fetchGames);
  }

  String steamID;

  void _fetchGames(
      GameListEvent event, Emitter<GameListLoadedState> emit) async {
    try {
      // Emit Loading Status
      emit(state.copyWith(
        recentStatus: GameListStatus.loading,
        allStatus: GameListStatus.loading,
      ));
      // Fetch recent games data from Steam
      final recentGames = await GameDataSource.fetchGames(steamID, false);
      emit(
        state.copyWith(
          recentGames: recentGames,
        ),
      );
      // Fetch all games data from Steam
      final allGames = await GameDataSource.fetchGames(steamID, true);
      emit(
        state.copyWith(
          allGames: allGames,
        ),
      );
      // Fetch recent games data entries from HLTB
      final recentGameEntries =
          await GameDataSource.fetchHLTBEntries(recentGames);
      emit(
        state.copyWith(
          recentGamesEntries: recentGameEntries,
          recentStatus: GameListStatus.success,
        ),
      );
      // Fetch all games data entries from HLTB (in sets of 10)
      Map<String, HowLongToBeatEntry> allGameEntries = {};
      for (int i = 0; i < allGames.length; i += 10) {
        Map<String, HowLongToBeatEntry> tmpList =
            await GameDataSource.fetchHLTBEntries(
                allGames.sublist(i, min(i + 9, allGames.length)));
        allGameEntries.addAll(tmpList);
        emit(
          state.copyWith(
            allGamesEntries: allGameEntries,
            allStatus: GameListStatus.success,
          ),
        );
      }
    } catch (error) {
      print(error.toString());
      emit(state.copyWith(
        recentStatus: GameListStatus.error,
        allStatus: GameListStatus.error,
      ));
    }
  }
}
