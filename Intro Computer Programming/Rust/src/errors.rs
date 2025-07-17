use::std::fs::File;
use std::io::{self, Read};
use std::fmt;


pub fn error() {

    // Example of handling a file error
    let file_result = File::open("config.txt");

    match file_result {
        Ok(file) => {
            println!("File opened successfully!");
            // Use the file
        },
        Err(e) => {
            println!("Error opening file: {:?}", e);
            // Maybe retry or exit gracefully
        }
    }

    // unwrapping can be used for quick prototyping, but it's not recommended for production code
    //both are quick ways to handle errors 
    let file = File::open("config.txt").unwrap(); // panics on error
    let file = File::open("config.txt").expect("Failed to open config file");
}


// Example of a function that reads a file and returns a Result
// ? operator can be used to propagate errors
pub fn read_config() -> Result<String, io::Error> {
    let mut file = File::open("config.txt")?; // if this fails, return Err
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}


pub fn custom_error_example() {
    // Example of a custom error type
    #[derive(Debug)]
    enum MyError {
        NotFound,
        InvalidInput,
    }
    
    impl fmt::Display for MyError {
        fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
            match self {
                MyError::NotFound => write!(f, "Item not found"),
                MyError::InvalidInput => write!(f, "Invalid input"),
            }
        }
    }
}


