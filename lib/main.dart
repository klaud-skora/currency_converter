import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/nav_bar_bloc.dart';
import './ui/home_page.dart';
import './repositories/currency_repository.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<BottomNavigationBloc>(
        create: (context) => BottomNavigationBloc(
          currencyRepository: CurrencyRepository(),
        )
          ..add(AppStarted()),
        child: HomePage(title: 'Currency converter app!'),
      )
    );
  }
}