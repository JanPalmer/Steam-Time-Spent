import 'hltbsearch.dart';
import 'package:string_similarity/string_similarity.dart';
import 'dart:convert';

class HowLongToBeatService {
  final hltb = HltbSearch();

  Future<List<HowLongToBeatEntry>> search(List<String> games) async {
    var gameEntries = List<HowLongToBeatEntry>.empty(growable: true);

    for (int i = 0; i < games.length; i++) {
      List<String> searchTerms = games[i].split(' ');
      String search = await hltb.search(searchTerms);
      try {
        gameEntries.add(parseBody(games[i], search));
      } catch (error) {
        print(error);
      }

      // if (i % 10 == 0) {
      //   final sw = Stopwatch()..start();
      //   while (sw.elapsedMilliseconds < 100) {}
      // }
    }

    return gameEntries;
  }

  HowLongToBeatEntry parseBody(String gameName, String body) {
    Map<String, dynamic> response = jsonDecode(body);

    List<dynamic> candidates = response['data'] ?? [];
    if (candidates.length == 0) throw Exception('Game not found');
    Map<String, dynamic> foundgame = candidates.first;

    HowLongToBeatEntry hltbEntry = HowLongToBeatEntry(
      id: foundgame['id'] ?? '',
      name: foundgame['game_name'] ?? '',
      gameplayMain: foundgame['comp_main'] / 3600.0 ?? 0,
      gameplayMainExtra: foundgame['comp_plus'] / 3600.0 ?? 0,
      gameplayCompletionist: foundgame['comp_100'] / 3600.0 ?? 0,
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
    //required this.similarity,
    required this.searchTerm,
  });

  static const empty = HowLongToBeatEntry(
      id: '',
      name: '',
      gameplayMain: 0,
      gameplayMainExtra: 0,
      gameplayCompletionist: 0,
      searchTerm: '');
}
