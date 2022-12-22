part of 'gamelist_bloc.dart';

abstract class GamelistEvent extends Equatable {
  const GamelistEvent();

  @override
  List<Object> get props => [];
}

class GetGames extends GamelistEvent {
  const GetGames();

  @override
  List<Object> get props => [];
}
