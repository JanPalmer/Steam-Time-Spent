part of 'gamelist_bloc.dart';

abstract class GameListEvent extends Equatable {
  const GameListEvent(this.steamid);

  final String steamid;

  @override
  List<Object> get props => [steamid];
}

class GetGames extends GameListEvent {
  const GetGames(String steamid) : super(steamid);

  @override
  List<Object> get props => [steamid];
}
