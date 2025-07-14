#![allow(unused)]
use std::io;
use rand::Rng;
use std::fs::File;
use std::cmp::Ordering;

mod functions;
mod loops; 
mod datatypes_variables;
mod conditionals;
mod operators;
mod r#match;

use functions::add_numbers;
use loops::r#main as loop_main;
use datatypes_variables::datatypes;
use conditionals::conditionals;
use operators::operators;
use r#match::r#match as r#match;

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
