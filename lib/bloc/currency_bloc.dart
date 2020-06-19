import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum ConverterEvent { 
  // SetBaseValueEvent, 
  // SetConvertionValueEvent, 
  // FetchDataEvent, 
  ChangePageEvent, 
  // ShowAllConvertionsEvent,
}

abstract class ConverterState extends Equatable {
  @override
  List<Object> get props => [];
}

class ConverterDefaultState extends ConverterState {}
class ConverterFetchSuccessState extends ConverterState {}
class ConverterFetchErrorState extends ConverterState {}

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {

  @override
  ConverterState get initialState => ConverterDefaultState();

  @override
  Stream<ConverterState> mapEventToState(ConverterEvent event) async* {
    switch(event) {
      case ConverterEvent.ChangePageEvent:
        yield ConverterDefaultState();
        break;

    }
  }
}