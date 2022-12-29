import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steamtimespent/game.dart';
import 'package:steamtimespent/gamedatasource.dart';
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

class GameListview extends StatefulWidget {
  const GameListview({super.key});

  @override
  State<StatefulWidget> createState() => _StateShowAll();
}

class _StateShowAll extends State<GameListview> {
  static const _gameDataSource = GameDataSource();
  List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    // _fetchGameData();
  }

  // Future<void> _fetchGameData() async {
  //   final games = await _gameDataSource.getGames();
  //   setState(() => _games = games);
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(title: const HeaderTitle()),
  //       body:
  //           //const HeaderTitle(),
  //           ListView.builder(
  //         itemCount: _games.length,
  //         itemBuilder: (context, index) {
  //           final item = _games[index];
  //           return ListTile(title: Text(item.name), onTap: () {});
  //         },
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const HeaderTitle()), body: GamesListWidget());
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.all(24.0),
                child: ImageRounded(
                  imageurl: steamuser.avatarurl,
                )),
            //Spacer(),
            Text(' ' + steamuser.personaname),
          ],
        );
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

class GamesListWidget extends StatelessWidget {
  const GamesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamelistBloc, AllGamesState>(builder: (context, state) {
      return state.status.isSuccess
          ? GamesSuccessWidget(games: state.games)
          : state.status.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Center(
                  child: Text('load error'),
                );
    });
  }
}

class GamesSuccessWidget extends StatelessWidget {
  const GamesSuccessWidget({super.key, required this.games});

  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 56.0,
          child: ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
              ),
              itemBuilder: (context, index) {
                final item = games[index];
                return ListTile(
                    title: Row(children: [
                      (item.img_icon_url != '')
                          ? ImageRounded(imageurl: item.GetIconURL())
                          : Text('💀'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name),
                          Text(item.playtime_forever.toString()),
                        ],
                      )
                    ]),
                    onTap: () {});
              },
              separatorBuilder: (_, __) => const SizedBox(
                    height: 20.0,
                  ),
              itemCount: games.length),
        )
      ],
    );
  }
}
