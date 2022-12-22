import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'gamelist_event.dart';
part 'gamelist_state.dart';

class GamelistBloc extends Bloc<GamelistEvent, GamelistState> {
  GamelistBloc() : super(GamelistInitial()) {
    on<GamelistEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
