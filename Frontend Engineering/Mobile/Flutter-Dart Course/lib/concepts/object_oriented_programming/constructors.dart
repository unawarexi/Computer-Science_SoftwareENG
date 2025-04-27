// Constructors Example
class Car {
  String brand;
  int year;

  // Default constructor
  Car(this.brand, this.year);

  // Named constructor
  Car.fromBrand(this.brand) : year = 2020;

  // Factory constructor
  factory Car.defaultCar() {
    return Car('Toyota', 2022);
  }
}

// Function to demonstrate Constructors
void demonstrateCar() {
  Car car1 = Car('BMW', 2021);
  Car car2 = Car.fromBrand('Honda');
  Car car3 = Car.defaultCar();

  print("Car 1: ${car1.brand}, Year: ${car1.year}");
  print("Car 2: ${car2.brand}, Year: ${car2.year}");
  print("Car 3: ${car3.brand}, Year: ${car3.year}");
}

void main() {
  demonstrateCar();
}
