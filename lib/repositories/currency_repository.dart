import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyRepository {
  String _base = 'PLN';
  List _data = [];

  Future<void> fetchData(base) async {
    
    var response = await http.get(
      Uri.encodeFull('https://api.exchangeratesapi.io/latest?base=$base'),
      headers: {"Accept": "application/json"}
    );
    // print(response.body);
    var convertDataToJson = json.decode(response.body);
    print(convertDataToJson['base']);
    if ( convertDataToJson != null ) {
      if ( convertDataToJson['base'] != 'EUR' ) _base = convertDataToJson['base'];
      convertDataToJson['rates'].forEach((final String key, final value) {
        _data.add({ 'currency': key, 'value': value });
      });
    }
    
  }

  String get base => _base;
  List get data => _data;
}