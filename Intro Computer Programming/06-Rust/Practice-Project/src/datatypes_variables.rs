#![allow(unused)]
use std::io;
use rand::Rng;
use std::fs::File;
use std::cmp::Ordering;

pub fn datatypes() {
    const GREETING: &str = "Nice to meet you,"; 
    let name: &str = "Alice"; // Example slice variable
    println!("{} {}", GREETING, name);

    // Mutable variable
    let mut age = 25;
    age = 26; // Updated value
    println!("Age: {}", age);

    const PI: f64 = 3.14159;
    println!("Constant PI: {}", PI);

    let salary: u32 = 100_000;
    let bonus: f32 = 5000.50;
    println!("Salary: {}, Bonus: {}", salary, bonus);

    const GRADUATED: bool = true;
    let is_employed: bool = false;
    println!("Graduated: {}, Employed: {}", GRADUATED, is_employed);

    let x = 10;
    let mut y = 20;
    println!("Original x: {}, y: {}", x, y);

    // Shadowing
    let x = 5;
    let x = x + 1;
    let x = "blue";
    println!("Shadowed x: {}", x);

    // Arrays
    let scores: [u32; 5] = [90, 85, 78, 92, 88];
    println!("Scores array: {:?}", scores);

    // Vectors
    let mut numbers: Vec<i32> = vec![1, 2, 3, 4, 5];
    numbers.push(6); // Add an element
    println!("Numbers vector: {:?}", numbers);

    // Struct
    struct Person {
        name: String,
        age: u32,
    }

    let person = Person {
        name: String::from("Alice"),
        age: 30,
    };
    println!("Person => Name: {}, Age: {}", person.name, person.age);

    // Tuple
    const MAX_SCORE: (&str, u32, bool, f64) = ("Alice", 100, true, 3.14);
    println!(
        "Tuple => Name: {}, Score: {}, Passed: {}, GPA: {}",
        MAX_SCORE.0, MAX_SCORE.1, MAX_SCORE.2, MAX_SCORE.3
    );

    // Enum
    enum Direction {
        Up,
        Down,
        Left,
        Right,
    }

    let direction = Direction::Up;
    match direction {
        Direction::Up => println!("Going Up"),
        Direction::Down => println!("Going Down"),
        Direction::Left => println!("Going Left"),
        Direction::Right => println!("Going Right"),
    }

    // Random number
    let random_number: u32 = rand::thread_rng().gen_range(1..101);
    println!("Random number generated: {}", random_number);
}
