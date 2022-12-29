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

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StateShowGames();
}

enum CategoryToDisplay { AllGames, Recent }

class _StateShowGames extends State<GameListScreen> {
  //CategoryToDisplay currentCategory = CategoryToDisplay.AllGames;
  bool displayAllGames = false;

  @override
  Widget build(BuildContext context) {
    final steamID = context.watch<GameListBloc>().steamID;

    return Scaffold(
        appBar: AppBar(title: const HeaderTitle()),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
            bottom: 5.0,
          ),
          child: Column(children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      displayAllGames = false;
                      context.read<GameListBloc>().add(GetRecentGames(steamID));
                    });
                  },
                  child: CategoryButton(
                      textToDisplay: 'Recent Games',
                      isSelected: !displayAllGames),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      displayAllGames = true;
                      context.read<GameListBloc>().add(GetAllGames(steamID));
                    });
                  },
                  child: CategoryButton(
                      textToDisplay: 'All Games', isSelected: displayAllGames),
                ),
              ],
            ),
            GamesListWidget(),
          ]),
        ));
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
            color: isSelected ? Colors.black54 : Colors.blueGrey,
            curve: Curves.easeIn,
            child: Center(
              child: Text(
                textToDisplay,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            )));
  }
}

class GamesListWidget extends StatelessWidget {
  const GamesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameListBloc, GameListLoadedState>(
        builder: (context, state) {
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

class GamesSuccessWidget extends StatelessWidget {
  const GamesSuccessWidget({super.key, required this.games});

  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 56.0 - 60.0,
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
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name),
                          Text('Time spent: ' +
                              (item.playtime_forever / 60.0).toString()),
                        ],
                      ),
                      Spacer(
                        flex: 4,
                      ),
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
