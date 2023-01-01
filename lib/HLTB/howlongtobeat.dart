import 'hltbsearch.dart';
import 'package:string_similarity/string_similarity.dart';
import 'dart:convert';

class HowLongToBeatService {
  final hltb = HltbSearch();

  Future<Map<String, HowLongToBeatEntry>> search(List<String> games) async {
    var gameEntries = List<HowLongToBeatEntry>.empty(growable: true);

    for (int i = 0; i < games.length; i++) {
      String currGame = games[i];
      print('Searching for: $currGame');
      List<String> searchTerms = currGame.split(' ');
      String search = await hltb.search(searchTerms);
      try {
        gameEntries.add(parseBody(currGame, search));
      } catch (error) {
        print(error);
        games.remove(currGame);
        i--;
      }
    }

    if (games.length != gameEntries.length) {
      print(games);
      for (HowLongToBeatEntry hltb in gameEntries) {
        print(hltb.name);
      }
      throw ("Iterables not same length");
    }

    return Map<String, HowLongToBeatEntry>.fromIterables(games, gameEntries);
  }

  HowLongToBeatEntry parseBody(String gameName, String body) {
    Map<String, dynamic> response = jsonDecode(body);

    List<dynamic> candidates = response['data'] ?? [];
    if (candidates.length == 0) throw Exception('Game not found');
    Map<String, dynamic> foundgame = candidates.first;

    HowLongToBeatEntry hltbEntry = HowLongToBeatEntry(
      id: foundgame['id'] ?? '',
      name: foundgame['game_name'] ?? '',
      gameplayMain: foundgame['comp_main'] / 60.0 ?? double.infinity,
      gameplayMainExtra: foundgame['comp_plus'] / 60.0 ?? double.infinity,
      gameplayCompletionist: foundgame['comp_100'] / 60.0 ?? double.infinity,
      gameplayAllPlaystyles: foundgame['comp_all'] / 60.0 ?? double.infinity,
      searchTerm: gameName,
    );

    print(hltbEntry.name);
    print(hltbEntry.gameplayMain);
    return hltbEntry;
  }
}

class HowLongToBeatEntry {
  final String id;
  final String name;
  //final String description;
  //final List<String> platforms;
  //final String imageUrl;
  final double gameplayMain;
  final double gameplayMainExtra;
  final double gameplayCompletionist;
  final double gameplayAllPlaystyles;
  //final double similarity;
  final String searchTerm;

  const HowLongToBeatEntry({
    required this.id,
    required this.name,
    //required this.description,
    //required this.platforms,
    //required this.imageUrl,
    required this.gameplayMain,
    required this.gameplayMainExtra,
    required this.gameplayCompletionist,
    required this.gameplayAllPlaystyles,
    //required this.similarity,
    required this.searchTerm,
  });

  static const empty = HowLongToBeatEntry(
      id: '',
      name: '',
      gameplayMain: 0,
      gameplayMainExtra: 0,
      gameplayCompletionist: 0,
      gameplayAllPlaystyles: 0,
      searchTerm: '');
}
