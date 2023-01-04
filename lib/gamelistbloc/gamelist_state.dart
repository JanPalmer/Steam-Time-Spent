part of 'gamelist_bloc.dart';

enum GameListStatus {
  initial,
  success,
  error,
  loading,
  noGames,
}

extension GameListStatusX on GameListStatus {
  bool get isInitial => this == GameListStatus.initial;
  bool get isSuccess => this == GameListStatus.success;
  bool get isError => this == GameListStatus.error;
  bool get isLoading => this == GameListStatus.loading;
  bool get isNoGames => this == GameListStatus.noGames;
}

class GameListLoadedState extends Equatable {
  const GameListLoadedState({
    required this.recentGames,
    required this.allGames,
    required this.gameEntries,
    //required this.cmplEntries,
    this.recentStatus = GameListStatus.initial,
    this.allStatus = GameListStatus.initial,
    this.reload = false,
  });

  final List<Game> recentGames;
  final List<Game> allGames;
  final Map<String, HowLongToBeatEntry> gameEntries;
  final GameListStatus recentStatus;
  final GameListStatus allStatus;
  final bool reload;

  @override
  List<Object> get props =>
      [recentStatus, allStatus, recentGames, allGames, gameEntries, reload];

  GameListLoadedState copyWith({
    List<Game>? recentGames,
    List<Game>? allGames,
    Map<String, HowLongToBeatEntry>? gameEntries,
    //Map<String, CompletionEntry>? cmplEntries,
    GameListStatus? recentStatus,
    GameListStatus? allStatus,
    bool? reload,
  }) {
    return GameListLoadedState(
      recentGames: recentGames ?? this.recentGames,
      allGames: allGames ?? this.allGames,
      gameEntries: gameEntries ?? this.gameEntries,
      //cmplEntries: cmplEntries ?? this.cmplEntries,
      recentStatus: recentStatus ?? this.recentStatus,
      allStatus: allStatus ?? this.allStatus,
      reload: reload ?? this.reload,
    );
  }
}
