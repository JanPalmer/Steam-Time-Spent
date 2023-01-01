import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steamtimespent/HLTB/howlongtobeat.dart';
import 'package:steamtimespent/game.dart';
import 'package:steamtimespent/gamelistbloc/gamelist_bloc.dart';
import 'package:steamtimespent/imagerounded.dart';
import 'package:steamtimespent/user.dart';
import 'package:steamtimespent/userbloc/user_bloc.dart';

// class UserStatsView extends StatelessWidget{
//   const UserStatsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('User stats')),
//       body: BlocProvider(
//         create: (_) => UserBloc(),
//       )
//     )
//   }
// }

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
  //MostCompleted,
  //LeastCompleted,
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

  //sortOrder = NextSortOrder(sortOrder);
  switch (sortOrder) {
    case SortOrder.Alphabethical:
      games.sort(((a, b) => a.name.compareTo(b.name)));
      break;
    case SortOrder.ReverseAlphabethical:
      games.sort(((a, b) => b.name.compareTo(a.name)));
      break;
    // case SortOrder.MostCompleted:
    //   // TODO: Handle this case.
    //   break;
    // case SortOrder.LeastCompleted:
    //   // TODO: Handle this case.
    //   break;
  }
}

class _StateShowGames extends State<GameListScreen> {
  //CategoryToDisplay currentCategory = CategoryToDisplay.AllGames;
  bool displayAllGames = false;
  SortOrder sortOrder = SortOrder.Alphabethical;

  @override
  Widget build(BuildContext context) {
    final steamID = context.watch<GameListBloc>().steamID;

    return Scaffold(
        appBar: AppBar(title: const HeaderTitle()),
        body: Container(
            color: Colors.black87,
            child: Center(
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints.loose(const Size(500, double.infinity)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() => displayAllGames = false);
                                  },
                                  child: CategoryButton(
                                      textToDisplay: 'Recent Games',
                                      isSelected: !displayAllGames),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() => displayAllGames = true);
                                  },
                                  child: CategoryButton(
                                      textToDisplay: 'All Games',
                                      isSelected: displayAllGames),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sortOrder = NextSortOrder(sortOrder);
                                      SortGames(
                                          context, displayAllGames, sortOrder);
                                    });
                                  },
                                  child: SortOrderButton(
                                    currentSortOrder: sortOrder,
                                  ),
                                ),
                              ],
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
            width: 100,
            height: 50,
            color: isSelected ? Colors.white38 : Colors.white10,
            curve: Curves.easeIn,
            child: Center(
              child: Text(
                textToDisplay,
                style: const TextStyle(color: Colors.white),
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

  String ImageToDisplay() {
    switch (currentSortOrder) {
      case SortOrder.Alphabethical:
        return "assets/sort_alphabeth.png";
      case SortOrder.ReverseAlphabethical:
        return "assets/sort_alphabeth_reverseorder.jpg";
      // case SortOrder.MostCompleted:
      //   return "";
      // case SortOrder.LeastCompleted:
      //   return "";
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
            child: Image.asset(ImageToDisplay()),
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
              gameEntries: state.recentGamesEntries,
            )
          : state.recentStatus.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Center(
                  child: Text('load error'),
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
              gameEntries: state.allGamesEntries,
            )
          : state.allStatus.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Center(
                  child: Text('load error'),
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
        User steamuser = state.props.first as User;
        return Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(),
            ImageRounded(
              imageurl: steamuser.avatarurl,
            ),
            //Spacer(),
            Text(' ' + steamuser.personaname),
            Spacer(),
          ],
        ));
      } else {
        return Container(
          height: 100,
          width: 100,
          color: Colors.amber,
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
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 24.0,
        ),
        itemBuilder: (context, index) {
          final item = games[index];
          return ListTile(
              title: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      color: Colors.white10,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(children: [
                            (item.img_icon_url != '')
                                ? ImageRounded(imageurl: item.GetIconURL())
                                : Text('💀'),
                            Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                    ),
                                    child: GameStatsSnippet(
                                        game: item, gameEntries: gameEntries))),
                          ])))),
              onTap: () {});
        },
        separatorBuilder: (_, __) => const SizedBox(
              height: 20.0,
            ),
        itemCount: games.length);
  }
}

class GameStatsSnippet extends StatelessWidget {
  const GameStatsSnippet({
    super.key,
    required this.game,
    required this.gameEntries,
  });

  final Game game;
  final Map<String, HowLongToBeatEntry> gameEntries;

  @override
  Widget build(BuildContext context) {
    if (gameEntries[game.name] != null) {
      return Column(
        children: <Widget>[
          Text(
            game.name,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            'Time spent: ' + (game.playtime_forever / 60.0).toStringAsFixed(2),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            'Average Completion (All playstyles): ${gameEntries[game.name]?.gameplayAllPlaystyles.toStringAsFixed(2) ?? double.infinity}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          LinearProgressIndicator(
            color: Colors.blueGrey,
            value: game.playtime_forever /
                (gameEntries[game.name]?.gameplayAllPlaystyles ?? 10000.0),
          ),
          Text(
            'Main Story Completion:',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          LinearProgressIndicator(
            color: Colors.blueGrey,
            value: game.playtime_forever /
                (gameEntries[game.name]?.gameplayMain ?? 10000.0),
          ),
          Text(
            'Main+Sides Completion:',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          LinearProgressIndicator(
            value: game.playtime_forever /
                (gameEntries[game.name]?.gameplayMainExtra ?? 10000.0),
          ),
          // Text('100% Completion:'),
          // LinearProgressIndicator(
          //   value: game.playtime_forever /
          //       (gameEntries[game.name]?.gameplayCompletionist ?? 10000.0),
          // ),
        ],
      );
    } else {
      return Column(children: <Widget>[
        Text(
          game.name,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text('Game not found on HowLongToBeat.com',
            style: TextStyle(color: Colors.white, fontSize: 12)),
      ]);
    }
  }
}
