import 'package:flutter/material.dart';
import '../models/currency.dart';
import './currency_extension.dart';

class CurrencyPicker extends StatelessWidget {
  final String marked;
  final CurrencyOption option;

  CurrencyPicker({this.marked, this.option});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.option == CurrencyOption.base ? 'Base currency' : 'Target currency' )),
      body: ListView.builder(
        itemCount: Currency.values.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.only(left: 65.0, right: 65.0),
            child: Column(
              children: [
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context, Currency.values[index].shortcut);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Currency.values[index].shortcut == this.marked ? Color(0xffaa4b6b) : Color(0xff3b8d99),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      height: 25.0,   
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Text('${Currency.values[index].shortcut}', style: TextStyle(color:Colors.white)),
                        ),
                      ),
                    )
                  )
                )
              ],
            ),
          );
        }
      ),
    );
  }
}