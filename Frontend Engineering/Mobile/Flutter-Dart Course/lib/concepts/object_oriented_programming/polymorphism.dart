// Polymorphism Example
class AnimalPolymorphic {
  void sound() {
    print("The animal makes a sound");
  }
}

class Cat extends AnimalPolymorphic {
  @override
  void sound() {
    print("The cat meows");
  }
}

// Function to demonstrate Polymorphism
void demonstratePolymorphism() {
  AnimalPolymorphic animal = AnimalPolymorphic();
  animal.sound(); // Output: The animal makes a sound

  AnimalPolymorphic cat = Cat();
  cat.sound(); // Output: The cat meows (polymorphism)
}

void main() {
  demonstratePolymorphism();
}
