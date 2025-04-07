// Static Members Example
class MathOperations {
  static double pi = 3.14;

  // Static method to calculate circle area
  static double calculateCircleArea(double radius) {
    return pi * radius * radius;
  }
}

// Function to demonstrate Static Members
void demonstrateStaticMembers() {
  print("Value of Pi: ${MathOperations.pi}");
  print(
      "Area of Circle with radius 5: ${MathOperations.calculateCircleArea(5)}");
}

void main() {
  demonstrateStaticMembers();
}
