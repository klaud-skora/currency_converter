import 'dart:async';
import 'package:bloc/bloc.dart';
import '../models/currency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../repositories/currency_repository.dart';
import '../logic/calculator.dart';

abstract class BottomNavigationEvent extends Equatable {
  BottomNavigationEvent([List props = const []]) : super();
}

class AppStarted extends BottomNavigationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => [];
}

class PageTapped extends BottomNavigationEvent {
  final int index;

  PageTapped({@required this.index}) : super([index]);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'PageTapped: $index';
}

class GetData extends BottomNavigationEvent {

  final double amount;
  GetData({this.amount});

  @override
  List<Object> get props => [amount];
}

class ChangeCurrency extends BottomNavigationEvent {
  final CurrencyOption option;
  final String currency;
  ChangeCurrency({this.option, this.currency});


  @override
  List<Object> get props => [option, currency];
}

@immutable
abstract class BottomNavigationState extends Equatable {
  BottomNavigationState([List props = const []]) : super();
}

class CurrentIndexChanged extends BottomNavigationState {
  final int currentIndex;

  CurrentIndexChanged({@required this.currentIndex}) : super([currentIndex]);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'CurrentIndexChanged to $currentIndex';
}

class PageLoading extends BottomNavigationState {

  @override
  List<Object> get props => [];
  @override
  String toString() => 'PageLoading';
}

class FirstPageLoaded extends BottomNavigationState {

  final String base;
  final String target;
  final double result;
  final Status status;
  final String error;
  FirstPageLoaded({ this.base, this.target, this.result, this.status, this.error });

  @override
  List<Object> get props => [base, target, result, status];

}

class SecondPageLoaded extends BottomNavigationState {
  final String base;
  final List data;
  final Status status;
  final String error;
  SecondPageLoaded({ this.base, this.data, this.status, this.error });

  @override
  List<Object> get props => [base, data];
}

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {

  Calculator calc = Calculator();
  final CurrencyRepository currencyRepository;
  int currentIndex = 0;
  String _base = Currency.EUR.shortcut;
  String _target = Currency.PLN.shortcut;
  double _result = 0;
  Status _status = Status.defaultStatus;
  String _error = '';

  String get base => _base;
  String get target => _target;
  double get result => _result;
  Status get status => _status;
  String get error  => _error;

  BottomNavigationBloc({
    this.currencyRepository,
  }) : assert(currencyRepository != null);

  @override
  BottomNavigationState get initialState => PageLoading();

  @override
  Stream<BottomNavigationState> mapEventToState(BottomNavigationEvent event) async* {
    if ( event is AppStarted ) {
      this.add(PageTapped(index: currentIndex));
    }
    if ( event is PageTapped ) {
      currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: currentIndex);

      if (currentIndex == 0) {
        yield FirstPageLoaded(base: base, target: target, result: result, status: status);
      }
      if (currentIndex == 1) {
        yield SecondPageLoaded(); 
      }
    }
    if ( event is ChangeCurrency ) {
      if (currentIndex == 0 ) {
        
        event.option == CurrencyOption.base ? _base = event.currency : _target = event.currency;
        yield FirstPageLoaded(base: base, target: target, result: result, status: status); 
      }

      if( currentIndex == 1  ) {
        if (event.option == CurrencyOption.base)  _base = event.currency;
        yield SecondPageLoaded( base: base); 
      }
    }
    if ( event is GetData ) {
      if (event.amount != null && event.amount > 0) {
        _error = '';
        yield PageLoading();
        List fetchedData = await _getCurrencyData(base);
        List dataToDisplay = fetchedData == null ? currencyRepository.data : fetchedData;

        _status = fetchedData.length != 0 ? Status.newData : currencyRepository.data.length > 0 ? Status.oldData : Status.noData;
        List data = [];
        dataToDisplay.forEach((rate) =>  data.add( {'currency': rate['currency'], 'value': calc.currencyValue(event.amount, rate['value'])} ));
        
        var targetCurrency = data.length > 0 ? data.firstWhere((rate) => rate['currency'] == target ) : 0; 
        _result = targetCurrency != 0 ? targetCurrency['value'] : 0;

        if ( currentIndex == 0 ) yield FirstPageLoaded(base: base, target: target, result: result, status: status, error: error); // result + status
        if ( currentIndex == 1  ) yield SecondPageLoaded(base: base, data: data, status: status, error: error); 
      } else {
        _error = 'Input is wrong';
        _result = 0;
        if ( currentIndex == 0 ) yield FirstPageLoaded(base: base, target: target, result: result, status: status, error: error); // result + status
        if ( currentIndex == 1  ) yield SecondPageLoaded(base: base, data: [], status: status, error: error); 
      }
    }

  }

  Future<List> _getCurrencyData(base) async {

    List data;
    await currencyRepository.fetchData(base);
    data = currencyRepository.data;
    return data;

  }
}
