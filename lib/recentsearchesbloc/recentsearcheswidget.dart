import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steamtimespent/gamelistbloc/gamelist_bloc.dart';
import 'package:steamtimespent/imagerounded.dart';
import 'package:steamtimespent/gamelistview.dart';
import 'package:steamtimespent/recentsearchesbloc/recentsearches_bloc.dart';
import 'package:steamtimespent/user.dart';
import 'package:steamtimespent/userbloc/user_bloc.dart';

class RecentSearchesWidget extends StatelessWidget {
  const RecentSearchesWidget({
    super.key,
    required this.recentSearchesList,
  });

  final List<User> recentSearchesList;

  List<Widget> getUserWidgetList() {
    List<Widget> widgetList = List<Widget>.empty(growable: true);
    for (User user in recentSearchesList) {
      widgetList.add(RecentSearchesTile(user: user));
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 56;

    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(600, min(height, 200))),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        spacing: 5.0,
        runSpacing: 5.0,
        crossAxisAlignment: WrapCrossAlignment.start,
        verticalDirection: VerticalDirection.down,
        clipBehavior: Clip.hardEdge,
        children: getUserWidgetList(),
      ),
    );
  }
}

class RecentSearchesTile extends StatelessWidget {
  const RecentSearchesTile({
    super.key,
    required this.user,
  });

  final User user;

  void _navigateToProfileScreen(BuildContext context) {
    context.read<RecentSearchesBloc>().add(AddUserToList(newuser: user));
    context.read<RecentSearchesBloc>().add(SaveRecentSearches());
    context.read<RecentSearchesBloc>().add(GetRecentSearches());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                    body: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) =>
                            SteamUserBloc()..add(LoadSteamUser(user))),
                    BlocProvider(
                      create: (context) => GameListBloc(steamID: user.steamid)
                        ..add(GetGames(user.steamid)),
                    ),
                  ],
                  child: const GameListScreen(),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _navigateToProfileScreen(context);
        },
        child: Container(
          width: 100,
          height: 100,
          child: Center(
            child: Column(
              children: [
                ImageRounded(
                  imageurl: user.avatarurl,
                  imageHeight: 70,
                  imageWidth: 70,
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Text(
                  user.personaname,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ));
  }
}
