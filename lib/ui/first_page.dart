import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/nav_bar_bloc.dart';

class FirstPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Container( 
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  border: Border.all(
                    color: Colors.amber,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Text('Fill neded data to convert', style: TextStyle(fontSize: 22.0), ),
              ),
              RaisedButton(
                onPressed: () => BlocProvider.of<BottomNavigationBloc>(context).add(GetData()),
                child: Text('Get Data'),
              ),
              Card(
                child: Text( '${BlocProvider.of<BottomNavigationBloc>(context).currencyRepository.data}' )
              ),
            ],
          ),
        ),
      ),
    );
  }
}