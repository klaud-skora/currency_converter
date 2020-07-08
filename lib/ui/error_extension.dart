import '../models/currency.dart';

extension ErrorExtension on Error {
  static final texts = {
    Error.none: '',
    Error.input: 'Input is wrong',
  };

  String get text => texts[this];
}