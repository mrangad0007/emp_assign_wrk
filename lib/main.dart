import 'dart:developer';

import 'package:empapp/blocs/database.bloc.dart';
import 'package:empapp/blocs/database.state.dart';
import 'package:empapp/blocs/emp/emp.database.bloc.dart';
import 'package:empapp/blocs/todo.bloc.dart';
import 'package:empapp/blocs/todo.state.dart';
import 'package:empapp/views/emp_form.view.dart';
import 'package:empapp/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocOverrides.runZoned(() => runApp(MultiBlocProvider(providers: [
        BlocProvider<EmpDatabaseBloc>(
            create: (context) => EmpDatabaseBloc()..initEmpDatabase())
      ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emp App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const EmpHomePage(title: "Employee List",),
    );
  }
}


