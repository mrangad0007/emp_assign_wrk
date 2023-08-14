import 'package:equatable/equatable.dart';

abstract class EmpState extends Equatable {
  const EmpState();

  @override
  List<Object> get props => [];
}

class InitEmpState extends EmpState {
  final int counter;

  const InitEmpState(this.counter);

  @override
  List<Object> get props => [counter];
}

class AddEmpState extends EmpState {}
class RemoveEmpState extends EmpState {}

