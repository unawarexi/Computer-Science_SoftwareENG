// Abstract class Example
abstract class Shape {
  double area(); // Abstract method
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);

  @override
  double area() {
    return 3.14 * radius * radius;
  }
}

// Function to demonstrate Abstraction
void demonstrateAbstraction() {
  Circle circle = Circle(5);
  print("Area of Circle: ${circle.area()}");
}

void main() {
  demonstrateAbstraction();
}
