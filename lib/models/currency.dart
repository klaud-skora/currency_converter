enum Currency {
  EUR,
  CAD,
  HKD,
  ISK,
  PHP,
  DKK,
  HUF,
  CZK,
  AUD,
  RON,
  SEK,
  IDR,
  INR,
  BRL,
  RUB,  
  HRK,
  JPY,
  THB,
  CHF,
  SGD,
  PLN,
  BGN,
  TRY,
  CNY,
  NOK,
  NZD,
  ZAR,
  USD,
  MXN,
  ILS,
  GBP,
  KRW,
  MYR,
}

extension CurrencyExtension on Currency {

  static final shortcuts = {
    Currency.EUR: 'EUR',
    Currency.CAD: 'CAD',
    Currency.HKD: 'HKD',
    Currency.ISK: 'ISK',
    Currency.PHP: 'PHP',
    Currency.DKK: 'DKK',
    Currency.HUF: 'HUF',
    Currency.CZK: 'CZK',
    Currency.AUD: 'AUD',
    Currency.RON: 'RON',
    Currency.SEK: 'SEK',
    Currency.IDR: 'IDR',
    Currency.INR: 'INR',
    Currency.BRL: 'BRL',
    Currency.RUB: 'RUB',
    Currency.HRK: 'HRK',
    Currency.JPY: 'JPY',
    Currency.THB: 'THB',
    Currency.CHF: 'CHF',
    Currency.SGD: 'SGD',
    Currency.PLN: 'PLN',
    Currency.BGN: 'BGN',
    Currency.TRY: 'TRY',
    Currency.CNY: 'CNY',
    Currency.NOK: 'NOK',
    Currency.NZD: 'NZD',
    Currency.ZAR: 'ZAR',
    Currency.USD: 'USD',
    Currency.MXN: 'MXN',
    Currency.ILS: 'ILS',
    Currency.GBP: 'GBP',
    Currency.KRW: 'KRW',
    Currency.MYR: 'MYR',
  };
  
  String get shortcut => shortcuts[this];

}

enum CurrencyOption { base, target }

enum Status { noData, oldData, newData }