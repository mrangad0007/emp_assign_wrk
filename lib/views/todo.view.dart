import 'dart:developer';

import 'package:empapp/blocs/database.bloc.dart';
import 'package:empapp/blocs/database.state.dart';
import 'package:empapp/blocs/todo.bloc.dart';
import 'package:empapp/blocs/todo.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = "";
  TodoBloc? _todoBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: BlocConsumer<DatabaseBloc, DatabaseState>(
        listener: (context, state) {
          if (state is LoadDatabaseState) {
            _todoBloc =
                TodoBloc(database: context.read<DatabaseBloc>().database!);
          }
        },
        builder: (context, state) {
          if (state is LoadDatabaseState) {
            return BlocProvider<TodoBloc>(
              create: (context) => _todoBloc!..getTodos(),
              child: BlocConsumer<TodoBloc, TodoState>(
                listener: (context, todoState) {},
                builder: (context, todoState) {
                  if (todoState is InitTodoState) {
                    final todos = _todoBloc!.todos;
                    if(todos.isEmpty)
                    {
                      return Column(
                        children: [
                          TextFormField(
                            maxLines: 1,
                            onChanged: (value) {
                              setState(() {
                                _text = value;
                              });
                            },
                          ),
                          Center(
                            child: Image.asset('assets/no_data.png'),
                          ),
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              maxLines: 1,
                              onChanged: (value) {
                                setState(() {
                                  _text = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: todos.length,
                              separatorBuilder: (context, index) =>
                              const SizedBox(
                                height: 10.0,
                              ),
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          todos[index].text,
                                          style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          _todoBloc!
                                              .removeTodo(todos[index].id);
                                        },
                                        icon: const Icon(Icons.delete))
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      );
                    }
                  }

                  return Center(
                    child: Text('No Data'),
                  );
                },
              ),
            );
          }

          return const Center(
            child: Text('Database not loaded'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_todoBloc != null) {
            log(_text);
            _todoBloc!.addTodos(_text);
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}