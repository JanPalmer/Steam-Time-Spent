part of 'gamelist_bloc.dart';

enum GameListStatus {
  initial,
  success,
  error,
  loading,
}

extension GameListStatusX on GameListStatus {
  bool get isInitial => this == GameListStatus.initial;
  bool get isSuccess => this == GameListStatus.success;
  bool get isError => this == GameListStatus.error;
  bool get isLoading => this == GameListStatus.loading;
}

class GameListLoadedState extends Equatable {
  const GameListLoadedState({
    this.status = GameListStatus.initial,
    required this.games,
  });

  final List<Game> games;
  final GameListStatus status;

  @override
  List<Object> get props => [status, games];

  GameListLoadedState copyWith({
    List<Game>? games,
    GameListStatus? status,
  }) {
    return GameListLoadedState(
      games: games ?? this.games,
      status: status ?? this.status,
    );
  }
}
