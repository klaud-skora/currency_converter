import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './currency_picker.dart';
import '../bloc/nav_bar_bloc.dart';

class FirstPage extends StatelessWidget {

  final fromTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    Color textColor = Color(0xff6b6b83);
    Color themeColor = Color(0xff3b8d99);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 40.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Choose your base and target currencies, then you can see how much you can get for any amount you want! ',
                  style: TextStyle(fontSize: 22.0, color: textColor),
                  textAlign: TextAlign.center, 
                ),
                // Container(
                //   alignment: Alignment.center, 
                //   // decoration: BoxDecoration(
                //     // color: Colors.amber[100],
                //     // border: Border.all(
                //     //   color: Colors.amber,
                //     //   width: 1,
                //     // ),
                //     // borderRadius: BorderRadius.circular(8.0),
                //   // ),
                //   padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                //   child: 
                   
                //   ),
                SizedBox(height: 20.0),
                Text ('(Don\'t forget to use Internet to get the most recent data).',
                  style: TextStyle( color: themeColor), 
                  textAlign: TextAlign.center, 
                ),
                SizedBox(height: 20.0),
                
                RaisedButton(
                  onPressed: () => BlocProvider.of<BottomNavigationBloc>(context).add(GetData()),
                  child: Text('Get Data'),
                ),
                Container(
                  child: Text( '${BlocProvider.of<BottomNavigationBloc>(context).currencyRepository.data}' )
                ),
                FlatButton(
                  child: Text('EUR'),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (BuildContext context)  => CurrencyPicker(), 
                      )
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}