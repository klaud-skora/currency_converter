import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/nav_bar_bloc.dart';
import './first_page.dart';
import './second_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text( title ),
      ),
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          if (state is PageLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is FirstPageLoaded) {
            return FirstPage(state.base, state.target);
          }
          if (state is SecondPageLoaded) {
            return SecondPage();
          }
          return Container();
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (BuildContext context, BottomNavigationState state) {
            return BottomNavigationBar(
              currentIndex: BlocProvider.of<BottomNavigationBloc>(context).currentIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Color(0xffaa4b6b)),
                  title: Text('Currency converter'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.all_inclusive, color: Color(0xffaa4b6b)),
                  title: Text('Show currencies'),
                ),
              ],
              onTap: (index) => BlocProvider.of<BottomNavigationBloc>(context).add(PageTapped(index: index)),
            );
          }
      ),
    );
  }
}