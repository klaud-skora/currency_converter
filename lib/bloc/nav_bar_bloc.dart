import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../repositories/currency_repository.dart';

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

  @override
  List<Object> get props => [];
}

class SecondPageLoaded extends BottomNavigationState {

  @override
  List<Object> get props => [];
}

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  final CurrencyRepository currencyRepository;
  int currentIndex = 0;

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
        yield FirstPageLoaded(); // status: none
      }
      if (this.currentIndex == 1) {
        yield SecondPageLoaded(); // status: none
      }
    }
    if ( event is GetData ) {
      List fetchedData = await _getCurrencyData();
      List dataToDisplay = fetchedData == null ? currencyRepository.data : fetchedData;
      print('give me data');
      print(dataToDisplay);
      if (this.currentIndex == 0 ) yield FirstPageLoaded(); // data + status
      if( this.currentIndex == 1  ) yield SecondPageLoaded(); // data + status
    }
  }

  Future<List> _getCurrencyData() async {
    List data;

      await currencyRepository.fetchData();
      data = currencyRepository.data;

    return data;
  }
}