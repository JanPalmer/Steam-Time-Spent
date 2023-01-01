import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class HltbSearch {
  final HttpClient httpClient = HttpClient();
  Map<String, dynamic> payload = {
    "searchType": "games",
    "searchTerms": [],
    "searchPage": 1,
    "size": 20,
    "searchOptions": {
      "games": {
        "userId": 0,
        "platform": "",
        "sortCategory": "popular",
        "rangeCategory": "main",
        "rangeTime": {"min": 0, "max": 0},
        "gameplay": {"perspective": "", "flow": "", "genre": ""},
        "modifier": ""
      },
      "users": {"sortCategory": "postcount"},
      "filter": "",
      "sort": 0,
      "randomizer": 0
    }
  };

  Map<String, String> headers = {
    'content-type': 'application/json',
    'origin': 'https://howlongtobeat.com/',
    'referer': 'https://howlongtobeat.com/'
  };

  Future<dynamic> search(List<String> query) async {
    final search = payload;
    search.update('searchTerms', (value) => query);
    //print(search);

    Uri url = Uri.https('howlongtobeat.com', '/api/search');
    //print(url.toString());
    final msg = jsonEncode(payload);
    var response = await http.post(url, headers: headers, body: msg);

    if (response.statusCode != 200) {
      String gameName = query.join(' ');
      throw Exception('${gameName} - ${response.statusCode} status code');
    }
    return response.body;
  }
}
