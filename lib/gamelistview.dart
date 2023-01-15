import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steamtimespent/HLTB/howlongtobeat.dart';
import 'package:steamtimespent/game.dart';
import 'package:steamtimespent/gamelistbloc/gamelist_bloc.dart';
import 'package:steamtimespent/imagerounded.dart';
import 'package:steamtimespent/user.dart';
import 'package:steamtimespent/userbloc/user_bloc.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StateShowGames();
}

enum CategoryToDisplay {
  AllGames,
  Recent,
}

enum SortOrder {
  Alphabethical,
  ReverseAlphabethical,
  MostCompleted,
  LeastCompleted,
}

SortOrder NextSortOrder(SortOrder order) {
  final nextIndex = (order.index + 1) % SortOrder.values.length;
  return SortOrder.values[nextIndex];
}

void SortGames(BuildContext context, bool allGames, SortOrder sortOrder) {
  List<Game> games;
  if (allGames == true) {
    games = context.read<GameListBloc>().state.allGames;
  } else {
    games = context.read<GameListBloc>().state.recentGames;
  }

  if (games.isEmpty) return;

  //sortOrder = NextSortOrder(sortOrder);
  switch (sortOrder) {
    case SortOrder.Alphabethical:
      games.sort(((a, b) => a.name.compareTo(b.name)));
      break;
    case SortOrder.ReverseAlphabethical:
      games.sort(((a, b) => b.name.compareTo(a.name)));
      break;
    case SortOrder.MostCompleted:
      games.sort(((a, b) => b.playtime_forever.compareTo(a.playtime_forever)));
      break;
    case SortOrder.LeastCompleted:
      games.sort(((a, b) => a.playtime_forever.compareTo(b.playtime_forever)));
      break;
  }
}

class _StateShowGames extends State<GameListScreen> {
  //CategoryToDisplay currentCategory = CategoryToDisplay.AllGames;
  bool displayAllGames = false;
  SortOrder sortOrder = SortOrder.Alphabethical;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const HeaderTitle()),
        body: Container(
            color: Colors.black87,
            child: Center(
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints.loose(const Size(600, double.infinity)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => displayAllGames = false);
                                    },
                                    child: CategoryButton(
                                        textToDisplay: 'Recent Games',
                                        isSelected: !displayAllGames),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => displayAllGames = true);
                                    },
                                    child: CategoryButton(
                                        textToDisplay: 'All Games',
                                        isSelected: displayAllGames),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        sortOrder = NextSortOrder(sortOrder);
                                        SortGames(context, displayAllGames,
                                            sortOrder);
                                      });
                                    },
                                    child: SortOrderButton(
                                      currentSortOrder: sortOrder,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: GamesListWidget(
                                displayAllGames: displayAllGames,
                              ),
                            ),
                          ]),
                    )))));
  }
}

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    super.key,
    required this.textToDisplay,
    required this.isSelected,
  });

  final bool isSelected;
  final String textToDisplay;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 120,
            height: 50,
            color: isSelected ? Colors.white38 : Colors.white10,
            curve: Curves.easeIn,
            child: Center(
              child: Text(
                textToDisplay,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            )));
  }
}

class SortOrderButton extends StatelessWidget {
  const SortOrderButton({
    super.key,
    required this.currentSortOrder,
  });

  final SortOrder currentSortOrder;

  String imageToDisplay() {
    switch (currentSortOrder) {
      case SortOrder.Alphabethical:
        return "assets/sort_alphabeth.png";
      case SortOrder.ReverseAlphabethical:
        return "assets/sort_alphabeth_reverseorder.png";
      case SortOrder.MostCompleted:
        return "assets/sort_completion_max2min.png";
      case SortOrder.LeastCompleted:
        return "assets/sort_completion_min2max.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 50,
          height: 50,
          color: Colors.blueGrey,
          curve: Curves.easeIn,
          child: Center(
            child: Image.asset(imageToDisplay()),
          ),
        ));
  }
}

class GamesListWidget extends StatelessWidget {
  const GamesListWidget({
    super.key,
    required this.displayAllGames,
  });

  final bool displayAllGames;

  @override
  Widget build(BuildContext context) {
    return (displayAllGames)
        ? const AllGamesSuccessWidget()
        : const RecentGamesSuccessWidget();
  }
}

class RecentGamesSuccessWidget extends StatelessWidget {
  const RecentGamesSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameListBloc, GameListLoadedState>(
        builder: (context, state) {
      return state.recentStatus.isSuccess
          ? GamesSuccessWidget(
              games: state.recentGames,
              gameEntries: state.gameEntries,
            )
          : state.recentStatus.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.recentStatus.isNoGames
                  ? const Center(
                      child: Text(
                        'No recently played games found',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Load error',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
    });
  }
}

class AllGamesSuccessWidget extends StatelessWidget {
  const AllGamesSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameListBloc, GameListLoadedState>(
        builder: (context, state) {
      return state.allStatus.isSuccess
          ? GamesSuccessWidget(
              games: state.allGames,
              gameEntries: state.gameEntries,
            )
          : state.allStatus.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.allStatus.isNoGames
                  ? const Center(
                      child: Text(
                        'No games found on the given Steam profile',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Load error',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
    });
  }
}

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SteamUserBloc, SteamUserState>(
        builder: ((context, state) {
      if (state is SteamUserLoaded) {
        User steamuser = state.steamuser;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            ImageRounded(
              imageurl: steamuser.avatarurl,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(' ${steamuser.personaname}'),
            const SizedBox(
              width: 56,
            ),
            const Spacer(),
          ],
        );
      } else {
        return Container(
          height: 100,
          width: 100,
          child: const Text('User loading error'),
        );
      }
    }));
  }
}

