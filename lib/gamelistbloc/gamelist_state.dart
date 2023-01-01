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
    required this.recentGames,
    required this.allGames,
    required this.recentGamesEntries,
    required this.allGamesEntries,
    this.recentStatus = GameListStatus.initial,
    this.allStatus = GameListStatus.initial,
  });

  final List<Game> recentGames;
  final List<Game> allGames;
  final Map<String, HowLongToBeatEntry> recentGamesEntries;
  final Map<String, HowLongToBeatEntry> allGamesEntries;
  final GameListStatus recentStatus;
  final GameListStatus allStatus;

  @override
  List<Object> get props => [recentStatus, allStatus, recentGames, allGames];

  GameListLoadedState copyWith({
    List<Game>? recentGames,
    List<Game>? allGames,
    final Map<String, HowLongToBeatEntry>? recentGamesEntries,
    final Map<String, HowLongToBeatEntry>? allGamesEntries,
    GameListStatus? recentStatus,
    GameListStatus? allStatus,
  }) {
    return GameListLoadedState(
      recentGames: recentGames ?? this.recentGames,
      allGames: allGames ?? this.allGames,
      recentGamesEntries: recentGamesEntries ?? this.recentGamesEntries,
      allGamesEntries: allGamesEntries ?? this.allGamesEntries,
      recentStatus: recentStatus ?? this.recentStatus,
      allStatus: allStatus ?? this.allStatus,
    );
  }
}
