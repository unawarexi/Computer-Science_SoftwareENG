#![allow(unused)]
use std::io;
use rand::Rng;
use std::fs::File;
use std::cmp::Ordering;

fn main() {
    println!("Hello, world!");
    whats_your_name();
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
