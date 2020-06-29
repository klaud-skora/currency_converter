class Calculator {
  double multiplier;
  double value;

  Calculator({ multiplier, value });

  double currencyValue(double multiplier, double value) => (multiplier * value * 1000).round() / 1000;
}