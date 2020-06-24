import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyRepository {
  List _data = [];

  Future<void> fetchData() async {
    
    var response = await http.get(
      Uri.encodeFull('https://api.exchangeratesapi.io/latest'),
      headers: {"Accept": "application/json"}
    );
    print(response.body);
    var convertDataToJson = json.decode(response.body);
    var res = convertDataToJson['rates'];

    print(res);
    res.forEach((final String key, final value) {
      _data.add({ 'currency': key, 'value': value });
    });
    
  }

  List get data => _data;
}