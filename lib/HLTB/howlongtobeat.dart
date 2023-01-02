import 'hltbsearch.dart';
import 'package:string_similarity/string_similarity.dart';
import 'dart:convert';

class HowLongToBeatService {
  final hltb = HltbSearch();

  Future<Map<String, HowLongToBeatEntry>> search(List<String> games) async {
    var gameEntries = List<HowLongToBeatEntry>.empty(growable: true);

    for (int i = 0; i < games.length; i++) {
      String currGame = games[i];
      //print('Searching for: $currGame');
      List<String> searchTerms = currGame.split(' ');
      String search = await hltb.search(searchTerms);
      try {
        gameEntries.add(parseBody(currGame, search));
      } catch (error) {
        print(error);
        // games.remove(currGame);
        // i--;
        gameEntries.add(HowLongToBeatEntry.empty);
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
      status: HowLongToBeatEntryStatus.success,
    );

    // print(hltbEntry.name);
    // print(hltbEntry.gameplayMain);
    // print(hltbEntry.gameplayMainExtra);
    // print(hltbEntry.gameplayCompletionist);
    // print(hltbEntry.gameplayAllPlaystyles);

    return hltbEntry;
  }
}

enum HowLongToBeatEntryStatus {
  loading,
  success,
  error,
}

extension HowLongToBeatEntryStatusX on HowLongToBeatEntryStatus {
  bool get isLoading => this == HowLongToBeatEntryStatus.loading;
  bool get isSuccess => this == HowLongToBeatEntryStatus.success;
  bool get isError => this == HowLongToBeatEntryStatus.error;
}

class HowLongToBeatEntry {
  String id;
  String name;
  double gameplayMain;
  double gameplayMainExtra;
  double gameplayCompletionist;
  double gameplayAllPlaystyles;
  String searchTerm;
  HowLongToBeatEntryStatus status;

  HowLongToBeatEntry({
    this.id = '',
    this.name = '',
    this.gameplayMain = double.infinity,
    this.gameplayMainExtra = double.infinity,
    this.gameplayCompletionist = double.infinity,
    this.gameplayAllPlaystyles = double.infinity,
    this.searchTerm = '',
    this.status = HowLongToBeatEntryStatus.loading,
  });

  static final empty = HowLongToBeatEntry(
    id: '',
    name: '',
    gameplayMain: 0,
    gameplayMainExtra: 0,
    gameplayCompletionist: 0,
    gameplayAllPlaystyles: 0,
    searchTerm: '',
    status: HowLongToBeatEntryStatus.error,
  );
}
