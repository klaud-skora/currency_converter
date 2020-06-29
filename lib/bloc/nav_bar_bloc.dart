import 'dart:async';
import 'package:bloc/bloc.dart';
// import 'package:currencyconverter/models/currency.dart';
import 'package:currencyconverter/ui/first_page.dart';
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

 @override
  List<Object> get props => [];
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
  final String status;
  FirstPageLoaded( { this.base, this.target, this.result, this.status });

  @override
  List<Object> get props => [base, target, result, status];

}

class SecondPageLoaded extends BottomNavigationState {

  @override
  List<Object> get props => [];
}

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  Calculator calc = Calculator();
  final CurrencyRepository currencyRepository;
  int currentIndex = 0;
  String _base = 'EUR';
  String _target = 'PLN';
  double _result = 4.4;
  String _status = 'connected';

  String get base => _base;
  String get target => _target;
  double get result => _result;
  String get status => _status;

  BottomNavigationBloc({
    this.currencyRepository,
  }) : assert(currencyRepository != null);

  @override
  BottomNavigationState get initialState => PageLoading();

  @override
  Stream<BottomNavigationState> mapEventToState(BottomNavigationEvent event) async* {
    if ( event is AppStarted ) {
      this.add(PageTapped(index: this.currentIndex));
    }
    if ( event is PageTapped ) {
      this.currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: this.currentIndex);
      yield PageLoading();

      if (this.currentIndex == 0) {
        yield FirstPageLoaded(base: base, target: target, result: result, status: status); // status: none
      }
      if (this.currentIndex == 1) {
        yield SecondPageLoaded(); // status: none
      }
    }
    if ( event is GetData ) {
      List fetchedData = await _getCurrencyData(this.base);
      List dataToDisplay = fetchedData == null ? currencyRepository.data : fetchedData;
      print(dataToDisplay);
      if (this.currentIndex == 0 ) yield FirstPageLoaded(base: base, target: target, result: 44.4, status: status); // result + status
      if( this.currentIndex == 1  ) yield SecondPageLoaded(); // data + status
    }
     if ( event is ChangeCurrency ) {
      if (this.currentIndex == 0 ) {
        
        event.option == CurrencyOption.base ? _base = event.currency : _target = event.currency;
        yield FirstPageLoaded(base: base, target: target, result: 44.4, status: status); 
      }
        
        
      if( this.currentIndex == 1  ) yield SecondPageLoaded(); // data + status
    }
  }

  Future<List> _getCurrencyData(base) async {
    List data;

      await currencyRepository.fetchData(base);
      data = currencyRepository.data;

    return data;
  }
}
