#![allow(unused)]

enum Direction {
    North,
    South,
    East,
    West,
}

pub fn r#match() {
    // Example of a simple match statement
    let number = 3;

    match number {
        1 => println!("One!"),
        2 => println!("Two!"),
        3 => println!("Three!"),
        _ => println!("Something else!"),
    }

    // Example of matching with multiple patterns
    let day = "Sat";

    match day {
        "Sat" | "Sun" => println!("Weekend!"),
        "Mon" => println!("Back to work."),
        _ => println!("Just another day."),
    }

    // Example of match with destructuring and range patterns
    let age = 16;

    match age {
        0..=12 => println!("Child"),
        13..=19 => println!("Teenager"),
        _ => println!("Adult"),
    }

    // Example of match with enums
    let dir = Direction::North;

    match dir {
        Direction::North => println!("Up!"),
        Direction::South => println!("Down!"),
        Direction::East => println!("Right!"),
        Direction::West => println!("Left!"),
    }

    // Match and Binding with Option<T>
    // Using Option to handle cases where a value may or may not be present
    let name: Option<String> = Some(String::from("Rust"));

    match name {
        Some(n) => println!("Name is: {}", n),
        None => println!("No name provided."),
    }

    // Destructuring in Match
    enum Message {
        Hello(String),
        Quit,
    }

    let msg = Message::Hello(String::from("Rust"));

    match msg {
        Message::Hello(name) => println!("Hello, {}", name),
        Message::Quit => println!("Quit message"),
    }

    // Match with Guards (if in match)
    let number = 7;

    match number {
        x if x % 2 == 0 => println!("Even"),
        _ => println!("Odd"),
    }
}

// Match as an Expression (Return Values)
fn get_grade(score: u8) -> &'static str {
    match score {
        90..=100 => "A",
        80..=89 => "B",
        70..=79 => "C",
        _ => "F",
    }
}
