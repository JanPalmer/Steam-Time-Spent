import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steamtimespent/game.dart';
import 'package:steamtimespent/gamedatasource.dart';
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
    _fetchGameData();
  }

  Future<void> _fetchGameData() async {
    final games = await _gameDataSource.getGames();
    setState(() => _games = games);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const HeaderTitle()),
        body:
            //const HeaderTitle(),
            ListView.builder(
          itemCount: _games.length,
          itemBuilder: (context, index) {
            final item = _games[index];
            return ListTile(title: Text(item.name), onTap: () {});
          },
        ));
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
            Image.network(steamuser.avatarurl),
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
