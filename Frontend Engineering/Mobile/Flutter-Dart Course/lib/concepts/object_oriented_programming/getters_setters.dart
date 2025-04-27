// Getters and Setters Example
class Rectangle {
  double width, height;

  Rectangle(this.width, this.height);

  // Getter for area
  double get area => width * height;

  // Setter for width
  set widthValue(double value) {
    width = value < 0 ? 0 : value; // Prevent negative width
  }
}

// Function to demonstrate Getters and Setters
void demonstrateGettersAndSetters() {
  Rectangle rectangle = Rectangle(10, 5);
  print("Area of Rectangle: ${rectangle.area}");
  rectangle.widthValue = -5; // Trying to set negative width
  print("Updated Width: ${rectangle.width}");
  print("Area of Rectangle after update: ${rectangle.area}");
}

void main() {
  demonstrateGettersAndSetters();
}
