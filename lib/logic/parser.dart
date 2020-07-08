double parser(String value) {
  if (value == null ) return null;
  var result = double.tryParse(value);  
  return result;
}