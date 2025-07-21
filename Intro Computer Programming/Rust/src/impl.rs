// ===========================
// IMPLEMENTATION EXAMPLES
// ===========================

use std::fmt::Display;

// 1. Basic Struct with Implementation
#[derive(Debug, Clone)]
pub struct Person {
    pub name: String,
    pub age: u32,
    pub email: String,
}

impl Person {
    // Associated function (constructor)
    pub fn new(name: String, age: u32, email: String) -> Person {
        Person { name, age, email }
    }
    
    // Method that borrows self immutably
    pub fn introduce(&self) {
        println!("Hi, I'm {} and I'm {} years old", self.name, self.age);
    }
    
    // Method that borrows self mutably
    pub fn have_birthday(&mut self) {
        self.age += 1;
        println!("{} is now {} years old!", self.name, self.age);
    }
    
    // Method that takes ownership of self
    pub fn into_greeting(self) -> String {
        format!("Hello from {}!", self.name)
    }
    
    // Associated function (not a method)
    pub fn default_person() -> Person {
        Person {
            name: String::from("John Doe"),
            age: 0,
            email: String::from("john@example.com"),
        }
    }
}

// 2. Multiple impl blocks for the same type
impl Person {
    pub fn is_adult(&self) -> bool {
        self.age >= 18
    }
    
    pub fn update_email(&mut self, new_email: String) {
        self.email = new_email;
    }
}

// 3. Implementation with generic types
#[derive(Debug)]
pub struct Container<T> {
    pub items: Vec<T>,
}

impl<T> Container<T> {
    pub fn new() -> Self {
        Container { items: Vec::new() }
    }
    
    pub fn add(&mut self, item: T) {
        self.items.push(item);
    }
    
    pub fn len(&self) -> usize {
        self.items.len()
    }
    
    pub fn is_empty(&self) -> bool {
        self.items.is_empty()
    }
}

// 4. Implementation with trait bounds
impl<T: Display> Container<T> {
    pub fn print_all(&self) {
        for (i, item) in self.items.iter().enumerate() {
            println!("Item {}: {}", i, item);
        }
    }
}

// 5. Implementation with Clone trait bound
impl<T: Clone> Container<T> {
    pub fn duplicate_all(&mut self) {
        let cloned_items: Vec<T> = self.items.clone();
        self.items.extend(cloned_items);
    }
}

// 6. Rectangle example with area calculation
#[derive(Debug)]
pub struct Rectangle {
    pub width: f64,
    pub height: f64,
}

impl Rectangle {
    pub fn new(width: f64, height: f64) -> Rectangle {
        Rectangle { width, height }
    }
    
    pub fn area(&self) -> f64 {
        self.width * self.height
    }
    
    pub fn perimeter(&self) -> f64 {
        2.0 * (self.width + self.height)
    }
    
    pub fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
    
    pub fn square(size: f64) -> Rectangle {
        Rectangle {
            width: size,
            height: size,
        }
    }
}

// 7. Enum with implementations
#[derive(Debug)]
pub enum Temperature {
    Celsius(f64),
    Fahrenheit(f64),
    Kelvin(f64),
}

impl Temperature {
    pub fn to_celsius(&self) -> f64 {
        match self {
            Temperature::Celsius(c) => *c,
            Temperature::Fahrenheit(f) => (f - 32.0) * 5.0 / 9.0,
            Temperature::Kelvin(k) => k - 273.15,
        }
    }
    
    pub fn to_fahrenheit(&self) -> f64 {
        match self {
            Temperature::Celsius(c) => c * 9.0 / 5.0 + 32.0,
            Temperature::Fahrenheit(f) => *f,
            Temperature::Kelvin(k) => (k - 273.15) * 9.0 / 5.0 + 32.0,
        }
    }
    
    pub fn is_freezing(&self) -> bool {
        self.to_celsius() <= 0.0
    }
}

// 8. Implementation with constants
impl Rectangle {
    pub const MAX_AREA: f64 = 1000.0;
    
    pub fn is_large(&self) -> bool {
        self.area() > Self::MAX_AREA
    }
}

// Main function to demonstrate implementations
pub fn run_impl_examples() {
    println!("=== IMPLEMENTATION EXAMPLES ===\n");
    
    // Person examples
    let mut person = Person::new(
        String::from("Alice"), 
        25, 
        String::from("alice@example.com")
    );
    
    person.introduce();
    person.have_birthday();
    println!("Is adult: {}", person.is_adult());
    person.update_email(String::from("alice.new@example.com"));
    println!("Updated person: {:?}", person);
    
    let default_person = Person::default_person();
    println!("Default person: {:?}", default_person);
    
    // Container examples
    let mut number_container = Container::new();
    number_container.add(1);
    number_container.add(2);
    number_container.add(3);
    
    println!("Container length: {}", number_container.len());
    number_container.print_all();
    number_container.duplicate_all();
    println!("After duplication: {:?}", number_container);
    
    // Rectangle examples
    let rect1 = Rectangle::new(10.0, 5.0);
    let rect2 = Rectangle::new(3.0, 4.0);
    let square = Rectangle::square(5.0);
    
    println!("Rectangle 1 area: {}", rect1.area());
    println!("Rectangle 1 perimeter: {}", rect1.perimeter());
    println!("Can rect1 hold rect2? {}", rect1.can_hold(&rect2));
    println!("Is rect1 large? {}", rect1.is_large());
    println!("Square: {:?}", square);
    
    // Temperature examples
    let temp_c = Temperature::Celsius(25.0);
    let temp_f = Temperature::Fahrenheit(77.0);
    let temp_k = Temperature::Kelvin(298.15);
    
    println!("25°C in Fahrenheit: {:.1}°F", temp_c.to_fahrenheit());
    println!("77°F in Celsius: {:.1}°C", temp_f.to_celsius());
    println!("298.15K in Celsius: {:.1}°C", temp_k.to_celsius());
    println!("Is 25°C freezing? {}", temp_c.is_freezing());
    
    let freezing = Temperature::Celsius(-5.0);
    println!("Is -5°C freezing? {}", freezing.is_freezing());
}