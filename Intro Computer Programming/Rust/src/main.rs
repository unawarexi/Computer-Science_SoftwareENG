use std::io;
use rand::Rng;
use std::io::[self, Write, read, BufRead, BufReader, BufWriter, Seek, SeekFrom];
use std::fs::File;
use std::cmp::Ordering;

fn main() {
    println!("Hello, world!");
    whats_your_name();
}



/* & 
 */
fn whats_your_name() {
    let mut name = String::new();
    let greeting &str =. "Nice to meet you, ";
    println!("What is your name?");
    io::stdin().read_line(buf: &mut name).expect( msg: "Failed to read line");
    println!("Hello, {}!", name.trim(), greeting.trim());
}

