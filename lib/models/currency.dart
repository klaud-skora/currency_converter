import 'package:equatable/equatable.dart';

enum CurrencyShortcut {
  pln,
  dolar,
}

class Currency extends Equatable {
  final CurrencyShortcut shortcut;
  final String base;
  final Object rates;

  const Currency({
    this.shortcut,
    this.base,
    this.rates,
  });

  @override
  List<Object> get props => [
    shortcut,
    base,
    rates,
  ];

  static Currency fromJson(dynamic json) {
    final consolidatedCurrency = json['consolidated_currency'][0];
    return Currency(
      shortcut: _mapStringToCurrencyShortcut(
          consolidatedCurrency['base']),
      rates: consolidatedCurrency['rates'] as Object,
    );
  }

  static CurrencyShortcut _mapStringToCurrencyShortcut(String input) {
    CurrencyShortcut state;
    switch(input) {
      case 'PLN':
        state = CurrencyShortcut.pln;
        break;
      case 'US':
        state = CurrencyShortcut.dolar;
        break;
    }
    return state;
  }
  
}
