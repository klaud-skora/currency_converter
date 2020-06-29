class Calculator {
  double multiplier;
  double value;

  Calculator({ multiplier, value });

  double currencyValue(double multiplier, double value) => multiplier * value;
}