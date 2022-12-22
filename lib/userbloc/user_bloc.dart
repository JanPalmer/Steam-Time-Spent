import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:steamtimespent/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class SteamUserBloc extends Bloc<SteamUserEvent, SteamUserState> {
  SteamUserBloc() : super(SteamUserInitial()) {
    on<LoadSteamUser>((event, emit) {
      emit(SteamUserLoaded(steamuser: event.steamuser));
    });
    on<UnloadSteamUser>((event, emit) {
      if (state is SteamUserLoaded) {
        emit(SteamUserNotLoaded());
      }
    });
  }
}
