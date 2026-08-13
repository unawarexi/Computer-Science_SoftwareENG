// Mixin Example
mixin CanFly {
  void fly() {
    print("Flying...");
  }
}

mixin CanSwim {
  void swim() {
    print("Swimming...");
  }
}

class Bird with CanFly, CanSwim {}

// Function to demonstrate Mixins
void demonstrateMixins() {
  Bird bird = Bird();
  bird.fly(); // Output: Flying...
  bird.swim(); // Output: Swimming...
}

void main() {
  demonstrateMixins();
}
