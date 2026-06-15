#![allow(unused)]
use std::io;
use rand::Rng;
use std::fs::File;
use std::cmp::Ordering;

pub fn conditionals() {
    // Example of if, else if, and else statements
    let score = 85;

    if score >= 90 {
        println!("Grade: A");
    } else if score >= 80 {
        println!("Grade: B");
    } else if score >= 70 {
        println!("Grade: C");
    } else {
        println!("Grade: F");
    }

    // Example of if let expression statement
    let is_logged_in = true;

    let message = if is_logged_in {
        "Welcome back!"
    } else {
        "Please log in"
    };

    println!("{}", message);

    // No ternary operator in Rust, but we can use `if` as an expression
    let x: u32 = 10;
    let condition = true; 
    let result = if condition { x } else { 0 }; // Both arms must return the same type

    println!("Result is: {}", result);

    // Nested if statements
    let y = 5; // define y for comparison
    if x > 0 {
        if y > 0 {
            println!("x and y are positive");
        }
    }

    // Example of if expression with a boolean condition
    let num = 10;

    if num != 0 {
        println!("Number is not zero");
    }
}
