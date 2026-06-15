// ===========================
// TRAITS EXAMPLES
// ===========================

use std::fmt::Display;

// 1. Basic Trait Definition
pub trait Drawable {
    fn draw(&self);
    
    // Default implementation
    fn describe(&self) {
        println!("This is a drawable object");
    }
    
    // Another default method
    fn area(&self) -> f64 {
        0.0 // Default area
    }
}

// 2. Trait with Associated Types
pub trait MyIterator {
    type Item;
    
    fn next(&mut self) -> Option<Self::Item>;
    
    // Default method using associated type
    fn collect_all(mut self) -> Vec<Self::Item>
    where 
        Self: Sized,
    {
        let mut items = Vec::new();
        while let Some(item) = self.next() {
            items.push(item);
        }
        items
    }
}

// 3. Trait with Generic Methods
pub trait Convertible<T> {
    fn convert(&self) -> T;
    fn try_convert(&self) -> Result<T, String> {
        Ok(self.convert())
    }
}

// 4. Trait with Self Return Type
pub trait Cloneable {
    fn clone_self(&self) -> Self;
}

// 5. Marker Trait (no methods)
pub trait Printable {}

// 6. Trait with Constraints on Associated Types
pub trait Collect<T> {
    type Output: IntoIterator<Item = T>;
    
    fn collect(self) -> Self::Output;
}

// 7. Animal trait hierarchy
pub trait Animal {
    fn name(&self) -> &str;
    fn sound(&self) -> &str;
    
    fn make_sound(&self) {
        println!("{} says {}", self.name(), self.sound());
    }
}

pub trait Mammal: Animal {
    fn fur_color(&self) -> &str;
    
    fn describe_mammal(&self) {
        println!("{} is a mammal with {} fur", self.name(), self.fur_color());
    }
}

// 8. Structs implementing traits
#[derive(Debug, Clone)]
pub struct Circle {
    pub radius: f64,
}

#[derive(Debug, Clone)]
pub struct Rectangle {
    pub width: f64,
    pub height: f64,
}

#[derive(Debug)]
pub struct Dog {
    pub name: String,
    pub fur_color: String,
}

#[derive(Debug)]
pub struct Cat {
    pub name: String,
    pub fur_color: String,
}

// Implementing Drawable for shapes
impl Drawable for Circle {
    fn draw(&self) {
        println!("Drawing a circle with radius {}", self.radius);
    }
    
    fn area(&self) -> f64 {
        std::f64::consts::PI * self.radius * self.radius
    }
}

impl Drawable for Rectangle {
    fn draw(&self) {
        println!("Drawing a rectangle {}x{}", self.width, self.height);
    }
    
    fn area(&self) -> f64 {
        self.width * self.height
    }
}

// Implementing Animal and Mammal for pets
impl Animal for Dog {
    fn name(&self) -> &str {
        &self.name
    }
    
    fn sound(&self) -> &str {
        "Woof!"
    }
}

impl Mammal for Dog {
    fn fur_color(&self) -> &str {
        &self.fur_color
    }
}

impl Animal for Cat {
    fn name(&self) -> &str {
        &self.name
    }
    
    fn sound(&self) -> &str {
        "Meow!"
    }
}

impl Mammal for Cat {
    fn fur_color(&self) -> &str {
        &self.fur_color
    }
}

// Implementing Cloneable
impl Cloneable for Circle {
    fn clone_self(&self) -> Self {
        Circle { radius: self.radius }
    }
}

impl Cloneable for Rectangle {
    fn clone_self(&self) -> Self {
        Rectangle { 
            width: self.width, 
            height: self.height 
        }
    }
}

// Implementing marker trait
impl Printable for Circle {}
impl Printable for Rectangle {}
impl Printable for Dog {}
impl Printable for Cat {}

// 9. Generic implementations
impl<T: Display> Convertible<String> for T {
    fn convert(&self) -> String {
        format!("{}", self)
    }
}

