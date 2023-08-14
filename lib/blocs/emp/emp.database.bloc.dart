import 'dart:io';
import 'dart:math';

import 'package:empapp/blocs/database.state.dart';
import 'package:empapp/blocs/emp/emp.database.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EmpDatabaseBloc extends Cubit<EmpDatabaseState> {
  EmpDatabaseBloc() : super(EmpInitDatabaseState());

  Database? database;

  Future<void> initEmpDatabase() async {
    final databasePath = await getDatabasesPath();
    // print(databasePath);
    final path = join(databasePath, 'emp.db');
    if (await Directory(dirname(path)).exists()) {
      database = await openDatabase(
          path,
          version: 1,
          onCreate: (Database db, int version) async {
            // When creating the db, create the table
            await db.execute('CREATE TABLE emp (id INTEGER PRIMARY KEY, name TEXT,role TEXT,fromDate TEXT,toDate TEXT)');
          });
      emit(EmpLoadDatabaseState(database!));
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
        database = await openDatabase(
            path,
            version: 1,
            onCreate: (Database db, int version) async {
                // When creating the db, create the table
              await db.execute('CREATE TABLE emp (id INTEGER PRIMARY KEY, name TEXT,role TEXT,fromDate TEXT,toDate TEXT)');
              });
        emit(EmpLoadDatabaseState(database!));
        } catch (e) {
        // ignore: avoid_print
        log(e as num); // actually to be done as log(e.toString())
      }
    }
  }
}
