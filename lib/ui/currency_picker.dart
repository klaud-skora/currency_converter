import 'package:flutter/material.dart';
import '../models/currency.dart';

class CurrencyPicker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: Currency.values.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.only(top: 40.0, bottom: 20.0, left: 25.0, right: 25.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: FlatButton(
                      onPressed: () {},
                      child: Center(
                        child: Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(Radius.circular(50.0)),
                          ),
                          height: 50.0,   
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text('${Currency.values[index].sthortcut}'),
                            ),
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