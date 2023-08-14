
import 'package:empapp/blocs/emp/emp.bloc.dart';
import 'package:empapp/blocs/emp/emp.database.bloc.dart';
import 'package:empapp/blocs/emp/emp.database.state.dart';
import 'package:empapp/blocs/emp/emp.state.dart';
import 'package:empapp/views/emp_form.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpHomePage extends StatefulWidget {
  const EmpHomePage({super.key, required this.title});

  final String title;

  @override
  State<EmpHomePage> createState() => _EmpHomePageState();
}

class _EmpHomePageState extends State<EmpHomePage> {
  static EmpBloc? _empBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white
            ),
        ),
      ),
      body: BlocConsumer<EmpDatabaseBloc, EmpDatabaseState>(
        listener: (context, state) {
          if (state is EmpLoadDatabaseState) {
            _empBloc = EmpBloc(database: context.read<EmpDatabaseBloc>().database!);
          }
        },
        builder: (context, state) {
          if (state is EmpLoadDatabaseState) {
            return BlocProvider<EmpBloc>(
              create: (context) => _empBloc!..getEmps(),
              child: BlocConsumer<EmpBloc, EmpState>(
                listener: (context, empState) {},
                builder: (context, empState) {
                  if (empState is InitEmpState) {
                    final emps = _empBloc!.emps;
                    if(emps.isEmpty)
                    {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            const SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: ListView.separated(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: emps.length,
                                  separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                      key: Key(emps[index].id.toString()), // Provide a unique key for each item
                                      direction: DismissDirection.endToStart, // Swipe direction
                                      onDismissed: (direction) {
                                        // Handle the item dismissal here
                                        _empBloc!.removeEmp(emps[index].id);
                                      },
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        color: Colors.red,
                                        child: const Icon(Icons.delete, color: Colors.white),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => EmployeeForm(empBloc: _empBloc, emp: emps[index])),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                      emps[index].name,
                                                      style: const TextStyle(
                                                          fontSize: 24.0,
                                                          fontWeight: FontWeight.bold),
                                                    )),
                                                // IconButton(
                                                //     onPressed: () {
                                                //       _empBloc!
                                                //           .removeEmp(emps[index].id);
                                                //     },
                                                //     icon: const Icon(Icons.delete))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                      emps[index].role,
                                                      style: const TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight: FontWeight.bold),
                                                    )),
                                                // IconButton(
                                                //     onPressed: () {
                                                //       _empBloc!
                                                //           .removeEmp(emps[index].id);
                                                //     },
                                                //     icon: const Icon(Icons.delete))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${emps[index].fromDate.toString().substring(0,10)} - ',
                                                  style: const TextStyle(
                                                      fontSize: 18.0
                                                  ),
                                                ),
                                                Text(
                                                  '${emps[index].toDate.toString().substring(0,10)}',
                                                  style: const TextStyle(
                                                      fontSize: 18.0
                                                  ),
                                                ),
                                                // IconButton(
                                                //     onPressed: () {
                                                //       _empBloc!
                                                //           .removeEmp(emps[index].id);
                                                //     },
                                                //     icon: const Icon(Icons.delete))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
        backgroundColor: Colors.blue,
        onPressed: () {
          // if (_empBloc != null) {
          //   log(_name);
          //   // _empBloc!.addEmps(_name);
          // }
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmployeeForm(empBloc: _empBloc)),
          );
        },
        tooltip: 'Add Employee',
        child: const Icon(
            Icons.add,
            color: Colors.white,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}