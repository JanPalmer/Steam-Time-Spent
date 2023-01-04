import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:steamtimespent/user.dart';

part 'recentsearches_event.dart';
part 'recentsearches_state.dart';

class RecentSearchesBloc
    extends Bloc<RecentSearchesEvent, RecentSearchesState> {
  RecentSearchesBloc()
      : super(const RecentSearchesState(
          userList: [],
          status: RecentSearchesStatus.loading,
        )) {
    on<GetRecentSearches>(getRecentSearches);
    on<AddUserToList>(((event, emit) {
      User newuser = event.newuser;
      addUserToList(newuser);
      emit(
        state.copyWith(
          userList: recentSearchesList,
          status: RecentSearchesStatus.success,
        ),
      );
    }));
    on<SaveRecentSearches>(((event, emit) {
      saveRecentSearches();
    }));
  }

  static const String fileName = 'recent_searches.txt';
  static const int maxRecentSearchesNumber = 10;

  List<User> recentSearchesList = [];

  void getRecentSearches(
      RecentSearchesEvent event, Emitter<RecentSearchesState> emit) async {
    emit(
      state.copyWith(
        status: RecentSearchesStatus.loading,
      ),
    );

    final searchesFile = await _recentSearchesFile;

    if (searchesFile.lengthSync() == 0) {
      emit(
        state.copyWith(
          status: RecentSearchesStatus.success,
        ),
      );
      return;
    }

    final usersString = await searchesFile.readAsString();

    Map<String, dynamic> mapToDecode = jsonDecode(usersString);
    List<dynamic> userList1 = mapToDecode.values.toList();
    List<dynamic> userList = userList1.first;
    //print(userList[0]);
    recentSearchesList = List<User>.empty(growable: true);
    for (int i = 0; i < userList.length; i++) {
      User user = User.fromJson(userList[i]);
      recentSearchesList.add(user);
    }

    emit(
      state.copyWith(
        userList: recentSearchesList,
        status: RecentSearchesStatus.success,
      ),
    );
  }

  void saveRecentSearches() async {
    if (recentSearchesList.isEmpty) return;

    String header = 'recent_searches';
    Map<String, dynamic> mapToEncode = <String, dynamic>{
      header: recentSearchesList
    };
    String encodedData = jsonEncode(mapToEncode);

    //print(encodedData);

    File file = await _recentSearchesFile;
    file.writeAsString(encodedData);
  }

  void addUserToList(User user) {
    if (recentSearchesList == []) {
      recentSearchesList = List<User>.empty(growable: true);
    }

    // If user is already on the recent searches list, move him to front
    if (recentSearchesList.contains(user)) {
      recentSearchesList.remove(user);
      recentSearchesList.insert(0, user);
    } else {
      // If list already contains 6 users, delete the last one
      if (recentSearchesList.length >= maxRecentSearchesNumber) {
        recentSearchesList.removeAt(maxRecentSearchesNumber - 1);
      }
      recentSearchesList.insert(0, user);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _recentSearchesFile async {
    final path = await _localPath;
    File file = File('$path\\$fileName');
    if (file.existsSync() == false) {
      file = await file.create();
    }
    return file;
  }
}
