import 'package:http/http.dart' as http;
import 'dart:convert';
import './shared_pref.dart';

class CurrencyRepository {
  
  SharedPref sharedPref = SharedPref();
  List _data;
  List _sharedData = [];

  Future<void> fetchData(base) async {
    listReset();
    try {
      var response = await http.get(
        Uri.encodeFull('https://api.exchangeratesapi.io/latest?base=$base'),
        headers: {"Accept": "application/json"}
      );
      // print(response.body);
      var convertDataToJson = json.decode(response.body);
      
      if ( convertDataToJson != null ) {

        sharedPref.save(base, response.body);
        convertDataToJson['rates'].forEach((final String key, final value) {
          _data.add({ 'currency': key, 'value': value });
        });
      }
    } catch(err) {
      _data = data;
    }
    
  }

  Future<void> showData(base) async {
    prefReset();
    var res = await sharedPref.read(base);
    if(res != null) {
      var convertDataFromJson = json.decode(res);
      convertDataFromJson['rates'].forEach((final String key, final value) {
        _sharedData.add({ 'currency': key, 'value': value });
      });
    }
  }

  List get data => _data;
  List get sharedData => _sharedData;
  void listReset() => _data = [];
  void prefReset() => _sharedData = [];
}
