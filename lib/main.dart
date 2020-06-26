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
    Map<int, Color> color =
      {
      50:Color.fromRGBO(4,131,184, .1),
      100:Color.fromRGBO(4,131,184, .2),
      200:Color.fromRGBO(4,131,184, .3),
      300:Color.fromRGBO(4,131,184, .4),
      400:Color.fromRGBO(4,131,184, .5),
      500:Color.fromRGBO(4,131,184, .6),
      600:Color.fromRGBO(4,131,184, .7),
      700:Color.fromRGBO(4,131,184, .8),
      800:Color.fromRGBO(4,131,184, .9),
      900:Color.fromRGBO(4,131,184, 1),
    };
    MaterialColor themeColor = MaterialColor(0xff3b8d99, color);
    
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: themeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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