part of 'gamelist_bloc.dart';

abstract class GameListEvent extends Equatable {
  const GameListEvent(this.steamid);

  final String steamid;

  bool IsAllGamesEvent();

  @override
  List<Object> get props => [steamid];
}

class GetAllGames extends GameListEvent {
  const GetAllGames(String steamid) : super(steamid);

  @override
  bool IsAllGamesEvent() {
    return true;
  }

  @override
  List<Object> get props => [steamid];
}

class GetRecentGames extends GameListEvent {
  const GetRecentGames(String steamid) : super(steamid);

  @override
  bool IsAllGamesEvent() {
    return false;
  }

  @override
  List<Object> get props => [steamid];
}
