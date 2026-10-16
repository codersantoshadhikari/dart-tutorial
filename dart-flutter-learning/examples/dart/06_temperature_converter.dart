// Temperature converter
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 06_temperature_converter.dart

void main() {
  var celsius = 25;
  var fahrenheit = celsius * 9 / 5 + 32;
  print('$celsius°C = ${fahrenheit.toStringAsFixed(1)}°F');

  var bodyTemp = 98.6;
  var inCelsius = (bodyTemp - 32) * 5 / 9;
  print('$bodyTemp°F = ${inCelsius.toStringAsFixed(1)}°C');
}
