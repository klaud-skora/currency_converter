import 'package:flutter/material.dart';
import './converter_page.dart';

class HomePage extends StatelessWidget {
  final String title;
  HomePage({ this.title });
  void _onItemTapped(int index) {
  print('\$');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text( title )),
      body: 4 == 4 ? // converter view
      
      ConverterPage() : 
      Container(
        child: Text('Currency'),
      ),
      bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          title: Text('Converter'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text(''),
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    ),
    );
  }
}