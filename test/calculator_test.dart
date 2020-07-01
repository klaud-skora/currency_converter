import 'package:test/test.dart';
import '../lib/logic/calculator.dart';

void main() {

  Calculator calcTest = Calculator();
  test('test good result', () {
    var result = calcTest.currencyValue(2.0, 4.444);
    expect(result, 8.888);
  });

  test('test null multiplier', () {
    var result = calcTest.currencyValue(null, 4.444);
    expect(result, null);
  });

  test('test null value', () {
    var result = calcTest.currencyValue(2.0, null);
    expect(result, null);
  });

  test('test no params', () {
    var result = calcTest.currencyValue(null, null);
    expect(result, null);
  });

}