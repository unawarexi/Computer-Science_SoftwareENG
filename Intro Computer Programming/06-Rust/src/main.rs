#![allow(unused)]
use rand::Rng;
use std::cmp::Ordering;
use std::fs::File;
use std::io;

// Existing modules
mod conditionals;
mod datatypes_variables;
mod functions;
mod hashmaps;
mod loops;
mod r#match;
mod operators;

// New advanced modules
mod r#impl;
mod generics;
mod traits;
mod lifetimes;

// nested modules
mod projects;

// Existing imports
use conditionals::conditionals;
use datatypes_variables::datatypes;
use functions::add_numbers;
use hashmaps::hashmaps;
use loops::r#main as loop_main;
use operators::operators;
use r#match::r#match;

// New imports
use r#impl::run_impl_examples;
use generics::run_generics_examples;
use traits::run_traits_examples;
use lifetimes::run_lifetimes_examples;

// Importing the projects module
use projects::task1;

fn main() {
    println!("Hello, world!");
    whats_your_name();
    
    println!("===================================Learning Functions====================================");
    add_numbers(5, 10);

    println!("===================================Learning Loops====================================");
    loop_main();

    println!("===================================Learning Data Types and Variables====================================");
    datatypes();

    println!("===================================Learning Conditionals====================================");
    conditionals();

    println!("===================================Learning Operators====================================");
    operators();

    println!("===================================Learning Match Expressions====================================");
    r#match();

    println!("===================================Learning HashMaps====================================");
    hashmaps();
    
    println!("===================================Learning Projects====================================");
    task1::median_mode();
    task1::pig_latin("apple");
    task1::alphabetical_employees_interface();
    
    // New advanced topics
    println!("\n\n===================================ADVANCED RUST CONCEPTS====================================");
    
    println!("===================================Learning Implementations====================================");
    run_impl_examples();
    
    println!("\n===================================Learning Generics====================================");
    run_generics_examples();
    
    println!("\n===================================Learning Traits====================================");
    run_traits_examples();
    
    println!("\n===================================Learning Lifetimes====================================");
    run_lifetimes_examples();
    
    println!("\n===================================END OF EXAMPLES====================================");
    println!("Congratulations! You've completed all the Rust learning examples.");
}

fn whats_your_name() {
    let mut name = String::new();
    let greeting: &str = "Nice to meet you,";

    println!("What is your name?");

    io::stdin()
        .read_line(&mut name)
        .expect("Failed to read line");

    println!("{}, {}!", greeting.trim(), name.trim());
}