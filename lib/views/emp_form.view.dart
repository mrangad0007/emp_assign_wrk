import 'dart:developer';

import 'package:empapp/blocs/emp/emp.bloc.dart';
import 'package:empapp/blocs/emp/emp.database.bloc.dart';
import 'package:empapp/blocs/emp/emp.database.state.dart';
import 'package:empapp/models/emp.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeForm extends StatefulWidget {
  final EmpBloc? empBloc;
  final Employee? emp;

  const EmployeeForm({super.key, this.empBloc, this.emp});

  @override
  _EmployeeFormState createState() => _EmployeeFormState();

}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController textFieldController = TextEditingController();

  String _name = "";

  String selectedRole = '';
  DateTime fromDate = DateTime.now();
  DateTime? toDate;


  @override
  void initState() {
    if(widget.emp != null){
      textFieldController.text = widget.emp!.name;
      selectedRole = widget.emp!.role;
      fromDate = widget.emp!.fromDate;
      toDate = widget.emp!.toDate;
    }
  }

  Future<void> _showRoleOptions() async {
    String selectedOption = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Product Designer'),
              onTap: () {
                Navigator.pop(context, 'Product Designer');
              },
            ),
            ListTile(
              title: Text('Flutter Developer'),
              onTap: () {
                Navigator.pop(context, 'Flutter Developer');
              },
            ),
            ListTile(
              title: Text('QA Tester'),
              onTap: () {
                Navigator.pop(context, 'QA Tester');
              },
            ),
            ListTile(
              title: Text('Product Owner'),
              onTap: () {
                Navigator.pop(context, 'Product Owner');
              },
            ),
          ],
        );
      },
    );

    if (selectedOption != null) {
      setState(() {
        selectedRole = selectedOption;
      });
    }
  }

  DateTime selectedDate = DateTime.now();


  Future<void> _showDatePicker(BuildContext context, String type) async {

    DateTime currentDate = type == 'from' ? fromDate : toDate ?? DateTime.now();

      final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      cancelText: "Cancel",
      confirmText: "Save",
        selectableDayPredicate: (DateTime date) {
          return true; // Return true to enable all days to be selected
        },
        // builder: (BuildContext context, Widget? child) {
        //   return Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () {
        //               Navigator.pop(context, currentDate);
        //             },
        //             child: Text('Today'),
        //           ),
        //           ElevatedButton(
        //             onPressed: () {
        //               Navigator.pop(context, currentDate.subtract(Duration(days: currentDate.weekday - 1)).add(Duration(days: 7)));
        //             },
        //             child: Text('Next Monday'),
        //           ),
        //           ElevatedButton(
        //             onPressed: () {
        //               Navigator.pop(context, currentDate.subtract(Duration(days: currentDate.weekday - 2)).add(Duration(days: 7)));
        //             },
        //             child: Text('Next Tuesday'),
        //           ),
        //           ElevatedButton(
        //             onPressed: () {
        //               Navigator.pop(context, currentDate.add(Duration(days: 7)));
        //             },
        //             child: Text('After 1 Week'),
        //           ),
        //         ],
        //       ),
        //       child!, // Default showDatePicker calendar
        //     ],
        //   );
        // },
    );

    if (pickedDate != null) {
      setState(() {
        if (type == 'from') {
          fromDate =
              DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
        } else {
          toDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text(
          'Add Employee Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: textFieldController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Employee name', // Label for the text field
                  prefixIcon: Icon(
                    Icons.person_outline_outlined,
                    color: Colors.blue,
                  ), // Icon before the input field
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    // Blue border when focused
                    borderRadius: BorderRadius.circular(
                        4.0), // Border radius of the input field
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    // Blue border when enabled
                    borderRadius: BorderRadius.circular(
                        4.0), // Border radius of the input field
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null; // Return null if validation passes
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _showRoleOptions(),
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                        color: Colors.blue,
                      ), // Add your desired leading icon here
                      const SizedBox(width: 10.0),
                      Text(
                        selectedRole.isNotEmpty
                            ? selectedRole
                            : 'Select a Role',
                        style: TextStyle(
                          color: selectedRole.isNotEmpty
                              ? (_formkey.currentState?.validate() ?? false)
                                  ? Colors.black
                                  : Colors.red
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _showDatePicker(context, 'from'),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.blue,
                          ),
                          // Add your desired leading icon here
                          const SizedBox(width: 10.0),
                          // Add some spacing between icon and Container
                          Container(
                            child: fromDate != null
                                ? Text(
                                    "${DateFormat('dd-MMM-yyyy').format(fromDate)}")
                                : Text("Today"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_outlined,
                    color: Colors.blue, // Customize the arrow icon's color
                  ),
                  GestureDetector(
                    onTap: () => _showDatePicker(context, 'to'),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.blue,
                        ),
                        // Add your desired leading icon here
                        const SizedBox(width: 10.0),
                        // Add some spacing between icon and Container
                        Container(
                          child: toDate != null
                              ? Text(
                                  "${DateFormat('dd-MMM-yyyy').format(toDate!)}")
                              : Text(
                                  "No Date",
                                  style: TextStyle(
                                    color: (_formkey.currentState?.validate() ??
                                                false) &&
                                            toDate != null
                                        ? Colors.black
                                        : Colors.red,
                                  ),
                                ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Customize the corner radius here
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.blue, // Set the text color
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate() &&
                          selectedRole.isNotEmpty &&
                          fromDate != null &&
                          toDate != null) {
                        // log("Saved Pressed");
                        // log(_name);
                        // log(selectedRole);
                        // log(fromDate.toString());
                        // log(toDate.toString());
                        if (widget.empBloc != null) {
                          log(_name);
                          log(selectedRole);
                          log(fromDate.toString());
                          log(toDate.toString());

                          if(widget.emp != null){
                            widget.empBloc!
                                .updateEmps(_name, selectedRole, fromDate, toDate!, widget.emp!.id);
                          } else {
                            widget.empBloc!
                                .addEmps(_name, selectedRole, fromDate, toDate!);
                          }

                          log("Success");
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Customize the corner radius here
                        ),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white, // Set the text color
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
