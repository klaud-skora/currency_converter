import 'package:flutter/material.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}