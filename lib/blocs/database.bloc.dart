import 'dart:io';
import 'dart:math';

import 'package:empapp/blocs/database.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseBloc extends Cubit<DatabaseState> {
  DatabaseBloc() : super(InitDatabaseState());

  Database? database;

  Future<void> initDatabase() async {
    final databasePath = await getDatabasesPath();
    // print(databasePath);
    final path = join(databasePath, 'todo.db');
    if (await Directory(dirname(path)).exists()) {
      database = await openDatabase(
          path,
          version: 1,
          onCreate: (Database db, int version) async {
            // When creating the db, create the table
            await db.execute('CREATE TABLE todo (id INTEGER PRIMARY KEY, name TEXT)');
          });
      emit(LoadDatabaseState());
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
        database = await openDatabase(
            path,
            version: 1,
            onCreate: (Database db, int version) async {
                // When creating the db, create the table
                await db.execute('CREATE TABLE todo (id INTEGER PRIMARY KEY, name TEXT)');
              });
              emit(LoadDatabaseState());
        } catch (e) {
        // ignore: avoid_print
        log(e as num); // actually to be done as log(e.toString())
      }
    }
  }
}
