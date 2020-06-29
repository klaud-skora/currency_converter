import 'package:test/test.dart';
import '../lib/logic/parser.dart';

void main() {
  test('test good input int' , () {
    var result = parser('18');
    expect(result, 18);
  });

  test('test good input double' , () {
    var result = parser('4.5');
    expect(result, 4.5);
  });

  test('test null input' , () {
    var result = parser('');
    expect(result, null);
  });

  test('test text value' , () {
    var result = parser('abc');
    expect(result, null);
  });

  test('test mixed number & text value' , () {
    var result = parser('18o');
    expect(result, null);
  });
}