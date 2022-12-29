part of 'gamelist_bloc.dart';

enum AllGamesStatus {
  initial,
  success,
  error,
  loading,
}

extension AllGamesStatusX on AllGamesStatus {
  bool get isInitial => this == AllGamesStatus.initial;
  bool get isSuccess => this == AllGamesStatus.success;
  bool get isError => this == AllGamesStatus.error;
  bool get isLoading => this == AllGamesStatus.loading;
}

class AllGamesState extends Equatable {
  const AllGamesState({
    this.status = AllGamesStatus.initial,
    required this.games,
  });

  final List<Game> games;
  final AllGamesStatus status;

  @override
  List<Object> get props => [status, games];

  AllGamesState copyWith({
    List<Game>? games,
    AllGamesStatus? status,
  }) {
    return AllGamesState(
      games: games ?? this.games,
      status: status ?? this.status,
    );
  }
}
