import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyRepository {
  
  List _data;

  Future<void> fetchData(base) async {
    try {
      var response = await http.get(
        Uri.encodeFull('https://api.exchangeratesapi.io/latest?base=$base'),
        headers: {"Accept": "application/json"}
      );
      // print(response.body);
      var convertDataToJson = json.decode(response.body);
      
      if ( convertDataToJson != null ) {
        listReset();
        convertDataToJson['rates'].forEach((final String key, final value) {
          _data.add({ 'currency': key, 'value': value });
        });
      }
    } catch(err) {
      _data = data;
    }
    
  }
  
  List get data => _data;
  void listReset() => _data = [];
}