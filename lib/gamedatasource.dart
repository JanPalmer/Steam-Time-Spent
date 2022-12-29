import 'package:steamtimespent/game.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameDataSource {
  const GameDataSource();

  static Future<List<Game>> getGames() async => _games;

  static const empty = <Game>[];

  static Future<List<Game>> fetchGames(String steamID) async {
    String steamAPIkey = '8214D13AC7E97D3848A107CD015F2F3A';
    String url =
        """http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$steamAPIkey&steamid=$steamID&include_appinfo=true&format=json""";

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      // Decoding the received JSON file
      print('Parsing response body');
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (responseMap.values.first == null) throw Exception('No user found');
      Map<String, dynamic> gamescountMap = responseMap.values.first;

      if (gamescountMap.values.first == null) throw Exception('No user found');
      List<dynamic> gamesMap = gamescountMap.values.last;

      print(gamesMap.first);
      print(gamesMap.length);

      List<Game> games = List.empty(growable: true);

      for (int i = 0; i < gamesMap.length; i++) {
        Map<String, dynamic> currentGameMap = gamesMap[i];
        Game newgame = Game.fromJson(currentGameMap);
        games.add(newgame);
      }

      int len = games.length;
      print('Number of games: $len');

      return games;
    }
    print('Connection error');
    throw Exception('Internet connection error');
  }
}

final _games = [
  const Game(
      appid: 1,
      name: 'Yakuza Like a Dragon',
      playtime_forever: 0,
      img_icon_url: 'kk'),
  const Game(
      appid: 2,
      name: 'Ace Combat 7: Skies Unknown',
      playtime_forever: 99,
      img_icon_url: 'kk'),
  const Game(
      appid: 3, name: 'Elden Ring', playtime_forever: 33, img_icon_url: 'kk'),
];
