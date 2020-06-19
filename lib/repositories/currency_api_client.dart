import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';
import '../models/currency.dart';

class CurrencyApiClient {
  static const baseUrl = 'https://api.exchangeratesapi.io/latest';
  final http.Client httpClient;

  CurrencyApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Currency> fetchCurrencies() async {

    final currenciesResponse = await this.httpClient.get(baseUrl);

    if (currenciesResponse.statusCode != 200) {
      throw Exception('error getting weather for location');
    }

    final currenciesJson = jsonDecode(currenciesResponse.body);
    return Currency.fromJson(currenciesJson);
  }
}



