use std::io;
use rand::Rng;
use std::fs::File;
use std::cmp::Ordering;

fn main() {
   const GREETING: &str = "Nice to meet you,"; 
   let name: &str = "Alice"; // Example slice variable

   //mutable viariable
   let mut age = 25; // Example age variable
   age = 25 // same memory location, but different value
   
   const PI: f64 = 3.14159; // Example constant
   let salary: u32 = 100000; // Example unsigned integer variable
   let bonus: f32 = 5000.50; // Example floating-point variable
   const graduated : bool = true; // Example boolean constant
   let is_employed: bool = false; // Example boolean variable

   let x = 10; // Example immutable and inferred variable
   let mut y = 20; // Example mutable and inferred variable

   // shadowing example; relaces the previous value of x
    let x = 5; // x is immutable
    let x = x + 1; // x is now shadowed and mutable
    let x = "blue"; // x is now shadowed again




// use arrays when youre certain of the size
// use vectors when you want a dynamic size
// use tuples when you want to group different types together
// use structs when you want to define a custom data type
// use enums when you want to define a type that can be one of several variants    
let scores: [u32; 5] = [90, 85, 78, 92, 88]; // Example array variable unisgned integer array

let mut numbers: Vec<i32> = vec![1, 2, 3, 4, 5]; // Example vector variable

struct Person {
    name: String,
    age: u32, } 

let person = Person {
    name: String::from("Alice"),
    age: 30,
}

const MAX_SCORE: (String, u32, bool, f64) = (String::from("Alice"), 100, true, 3.14); // Example tuple constant

enum Direction {
    Up,
    Down,
    Left,
    Right, 
}
let direction = Direction::Up; // Example enum variable


let random_number: u32 = rand::thread_rng().gen_range(1..101); // Example random number generation


}