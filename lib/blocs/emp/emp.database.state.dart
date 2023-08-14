import 'package:sqflite/sqflite.dart';

abstract class EmpDatabaseState {}

class EmpInitDatabaseState extends EmpDatabaseState{}
class EmpLoadDatabaseState extends EmpDatabaseState{

  final Database database;

  EmpLoadDatabaseState(this.database);
}



