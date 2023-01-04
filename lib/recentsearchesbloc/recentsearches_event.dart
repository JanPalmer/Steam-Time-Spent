part of 'recentsearches_bloc.dart';

abstract class RecentSearchesEvent extends Equatable {
  const RecentSearchesEvent();

  @override
  List<Object> get props => [];
}

class GetRecentSearches extends RecentSearchesEvent {}

class AddUserToList extends RecentSearchesEvent {
  final User newuser;

  const AddUserToList({
    required this.newuser,
  });

  @override
  List<Object> get props => [newuser];
}

class SaveRecentSearches extends RecentSearchesEvent {}
