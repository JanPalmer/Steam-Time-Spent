import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:steamtimespent/HLTB/howlongtobeat.dart';
import 'package:steamtimespent/gamedatasource.dart';
import 'dart:math';

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
          gameEntries: GameDataSource.emptyHLTBEntry,
          //cmplEntries: GameDataSource.emptyCmplEntry,
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
      _deleteSpecialSymbols(recentGames);
      emit(
        state.copyWith(
          recentGames: recentGames,
        ),
      );
      // Fetch all games data from Steam
      final allGames = await GameDataSource.fetchGames(steamID, true);
      _deleteSpecialSymbols(allGames);
      emit(
        state.copyWith(
          allGames: allGames,
        ),
      );

      // Create a HLTB completion entry map for all games.
      // All entries get the 'loading' status.
      // If an entry is found, it is changed to an actual entry,
      // with a 'success' status. If, after every game has been tried,
      // some games still don't have their working HLTB entry,
      // they are marked as 'error' not found
      Map<String, HowLongToBeatEntry> allGameEntries = {};
      // for (Game game in allGames) {
      //   allGameEntries[game.name] = HowLongToBeatEntry();
      // }

      emit(
        state.copyWith(
            gameEntries: allGameEntries,
            recentStatus: GameListStatus.success,
            allStatus: GameListStatus.success),
      );

      // // Fetch recent games data entries from HLTB first (more useful for the user)

      Map<String, HowLongToBeatEntry> recentGameEntries =
          await GameDataSource.fetchHLTBEntries(recentGames, allGameEntries);

      allGameEntries.addAll(recentGameEntries);

      emit(
        state.copyWith(
          gameEntries: allGameEntries,
          reload: true,
        ),
      );
      emit(
        state.copyWith(
          gameEntries: allGameEntries,
          reload: false,
        ),
      );

      // Fetch all games data entries from HLTB (in sets of 10)
      for (int i = 0; i < allGames.length; i += 10) {
        Map<String, HowLongToBeatEntry> tmpList =
            await GameDataSource.fetchHLTBEntries(
                allGames.sublist(i, min(i + 10, allGames.length)),
                allGameEntries);
        allGameEntries.addAll(tmpList);

        emit(
          state.copyWith(
            gameEntries: allGameEntries,
            reload: true,
          ),
        );
        emit(
          state.copyWith(
            gameEntries: allGameEntries,
            reload: false,
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

  void _deleteSpecialSymbols(List<Game> games) {
    RegExp regExp = RegExp(r'[™|®]');

    for (int i = 0; i < games.length; i++) {
      Game game = games[i];
      game.name = game.name.replaceAll(regExp, '');
    }
  }
}