// 10. Custom iterator implementation
pub struct Counter {
    current: u32,
    max: u32,
}

impl Counter {
    pub fn new(max: u32) -> Counter {
        Counter { current: 0, max }
    }
}

impl MyIterator for Counter {
    type Item = u32;
    
    fn next(&mut self) -> Option<Self::Item> {
        if self.current < self.max {
            let current = self.current;
            self.current += 1;
            Some(current)
        } else {
            None
        }
    }
}

// 11. Trait bounds in function parameters
pub fn draw_shape(shape: &dyn Drawable) {
    shape.draw();
    shape.describe();
    println!("Area: {:.2}", shape.area());
}

// 12. Generic function with trait bounds
pub fn draw_multiple_shapes<T: Drawable>(shapes: &[T]) {
    for shape in shapes {
        shape.draw();
    }
}

// 13. Function with multiple trait bounds
pub fn print_and_clone<T>(item: &T) -> T
where 
    T: Display + Clone,
{
    println!("Item: {}", item);
    item.clone()
}

// 14. Function using trait objects
pub fn make_animals_sound(animals: &[Box<dyn Animal>]) {
    for animal in animals {
        animal.make_sound();
    }
}

// 15. Function with associated types
pub fn process_iterator<I>(mut iter: I) -> Vec<I::Item>
where
    I: MyIterator,
{
    iter.collect_all()
}

// 16. Trait with generics and where clause
pub trait Storage<T> 
where 
    T: Clone,
{
    fn store(&mut self, item: T);
    fn retrieve(&self) -> Option<&T>;
    fn remove(&mut self) -> Option<T>;
}

// 17. Simple storage implementation
#[derive(Debug)]
pub struct SimpleStorage<T> {
    item: Option<T>,
}

impl<T> SimpleStorage<T> {
    pub fn new() -> Self {
        SimpleStorage { item: None }
    }
}

impl<T: Clone> Storage<T> for SimpleStorage<T> {
    fn store(&mut self, item: T) {
        self.item = Some(item);
    }
    
    fn retrieve(&self) -> Option<&T> {
        self.item.as_ref()
    }
    
    fn remove(&mut self) -> Option<T> {
        self.item.take()
    }
}

// 18. Trait for mathematical operations
pub trait Addable<Rhs = Self> {
    type Output;
    
    fn add(self, rhs: Rhs) -> Self::Output;
}

// 19. Point with mathematical operations
#[derive(Debug, Clone, PartialEq)]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

impl Point {
    pub fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }
}

impl Addable for Point {
    type Output = Point;
    
    fn add(self, rhs: Point) -> Self::Output {
        Point {
            x: self.x + rhs.x,
            y: self.y + rhs.y,
        }
    }
}

// 20. Builder pattern trait
pub trait Builder {
    type Output;
    
    fn build(self) -> Self::Output;
}

pub struct PersonBuilder {
    name: Option<String>,
    age: Option<u32>,
    email: Option<String>,
}

#[derive(Debug)]
pub struct Person {
    pub name: String,
    pub age: u32,
    pub email: String,
}

impl PersonBuilder {
    pub fn new() -> Self {
        PersonBuilder {
            name: None,
            age: None,
            email: None,
        }
    }
    
    pub fn name(mut self, name: String) -> Self {
        self.name = Some(name);
        self
    }
    
    pub fn age(mut self, age: u32) -> Self {
        self.age = Some(age);
        self
    }
    
    pub fn email(mut self, email: String) -> Self {
        self.email = Some(email);
        self
    }
}

impl Builder for PersonBuilder {
    type Output = Result<Person, String>;
    
    fn build(self) -> Self::Output {
        let name = self.name.ok_or("Name is required")?;
        let age = self.age.ok_or("Age is required")?;
        let email = self.email.ok_or("Email is required")?;
        
        Ok(Person { name, age, email })
    }
}

