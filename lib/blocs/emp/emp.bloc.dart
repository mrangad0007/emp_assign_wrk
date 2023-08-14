
import 'dart:developer';

import 'package:empapp/blocs/emp/emp.state.dart';
import 'package:empapp/models/emp.model.dart';
import 'package:empapp/models/todo.model.dart';
import 'package:empapp/repositories/emp.repo.dart';
import 'package:empapp/repositories/todo.repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:empapp/blocs/todo.state.dart';
import 'package:sqflite/sqflite.dart';

class EmpBloc extends Cubit<EmpState> {
  final _empRepo = EmpRepository();
  final Database database;
  EmpBloc({required this.database}) : super(const InitEmpState(0));

  int _counter = 1;
  List<Employee> _emps = [];
  List<Employee> get emps => _emps;

  Future<void> getEmps() async {
    try {
      _emps = await _empRepo.getEmp(database: database);
      emit(InitEmpState(_counter++));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addEmps(String name,String role, DateTime fromDate, DateTime toDate) async {
    try {
      await _empRepo.addEmp(database: database, name: name, role: role, fromDate: fromDate, toDate: toDate);
      emit(InitEmpState(_counter++));
      getEmps();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateEmps(String name,String role, DateTime fromDate, DateTime toDate, int id) async {
    try {
      await _empRepo.updateEmp(database: database, name: name, role: role, fromDate: fromDate, toDate: toDate, id: id);
      emit(InitEmpState(_counter++));
      getEmps();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> removeEmp(int id) async {
    try {
      await _empRepo.removeEmp(database: database, id: id);
      emit(InitEmpState(_counter++));
      getEmps();
    } catch (e) {
      log(e.toString());
    }
  }
}