part of 'recentsearches_bloc.dart';

enum RecentSearchesStatus {
  loading,
  success,
}

extension RecentSearchesStatusX on RecentSearchesStatus {
  bool get isSuccess => this == RecentSearchesStatus.success;
  bool get isLoading => this == RecentSearchesStatus.loading;
}

class RecentSearchesState extends Equatable {
  const RecentSearchesState({
    required this.userList,
    required this.status,
  });

  final List<User> userList;
  final RecentSearchesStatus status;

  @override
  List<Object> get props => [userList, status];

  RecentSearchesState copyWith({
    List<User>? userList,
    RecentSearchesStatus? status,
  }) {
    return RecentSearchesState(
      userList: userList ?? this.userList,
      status: status ?? this.status,
    );
  }
}
