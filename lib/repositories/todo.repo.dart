import 'dart:developer';

import 'package:empapp/models/todo.model.dart';
import 'package:sqflite/sqflite.dart';

class TodoRepository {

  Future<List<Todo>> getTodo({
    required Database database,
  }) async {
    final datas = await database.rawQuery('SELECT * FROM todo');
    List<Todo> todos = [];
    log("test $datas");
    for(var item in datas) {
      todos.add(Todo(item['id'] as int, item['name'] as String));
      log("test ${item['name']}");
    }
    return todos;
  }

  Future<dynamic> addTodo({
    required Database database,
    required String text,
  }) async {
    return await database.transaction((txn) async {
        await txn.rawInsert("INSERT INTO todo(name) VALUES('$text')");
    });
  }

  Future<dynamic> removeTodo({
    required Database database,
    required int id
  }) async {
    return await database.transaction((txn) async {
      await txn.rawDelete('DELETE FROM todo where id = $id');
    });
  }
}