import 'dart:ui';

class Game {
  const Game({
    required this.appid,
    required this.name,
    required this.playtime_forever,
    required this.img_icon_url,
  });

  final String appid;
  final String name;
  final int playtime_forever;
  final String img_icon_url;

  static String gameIconURLPrefix =
      'http://media.steampowered.com/steamcommunity/public/images/apps/';
}
