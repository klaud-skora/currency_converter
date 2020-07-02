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
  List<Object> get props => [];
}

class PageTapped extends BottomNavigationEvent {
  final int index;

  PageTapped({@required this.index}) : super([index]);

  @override
  List<Object> get props => [];
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
}

class PageLoading extends BottomNavigationState {

  @override
  List<Object> get props => [];
}

class FirstPageLoaded extends BottomNavigationState {

  final String base;
  final String target;
  final double result;
  final Status status;
  final String error;
  FirstPageLoaded({ this.base, this.target, this.result, this.status, this.error });

  @override
  List<Object> get props => [base, target, result, status, error];
}

class SecondPageLoaded extends BottomNavigationState {

  final String basicBase;
  final List data;
  final Status status;
  final String error;
  SecondPageLoaded({ this.basicBase, this.data, this.status, this.error });

  @override
  List<Object> get props => [basicBase, data, status, error];
}

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {

  Calculator calc = Calculator();
  final CurrencyRepository currencyRepository;
  List _data = [];
  int currentIndex = 0;
  
  String _base = Currency.EUR.shortcut;
  String _target = Currency.PLN.shortcut;
  String _basicBase = Currency.EUR.shortcut;

  List get data => _data;
  String get base => _base;
  String get target => _target;
  String get basicBase => _basicBase;

  BottomNavigationBloc({this.currencyRepository});

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
        yield FirstPageLoaded(base: base, target: target, result: 0, status: Status.defaultStatus, error: Error.none.text);
      }
      if (currentIndex == 1) {
        yield SecondPageLoaded(basicBase: basicBase, data: null, status: Status.defaultStatus, error: Error.none.text); 
      }
    }
    if ( event is ChangeCurrency ) {
      if (currentIndex == 0 ) {
        
        event.option == CurrencyOption.base ? _base = event.currency : _target = event.currency;
        yield FirstPageLoaded(base: base, target: target, result: 0, status: Status.defaultStatus, error: Error.none.text); 
      }

      if( currentIndex == 1  ) {
        _basicBase = event.currency;
        yield SecondPageLoaded( basicBase: basicBase, data: null, status: Status.defaultStatus, error: Error.none.text); 
      }
    }
    if ( event is GetData ) {
      Status status = Status.defaultStatus;
      
      yield PageLoading();

      List fetchedData = await _getCurrencyData(base);
      List sharedData = await _getCurrencySharedData(base);
      
      List dataToDisplay = fetchedData.length == 0 ? sharedData : fetchedData;
      if (event.amount != null && event.amount > 0) {
        status = fetchedData.length != 0 ? Status.newData : sharedData.length != 0 ? Status.oldData : Status.noData;

        _data = [];
        double result = 0;
        if( dataToDisplay != null ) {
          dataToDisplay.forEach((rate) =>  _data.add( {'currency': rate['currency'], 'value': calc.currencyValue(event.amount, rate['value'])} ));
          
          var targetCurrency = data.length > 0 ? data.firstWhere((rate) => rate['currency'] == target ) : sharedData.length > 0 ? sharedData.firstWhere((rate) => rate['currency'] == target ) : 0; 
          result = targetCurrency != 0 ? targetCurrency['value'] : 0.0;
        }

        if ( currentIndex == 0 ) yield FirstPageLoaded(base: base, target: target, result: result, status: status, error: Error.none.text);
        if ( currentIndex == 1  ) yield SecondPageLoaded(basicBase: basicBase, data: data, status: status, error: Error.none.text); 
      } else {
        if ( currentIndex == 0 ) yield FirstPageLoaded(base: base, target: target, result: 0, status: status, error: Error.input.text);
        if ( currentIndex == 1  ) yield SecondPageLoaded(basicBase: basicBase, data: null, status: status, error: Error.input.text); 
      }
    }

  }

  Future<List> _getCurrencyData(base) async {

    List data;
    await currencyRepository.fetchData(base);
    data = currencyRepository.data;
    return data;

  }

  Future<List> _getCurrencySharedData(base) async {

    List sharedData;
    await currencyRepository.showData(base);
    sharedData = currencyRepository.sharedData;
    return sharedData;
  }
}

