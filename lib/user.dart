import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

class User {
  final String steamid;
  final String personaname;
  final String profileurl;
  final String avatarurl;
  final int visibilitystate;

  const User({
    required this.steamid,
    required this.personaname,
    required this.profileurl,
    required this.avatarurl,
    required this.visibilitystate,
  });

  User.fromJson(Map<String, dynamic> json)
      : steamid = json['steamid'] ?? '',
        personaname = json['personaname'] ?? '',
        profileurl = json['profileurl'] ?? '',
        avatarurl = json['avatarmedium'] ?? '',
        visibilitystate = json['communityvisibilitystate'] ?? 1;

  static Future<User> fetchUserProfile(String steamID) async {
    String steamAPIkey = '8214D13AC7E97D3848A107CD015F2F3A';
    String url =
        """http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$steamAPIkey&steamids=$steamID""";

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      //final body = json.decode(response.body) as List;
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (responseMap.values.first == null) throw Exception('No user found');
      Map<String, dynamic> playersMap = responseMap.values.first;
      print('playermap\n');
      // print(playersMap.keys);
      // print(playersMap.values);
      if (playersMap.values.first == null) throw Exception('No user found');
      List<dynamic> steamuserMap = playersMap.values.first;
      // print('steamusermap length: ' + steamuserMap.length.toString());
      print(steamuserMap);
      // List<dynamic> playersList = responseMap['response'] as List<dynamic>;
      // Map<String, dynamic> playersMap = jsonDecode(playersList.first);
      // List<dynamic> steamuserList = playersMap['players'] as List<dynamic>;
      // Map<String, dynamic> steamuserMap = jsonDecode(steamuserList.first);
      User newuser = User.fromJson(steamuserMap.first);
      // print(steamuserMap.keys);
      // print(steamuserMap.values);
      //print('Username:' + newuser.personaname + '\n');
      //map.entries.first.toString() + ' ' + newuser.steamid + '\n'
      if (newuser.steamid == '') {
        throw Exception('No user found');
      } //return null;
      if (newuser.visibilitystate != 3) {
        throw Exception('User profile is private');
      }
      return newuser;

      // body.map((dynamic json) {
      //   final map = json as Map<String, dynamic>;
      //   User newuser = User.fromJson(map);
      //   if (newuser.steamid == '') throw Exception('No user found');
      //   return newuser;
      //});
    }
    throw Exception('Internet connection error');
  }
}
