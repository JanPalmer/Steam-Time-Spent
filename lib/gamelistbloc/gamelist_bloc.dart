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

      //print('Fetching games for ${event.steamid}');

      // Fetch recent games data from Steam
      final recentGames = await GameDataSource.fetchGames(steamID, false);
      _deleteSpecialSymbols(recentGames);

      if (recentGames.isEmpty) {
        emit(state.copyWith(
          recentGames: recentGames,
          recentStatus: GameListStatus.noGames,
        ));
      } else {
        emit(state.copyWith(
          recentGames: recentGames,
        ));
      }

      // Fetch all games data from Steam
      final allGames = await GameDataSource.fetchGames(steamID, true);
      _deleteSpecialSymbols(allGames);
      if (allGames.isEmpty) {
        emit(state.copyWith(
          allGames: allGames,
          allStatus: GameListStatus.noGames,
        ));
      } else {
        emit(state.copyWith(
          allGames: allGames,
        ));
      }

      // For missing entries, the ListView will display them as loading.
      // Once there's been an attempt to find a game, it can result in either
      // a success - data will be displayed, or error - the entry for a game
      // will be present, but its status will be marked as error,
      // so the Listview knows it has not been found
      Map<String, HowLongToBeatEntry> allGameEntries = {};
      emit(
        state.copyWith(
          gameEntries: allGameEntries,
          recentStatus: (state.recentStatus.isNoGames)
              ? GameListStatus.noGames
              : GameListStatus.success,
          allStatus: (state.allStatus.isNoGames)
              ? GameListStatus.noGames
              : GameListStatus.success,
        ),
      );

      // Fetch recent games data entries from HLTB first (more useful for the user)

      if (recentGames.isNotEmpty) {
        //print('Fetching recent games');
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
      }

      // Fetch all games data entries from HLTB (in sets of 10)
      if (allGames.isNotEmpty) {
        //print('Fetching the rest games');
        const amountPerReload = 5;
        for (int i = 0; i < allGames.length; i += amountPerReload) {
          Map<String, HowLongToBeatEntry> tmpList =
              await GameDataSource.fetchHLTBEntries(
                  allGames.sublist(
                      i, min(i + amountPerReload, allGames.length)),
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
      }
    } catch (error) {
      //print(error.toString());
      emit(state.copyWith(
        recentStatus: GameListStatus.error,
        allStatus: GameListStatus.error,
      ));
    }
  }

  void _deleteSpecialSymbols(List<Game> games) {
    if (games.isEmpty) return;

    RegExp regExp = RegExp(r'[™|®]');

    for (int i = 0; i < games.length; i++) {
      Game game = games[i];
      game.name = game.name.replaceAll(regExp, '');
    }
  }
}
