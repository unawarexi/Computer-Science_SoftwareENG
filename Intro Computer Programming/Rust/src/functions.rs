use std::io;

fn main() {
  add_numbers(5, 10);
}


fn add_numbers(a: i32, b: i32) -> i32 {
    let sum: i32 = a + b;

    println!("The sum is: {}", sum);
}