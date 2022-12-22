part of 'user_bloc.dart';

abstract class SteamUserEvent extends Equatable {
  const SteamUserEvent();

  @override
  List<Object> get props => [];
}

class LoadSteamUser extends SteamUserEvent {
  final User steamuser;

  const LoadSteamUser(this.steamuser);

  @override
  List<Object> get props => [steamuser];
}

class UnloadSteamUser extends SteamUserEvent {}
