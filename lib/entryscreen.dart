import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steamtimespent/listview.dart';
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
  //late User steamuser;

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
        print(steamuser?.personaname);
      });
      _navigateToProfileScreen();
    } catch (e) {
      setState(() {
        //steamuser = null;
        currstate = InputScreenState.fetchingError;
      });
      textPrompt = e.toString();
      print(textPrompt);
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
                          SteamUserBloc()..add(LoadSteamUser(user)),
                    )
                  ],
                  child: const GameListview(),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steam Time Spent')),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  textPrompt,
                  style: const TextStyle(fontSize: 20),
                  selectionColor: (currstate == InputScreenState.fetchingError)
                      ? Colors.red
                      : Colors.blueGrey,
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "64-bit SteamID",
                ),
              ),
            ),
            if (currstate == InputScreenState.loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
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
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'How to find your SteamID64',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
