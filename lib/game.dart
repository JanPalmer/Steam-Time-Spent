import 'dart:ui';

class Game {
  const Game({
    required this.appid,
    required this.name,
    required this.playtime_forever,
    required this.img_icon_url,
  });

  final int appid;
  final String name;
  final int playtime_forever;
  final String img_icon_url;

  static String gameIconURLPrefix =
      'http://media.steampowered.com/steamcommunity/public/images/apps/';

  static const empty =
      Game(appid: 0, name: '', playtime_forever: 0, img_icon_url: '');

  Game.fromJson(Map<String, dynamic> json)
      : appid = json['appid'] ?? 0,
        name = json['name'] ?? '',
        playtime_forever = json['playtime_forever'] ?? 0,
        img_icon_url = json['img_icon_url'] ?? '';

  String GetIconURL() {
    return gameIconURLPrefix + appid.toString() + '/' + img_icon_url + '.jpg';
  }
}
