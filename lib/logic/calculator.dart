class Calculator {
  double multiplier;
  double value;

  Calculator({ multiplier, value });
  
  double currencyValue(double multiplier, double value){

    return (multiplier * value * 1000).round() / 1000;
  }
}