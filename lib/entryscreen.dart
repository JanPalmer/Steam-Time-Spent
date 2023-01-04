import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steamtimespent/gamelistbloc/gamelist_bloc.dart';
import 'package:steamtimespent/helpscreen.dart';
import 'package:steamtimespent/listview.dart';
import 'package:steamtimespent/recentsearchesbloc/recentsearcheswidget.dart';
import 'package:steamtimespent/recentsearchesbloc/recentsearches_bloc.dart';
import 'package:steamtimespent/user.dart';
import 'package:steamtimespent/userbloc/user_bloc.dart';

class SteamIDEntryScreen extends StatefulWidget {
  const SteamIDEntryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StateInputSteamID();
}

enum InputScreenState {
  ready,
  loading,
  profileLoaded,
  fetchingError,
}

class _StateInputSteamID extends State<SteamIDEntryScreen> {
  String steamID = "";
  InputScreenState currstate = InputScreenState.ready;
  String textPrompt = 'Insert your 64-bit SteamID';

  TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  User? steamuser;

  void _loadSteamProfile() async {
    setState(() {
      steamuser = null;
      currstate = InputScreenState.loading;
    });
    steamuser = null;
    try {
      final user = await User.fetchUserProfile(nameController.text);
      setState(() {
        steamuser = user;
        currstate = InputScreenState.profileLoaded;
        context
            .read<RecentSearchesBloc>()
            .add(AddUserToList(newuser: steamuser!));
        context.read<RecentSearchesBloc>().add(SaveRecentSearches());
      });
      _navigateToProfileScreen();
    } catch (e) {
      setState(() {
        currstate = InputScreenState.fetchingError;
      });
      textPrompt = 'Could not find a user with the given SteamID64';
      textPrompt = e.toString();
      return;
    }
  }

  void _navigateToProfileScreen() {
    if (steamuser == null) throw Exception('User null');
    User user = steamuser!;
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
  void initState() {
    super.initState();
    setState(() {
      context.read<RecentSearchesBloc>().add(GetRecentSearches());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Steam Time Spent')),
        body: Container(
            color: Colors.black87,
            child: Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints.loose(const Size(600, double.infinity)),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          textPrompt,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )),
                    const SizedBox(height: 5),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: "64-bit SteamID",
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    if (currstate == InputScreenState.loading)
                      const Expanded(
                          child: Center(child: CircularProgressIndicator()))
                    else
                      Container(
                          height: 50,
                          width: 200,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: const Text(
                              'Load data',
                              textScaleFactor: 1.3,
                            ),
                            onPressed: () {
                              _loadSteamProfile();
                            },
                          )),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HelpScreen()),
                        );
                      },
                      child: const Text(
                        'How to find your SteamID64',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Data loading might take more than a minute, please be patient',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Recent searches:',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocBuilder<RecentSearchesBloc, RecentSearchesState>(
                        builder: ((context, state) {
                      if (state.status.isSuccess) {
                        return RecentSearchesWidget(
                            recentSearchesList: state.userList);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })),
                  ],
                ),
              ),
            )));
  }
}
