// Shapes with inheritance and polymorphism
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 27_shapes_with_inheritance_and_polymorphism.dart

import 'dart:math';

abstract class Shape {
  String get name;
  double get area;
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  String get name => 'Circle';
  @override
  double get area => pi * radius * radius;
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);

  @override
  String get name => 'Rectangle';
  @override
  double get area => width * height;
}

void main() {
  List<Shape> shapes = [Circle(2), Rectangle(3, 4)];
  for (var shape in shapes) {
    print('${shape.name}: ${shape.area.toStringAsFixed(2)}');
  }
}
