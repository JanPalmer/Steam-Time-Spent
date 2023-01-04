import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steamtimespent/entryscreen.dart';
import 'package:steamtimespent/recentsearchesbloc/recentsearches_bloc.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  RecentSearchesBloc()..add(GetRecentSearches()),
            )
          ],
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(600, double.infinity)),
            child: const SteamIDEntryScreen(),
          ))));
}
