import 'dart:async';
import 'package:bloc/bloc.dart';
import '../models/currency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../repositories/currency_repository.dart';
import '../logic/calculator.dart';

abstract class BottomNavigationEvent extends Equatable {
  BottomNavigationEvent([List props = const []]);
}

class AppStarted extends BottomNavigationEvent {

  @override
  List<Object> get props => [];
}

class PageTapped extends BottomNavigationEvent {
  final int index;

  PageTapped({@required this.index});

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
  BottomNavigationState([List props = const []]);
}

class CurrentIndexChanged extends BottomNavigationState {
  final int currentIndex;
  CurrentIndexChanged({this.currentIndex});

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
      print(fetchedData);
      List dataToDisplay = fetchedData.length == 0 ? sharedData : fetchedData;

      if (event.amount != null && event.amount > 0) {
        status = fetchedData.length != 0 ? Status.newData : sharedData.length != 0 ? Status.oldData : Status.noData;

        _data = [];
        double result = 0;
        if( dataToDisplay != null ) {
          dataToDisplay.forEach((rate) =>  _data.add( {'currency': rate['currency'], 'value': calc.currencyValue(event.amount, rate['value'])} ));
          
          var targetCurrency = data.length > 0 ? getTargetCurrency(data) : sharedData.length > 0 ? getTargetCurrency(sharedData) : 0; 
          result = targetCurrency != 0 ? targetCurrency['value'] : 0.0;
        }

        yield currentIndex == 0 
        ? FirstPageLoaded(base: base, target: target, result: result, status: status, error: Error.none.text)
        : SecondPageLoaded(basicBase: basicBase, data: data, status: status, error: Error.none.text); 
      } else {
        yield currentIndex == 0 
        ? FirstPageLoaded(base: base, target: target, result: 0, status: status, error: Error.input.text) 
        : SecondPageLoaded(basicBase: basicBase, data: null, status: status, error: Error.input.text); 
      }
    }

  }

  getTargetCurrency(data) {
    return data.firstWhere((rate) => rate['currency'] == target );
  }

  Future<List> _getCurrencyData(base) async {
    await currencyRepository.fetchData(base);
    return currencyRepository.data;
  }

  Future<List> _getCurrencySharedData(base) async {
    await currencyRepository.showData(base);
    return currencyRepository.sharedData;
  }
  
}

