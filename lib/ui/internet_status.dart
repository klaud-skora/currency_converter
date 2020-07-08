import 'package:flutter/material.dart';
import '../models/currency.dart';
import './status_extension.dart';

class InternetStatus extends StatelessWidget {
  final Status status;
  InternetStatus({this.status});

  Widget build(BuildContext context) {
    if (status == Status.noData) return Text('${Status.noData.text}', style: TextStyle(color: Colors.red));
    else if (status == Status.oldData) return Text('${Status.oldData.text}', style: TextStyle(color: Colors.orange));
    else if (status == Status.newData) return Text('${Status.newData.text}', style: TextStyle(color: Colors.green));
    else return Text('${Status.defaultStatus.text}');
  }
}