class GamesSuccessWidget extends StatelessWidget {
  const GamesSuccessWidget({
    super.key,
    required this.games,
    required this.gameEntries,
  });

  final List<Game> games;
  final Map<String, HowLongToBeatEntry> gameEntries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 20.0,
        ),
        itemBuilder: (context, index) {
          final item = games[index];
          return ListTile(
              title: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      color: Colors.white10,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              (item.img_icon_url != '')
                                  ? ImageRounded(imageurl: item.GetIconURL())
                                  : const Text('💀'),
                              const SizedBox(width: 3),
                              Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5.0,
                                        right: 5.0,
                                      ),
                                      child: Center(
                                          child: GameStatsSnippet(
                                        game: item,
                                        gameEntry: gameEntries[item.name] ??
                                            HowLongToBeatEntry(),
                                      )))),
                            ],
                          )))),
              onTap: () {});
        },
        separatorBuilder: (_, __) => const SizedBox(
              height: 5.0,
            ),
        itemCount: games.length);
  }
}

class GameStatsSnippet extends StatelessWidget {
  const GameStatsSnippet({
    super.key,
    required this.game,
    required this.gameEntry,
  });

  final Game game;
  final HowLongToBeatEntry gameEntry;

  @override
  Widget build(BuildContext context) {
    //print(gameEntry.status);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          game.name,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          'Time spent -  ${(game.playtime_forever / 60.0).toStringAsFixed(2)} hours',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 10),
        (gameEntry.status.isSuccess)
            ? Flexible(
                child: GameCompletionIndicatorsSuccess(
                    hltbEntry: gameEntry, game: game),
              )
            : (gameEntry.status.isLoading)
                ? const CircularProgressIndicator()
                : const Text(
                    'Game not found on HowLongToBeat.com',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
      ],
    );
  }
}

class GameCompletionIndicatorsSuccess extends StatelessWidget {
  const GameCompletionIndicatorsSuccess({
    super.key,
    required this.hltbEntry,
    required this.game,
  });

  final HowLongToBeatEntry hltbEntry;
  final Game game;

  Color getProgressBarColor(double completionRate) {
    return HSLColor.fromAHSL(
      1,
      min(100 * completionRate, 325),
      1,
      0.5,
    ).toColor();
  }

  @override
  Widget build(BuildContext context) {
    double cmplAllPlaystyles = (hltbEntry.gameplayAllPlaystyles <= 0)
        ? 0
        : game.playtime_forever / hltbEntry.gameplayAllPlaystyles;
    double cmplMain = (hltbEntry.gameplayMain <= 0)
        ? 0
        : game.playtime_forever / hltbEntry.gameplayMain;
    double cmplMainExtra = (hltbEntry.gameplayMainExtra <= 0)
        ? 0
        : game.playtime_forever / hltbEntry.gameplayMainExtra;
    double cmpl100 = (hltbEntry.gameplayCompletionist <= 0)
        ? 0
        : game.playtime_forever / hltbEntry.gameplayCompletionist;

    if (cmplMain.isNaN ||
        cmplMainExtra.isNaN ||
        cmpl100.isNaN ||
        cmplAllPlaystyles.isNaN) throw ('isNan');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Average Completion - ${(hltbEntry.gameplayAllPlaystyles / 60).toStringAsFixed(2)} hours',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(height: 3),
        LinearProgressIndicator(
          color: getProgressBarColor(cmplAllPlaystyles),
          value: cmplAllPlaystyles,
        ),
        SizedBox(height: 7),
        Text(
          'Main Story - ${(hltbEntry.gameplayMain / 60).toStringAsFixed(2)} hours',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(height: 3),
        LinearProgressIndicator(
          color: getProgressBarColor(cmplMain),
          value: cmplMain,
        ),
        SizedBox(height: 7),
        Text(
          'Main+Sides - ${(hltbEntry.gameplayMainExtra / 60).toStringAsFixed(2)} hours',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(height: 3),
        LinearProgressIndicator(
          color: getProgressBarColor(cmplMainExtra),
          value: cmplMainExtra,
        ),
        SizedBox(height: 7),
        Text(
          '100% - ${(hltbEntry.gameplayCompletionist / 60).toStringAsFixed(2)} hours',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(height: 3),
        LinearProgressIndicator(
          color: getProgressBarColor(cmpl100),
          value: cmpl100,
        ),
      ],
    );
  }
}
