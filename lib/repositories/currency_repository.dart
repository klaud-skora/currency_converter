import 'package:http/http.dart' as http;
import 'dart:convert';
import './shared_data.dart';

class CurrencyRepository {
  
  SharedData sharedData = SharedData();
  List _data;
  List _shared = [];

  Future<void> fetchData(base) async {
    try {
      var response = await http.get(
        Uri.encodeFull('https://api.exchangeratesapi.io/latest?base=$base'),
        headers: {"Accept": "application/json"}
      );
      // print(response.body);
      var convertDataToJson = json.decode(response.body);
      
      if ( convertDataToJson != null ) {

        sharedData.save(base, response.body);

        listReset();
        convertDataToJson['rates'].forEach((final String key, final value) {
          _data.add({ 'currency': key, 'value': value });
        });
      }
    } catch(err) {
      _data = data;
    }
    
  }

  showData(base) async {
    var res = await sharedData.read(base);
    var convertDataFromJson = json.decode(res);
    print(convertDataFromJson);
    
  }
  

  List get data => _data;
  List get shared => _shared;
  void listReset() => _data = [];
}
