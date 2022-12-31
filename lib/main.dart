import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steamtimespent/listview.dart';
import 'package:steamtimespent/entryscreen.dart';
import 'package:steamtimespent/userbloc/user_bloc.dart';

void main() {
  //runApp(const SteamIDEntryScreen());
  runApp(MaterialApp(
      //title: 'Steam Time Spent',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: BlocProvider(
          create: (context) => SteamUserBloc(),
          child: ConstrainedBox(
              constraints:
                  BoxConstraints.loose(const Size(300, double.infinity)),
              child: Center(
                widthFactor: 0.5,
                child: SteamIDEntryScreen(),
              )))));
}
