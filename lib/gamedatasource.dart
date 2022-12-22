import 'package:steamtimespent/game.dart';

class GameDataSource {
  const GameDataSource();

  Future<List<Game>> getGames() async => _games;
}

final _games = [
  const Game(
      appid: '1',
      name: 'Yakuza Like a Dragon',
      playtime_forever: 0,
      img_icon_url: 'kk'),
  const Game(
      appid: '2',
      name: 'Ace Combat 7: Skies Unknown',
      playtime_forever: 99,
      img_icon_url: 'kk'),
  const Game(
      appid: '3', name: 'Elden Ring', playtime_forever: 33, img_icon_url: 'kk'),
];
