use std::io;
use rand::Rng;
use std::fs::File;
use std::cmp::Ordering;

fn main() {

    // example of if else and else if statements
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


    // no ternary operator in Rust, but you can use if expressions
    let result = if condition { x } else { y };


    // nested if statements
    if x > 0 {
        if y > 0 {
            println!("x and y are positive");
        }
    }
    

    // Example of if expression with a boolean condition
    let num = 10;

    // if num { ... } ❌ Error: expected `bool`, found `i32`

    if num != 0 {
        println!("Number is not zero");
    }

}
