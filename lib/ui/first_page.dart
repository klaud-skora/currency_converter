import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/currency.dart';
import './currency_picker.dart';
import '../logic/parser.dart';
import '../bloc/nav_bar_bloc.dart';
import '../bloc/text_field_bloc.dart';
import './internet_status.dart';

class FirstPage extends StatelessWidget {

  final TextBloc _textBloc = TextBloc();

  changeCurrency(BuildContext context, String marked, CurrencyOption currencyOption) async {
    
    final pickedCurrency = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CurrencyPicker(option: currencyOption, marked: marked)),
    );
    
    BlocProvider.of<BottomNavigationBloc>(context).add(ChangeCurrency(option: currencyOption, currency: pickedCurrency));
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Color(0xff6b6b83);
    Color themeColor = Color(0xff3b8d99);
    double amount = 0;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InternetStatus(status: BlocProvider.of<BottomNavigationBloc>(context).state.props[3]),
                SizedBox(height: 15.0),
                Text('Choose your base and target currencies, then you can see how much you can get for any amount you want! ',
                  style: TextStyle(fontSize: 17.0, color: textColor),
                  textAlign: TextAlign.center, 
                ),
                SizedBox(height: 20.0),
                Text ('(Don\'t forget to use Internet \nto get the most recent data).',
                  style: TextStyle( color: themeColor, fontSize: 12.0), 
                  textAlign: TextAlign.center, 
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Flexible(
                        child: SizedBox(
                          width: 80.0,
                          child: StreamBuilder(
                            stream: _textBloc.textStream,
                            builder: (context, AsyncSnapshot<String> textSnap) {
                              return TextField(
                                onChanged: (String text) {
                                  _textBloc.updateText(text);
                                  amount = parser(text);
                                },
                                decoration: InputDecoration(hintText: 'Amount'),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox( width: 15.0 ),
                    Container(
                      decoration: BoxDecoration(border: Border( bottom: BorderSide(color: Color(0xffaa4b6b), width: 1.0))),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Text('${BlocProvider.of<BottomNavigationBloc>(context).state.props[0]}'),
                            Icon(Icons.arrow_right, color: Color(0xffaa4b6b)),
                          ],
                        ),
                        onPressed: () => changeCurrency(context, BlocProvider.of<BottomNavigationBloc>(context).state.props[0], CurrencyOption.base)
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(  '${BlocProvider.of<BottomNavigationBloc>(context).state.props[4]}', style: TextStyle( color: Colors.red)),
                ),
                SizedBox(height: 20.0),
                Icon(Icons.keyboard_arrow_down, size: 40.0, color: themeColor),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.4,
                      ),
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(.4),
                        border: Border.all(color: themeColor, width: 2.0),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Text( '${BlocProvider.of<BottomNavigationBloc>(context).state.props[2]}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox( width: 15.0 ),
                    Container(
                      decoration: BoxDecoration(border: Border( bottom: BorderSide(color: Color(0xffaa4b6b), width: 1.0))),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Text('${BlocProvider.of<BottomNavigationBloc>(context).state.props[1]}'),
                            Icon(Icons.arrow_right, color: Color(0xffaa4b6b)),
                          ],
                        ),
                        onPressed: () => changeCurrency(context, BlocProvider.of<BottomNavigationBloc>(context).state.props[1], CurrencyOption.target),
                      ),
                    ),
                  ],
                ),
                SizedBox( height: 50.0 ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(width: 2.0, color: Color(0xffaa4b6b)),
                  ),
                  onPressed: () => BlocProvider.of<BottomNavigationBloc>(context).add(GetData(amount: amount)),
                  child: Text('CONVERT', style: TextStyle( color: textColor, fontSize: 22.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}