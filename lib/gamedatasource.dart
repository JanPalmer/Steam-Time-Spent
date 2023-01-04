import 'package:steamtimespent/HLTB/howlongtobeat.dart';
import 'package:steamtimespent/game.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameDataSource {
  const GameDataSource();

  static Future<List<Game>> getGames() async => _games;

  static const emptyGame = <Game>[];
  static const emptyHLTBEntry = <String, HowLongToBeatEntry>{};

  static Future<List<Game>> fetchGames(String steamID, bool getAllGames) async {
    String steamAPIkey = '8214D13AC7E97D3848A107CD015F2F3A';

    Uri uri;
    if (getAllGames) {
      uri = Uri.http(
          'api.steampowered.com', '/IPlayerService/GetOwnedGames/v0001/', {
        'key': steamAPIkey,
        'steamid': steamID,
        'include_appinfo': 'true',
        'format': 'json'
      });
    } else {
      uri = Uri.http('api.steampowered.com',
          '/IPlayerService/GetRecentlyPlayedGames/v0001/', {
        'key': steamAPIkey,
        'steamid': steamID,
        'include_appinfo': 'true',
        'format': 'json'
      });
    }

    //print(uri);

    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      // Decoding the received JSON file
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      //if (responseMap.values.first == null) throw Exception('No user found');
      Map<String, dynamic> gamescountMap = responseMap.values.first;

      // Check whether there are any recently played games
      int totalCount = gamescountMap['total_count'] ?? -1;
      if (totalCount == 0) {
        return [];
      }

      // Check whether there are any games on the account
      int gamesCount = gamescountMap['games_count'] ?? -1;
      if (gamesCount == 0) {
        return [];
      }

      //if (gamescountMap.values.first == null) throw Exception('No user found');
      List<dynamic> gamesMap = gamescountMap.values.last;
      List<Game> games = List.empty(growable: true);

      for (int i = 0; i < gamesMap.length; i++) {
        Map<String, dynamic> currentGameMap = gamesMap[i];
        Game newgame = Game.fromJson(currentGameMap);
        games.add(newgame);
      }

      //print(games.length);

      return games;
    }
    throw Exception('Internet connection error');
  }

  static Future<Map<String, HowLongToBeatEntry>> fetchHLTBEntries(
    List<Game> games,
    Map<String, HowLongToBeatEntry> currentGameEntries,
  ) async {
    HowLongToBeatService hltbService = HowLongToBeatService();
    List<String> gameNames = List.empty(growable: true);
    for (Game game in games) {
      gameNames.add(game.name);
    }

    Map<String, HowLongToBeatEntry> gameEntries =
        await hltbService.search(gameNames);

    return gameEntries;
  }
}

final _games = [
  Game(
      appid: 1,
      name: 'Yakuza Like a Dragon',
      playtime_forever: 0,
      img_icon_url: 'kk'),
  Game(
      appid: 2,
      name: 'Ace Combat 7: Skies Unknown',
      playtime_forever: 99,
      img_icon_url: 'kk'),
  Game(appid: 3, name: 'Elden Ring', playtime_forever: 33, img_icon_url: 'kk'),
];
