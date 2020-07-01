import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/currency.dart';
import './currency_picker.dart';
import '../logic/parser.dart';
import '../bloc/nav_bar_bloc.dart';
import '../bloc/text_field_bloc.dart';
import './internet_status.dart';

class SecondPage extends StatelessWidget {

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
                InternetStatus(status: BlocProvider.of<BottomNavigationBloc>(context).state.props[2]),
                SizedBox(height: 15.0),
                Text('Choose a currency and it\'s amount \nto see the values of others! ',
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
                            Text('${BlocProvider.of<BottomNavigationBloc>(context).basicBase}'),
                            Icon(Icons.arrow_right, color: Color(0xffaa4b6b)),
                          ],
                        ),
                        onPressed: () => changeCurrency(context, BlocProvider.of<BottomNavigationBloc>(context).basicBase, CurrencyOption.basicBase)
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(  '${BlocProvider.of<BottomNavigationBloc>(context).state.props[3]}', style: TextStyle( color: Colors.red)),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(width: 2.0, color: Color(0xffaa4b6b)),
                  ),
                  onPressed: () => BlocProvider.of<BottomNavigationBloc>(context).add(GetData(amount: amount)),
                  child: Text('SHOW DATA', style: TextStyle( color: textColor, fontSize: 22.0)),
                ),
                SizedBox(height: 20.0),
                BlocProvider.of<BottomNavigationBloc>(context).data.length != 0 && BlocProvider.of<BottomNavigationBloc>(context).state.props[1] != null ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  itemCount: Currency.values.length - 1,
                  itemBuilder: (context, index){
                  return Container(
                    padding: const EdgeInsets.only(top: 20.0, left: 65.0, right: 65.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xff3b8d99),
                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                            ),
                            height: 35.0,   
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 2.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      width: 68.0,
                                      height: 50.0,
                                      padding: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xffaa4b6b).withOpacity(.8),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), bottomLeft: Radius.circular(40.0) ),
                                      ),
                                      child: Text('${BlocProvider.of<BottomNavigationBloc>(context).data[index]['value']}'),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text('${BlocProvider.of<BottomNavigationBloc>(context).currencyRepository.data[index]['currency']}', style: TextStyle(fontSize: 16.0)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    );
                  },
                ) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}