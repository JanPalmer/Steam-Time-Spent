part of 'gamelist_bloc.dart';

abstract class GamelistEvent extends Equatable {
  const GamelistEvent();

  @override
  List<Object> get props => [];
}

class GetGames extends GamelistEvent {
  final String steamid;

  const GetGames(this.steamid);

  @override
  List<Object> get props => [steamid];
}