// ===========================
// MAIN FUNCTION WITH EXAMPLES
// ===========================

pub fn run_traits_examples() {
    println!("=== TRAITS EXAMPLES ===\n");
    
    // Basic drawable objects
    let circle = Circle { radius: 5.0 };
    let rectangle = Rectangle { width: 3.0, height: 4.0 };
    
    draw_shape(&circle);
    draw_shape(&rectangle);
    
    println!();
    
    let shapes = vec![
        Circle { radius: 1.0 },
        Circle { radius: 2.0 },
    ];
    draw_multiple_shapes(&shapes);
    
    println!();
    
    // Animal examples
    let dog = Dog {
        name: "Buddy".to_string(),
        fur_color: "brown".to_string(),
    };
    
    let cat = Cat {
        name: "Whiskers".to_string(),
        fur_color: "gray".to_string(),
    };
    
    dog.make_sound();
    cat.make_sound();
    
    dog.describe_mammal();
    cat.describe_mammal();
    
    println!();
    
    // Trait objects
    let animals: Vec<Box<dyn Animal>> = vec![
        Box::new(Dog {
            name: "Rex".to_string(),
            fur_color: "black".to_string(),
        }),
        Box::new(Cat {
            name: "Mittens".to_string(),
            fur_color: "white".to_string(),
        }),
    ];
    
    make_animals_sound(&animals);
    
    println!();
    
    // Cloneable trait
    let original_circle = Circle { radius: 10.0 };
    let cloned_circle = original_circle.clone_self();
    println!("Original circle: {:?}", original_circle);
    println!("Cloned circle: {:?}", cloned_circle);
    
    // Iterator trait
    let mut counter = Counter::new(5);
    println!("Counter values:");
    while let Some(value) = counter.next() {
        println!("  {}", value);
    }
    
    // Collect all values
    let counter2 = Counter::new(3);
    let all_values = process_iterator(counter2);
    println!("All counter values: {:?}", all_values);
    
    println!();
    
    // Convertible trait
    let number = 42;
    let number_string: String = number.convert();
    println!("Number {} converted to string: '{}'", number, number_string);
    
    let pi = 3.14159;
    let pi_string: String = pi.convert();
    println!("Pi {} converted to string: '{}'", pi, pi_string);
    
    // Print and clone
    let rect = Rectangle { width: 5.0, height: 10.0 };
    let cloned_rect = print_and_clone(&rect);
    println!("Cloned rectangle: {:?}", cloned_rect);
    
    println!();
    
    // Storage trait
    let mut storage = SimpleStorage::new();
    
    storage.store("Hello, World!".to_string());
    if let Some(item) = storage.retrieve() {
        println!("Retrieved from storage: {}", item);
    }
    
    let removed = storage.remove();
    println!("Removed from storage: {:?}", removed);
    
    if storage.retrieve().is_none() {
        println!("Storage is now empty");
    }
    
    println!();
    
    // Mathematical operations
    let point1 = Point::new(1.0, 2.0);
    let point2 = Point::new(3.0, 4.0);
    let sum = point1.clone().add(point2);
    
    println!("Point 1: {:?}", point1);
    println!("Point 2: {:?}", point2);
    println!("Sum: {:?}", sum);
    
    println!();
    
    // Builder pattern
    let person_result = PersonBuilder::new()
        .name("Alice Johnson".to_string())
        .age(30)
        .email("alice@example.com".to_string())
        .build();
    
    match person_result {
        Ok(person) => println!("Built person: {:?}", person),
        Err(e) => println!("Failed to build person: {}", e),
    }
    
    // Builder with missing field
    let incomplete_person_result = PersonBuilder::new()
        .name("Bob".to_string())
        .age(25)
        // Missing email
        .build();
    
    match incomplete_person_result {
        Ok(person) => println!("Built person: {:?}", person),
        Err(e) => println!("Failed to build person: {}", e),
    }
}