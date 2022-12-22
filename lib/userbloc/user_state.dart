part of 'user_bloc.dart';

abstract class SteamUserState extends Equatable {
  const SteamUserState();

  @override
  List<Object> get props => [];
}

class SteamUserInitial extends SteamUserState {}

class SteamUserLoaded extends SteamUserState {
  final User steamuser;

  const SteamUserLoaded({required this.steamuser});

  @override
  List<Object> get props => [steamuser];
}

class SteamUserNotLoaded extends SteamUserState {
  @override
  List<Object> get props => [];
}
