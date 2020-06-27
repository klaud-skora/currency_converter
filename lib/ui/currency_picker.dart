import 'package:flutter/material.dart';
import '../models/currency.dart';

import './first_page.dart'; // do zmiany import CurrencyOption

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
            child: Center(
              child: Column(
                children: [
                  Container(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context, option);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Currency.values[index].sthortcut == this.marked ? Color(0xffaa4b6b) : Color(0xff3b8d99),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        height: 25.0,   
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text('${Currency.values[index].sthortcut}', style: TextStyle(color:Colors.white)),
                          ),
                        ),
                      )
                    )
                  )
                ],
              )
            )
          );
        }
      ),
    );
  }
}