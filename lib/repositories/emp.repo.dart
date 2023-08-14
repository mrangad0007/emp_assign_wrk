import 'dart:developer';

import 'package:empapp/models/emp.model.dart';
import 'package:sqflite/sqflite.dart';

class EmpRepository {

  Future<List<Employee>> getEmp({
    required Database database,
  }) async {
    final datas = await database.rawQuery('SELECT * FROM emp');
    List<Employee> emps = [];
    log("test $datas");
    for(var item in datas) {
      emps.add(Employee(item['id'] as int, item['name'] as String, item['role'] as String, DateTime.parse(item['fromDate'] as String),
      DateTime.parse(item['toDate'] as String)
      ));
      log("test ${item['name']}");
      log("test ${item['role']}");
      log("test ${item['fromDate']}");
      log("test ${item['toDate']}");
    }
    return emps;
  }

  Future<dynamic> addEmp({
    required Database database,
    required String name,
    required String role,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    return await database.transaction((txn) async {
      await txn.rawInsert("INSERT INTO emp(name,role,fromDate,toDate) VALUES('$name','$role','$fromDate','$toDate')");
    });
  }

  Future<dynamic> updateEmp({
    required Database database,
    required String name,
    required String role,
    required DateTime fromDate,
    required DateTime toDate,
    required int id
  }) async {
    return await database.transaction((txn) async {
      await txn.rawUpdate('UPDATE emp SET name = ?, role = ?, fromDate = ?, toDate = ? WHERE id = ?', ['$name', '$role', '$fromDate', '$toDate', id],);
    });
  }

  Future<dynamic> removeEmp({
    required Database database,
    required int id
  }) async {
    return await database.transaction((txn) async {
      await txn.rawDelete('DELETE FROM emp where id = $id');
    });
  }
}