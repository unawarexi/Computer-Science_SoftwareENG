fn main() {
    // global variables
    let mut counter = 0;
    let mut number = 5;
    let nums = [10, 20, 30];


    // Example of a simple loop infinite loop
    loop {
        println!("Count: {}", counter);
        counter += 1;

        if counter == 3 {
            break; // Exit loop
        }
    }


    // Example of a while loop
    while number > 0 {
        println!("Countdown: {}", number);
        number -= 1;
    }

    println!("Liftoff!");

    // Example of a for loop
    for num in nums {
        println!("Number: {}", num);
    }
   
   // Example of a range-based for loop
    for i in 1..5 {
        println!("i: {}", i); // 1 to 4 (exclusive)
    }

   // nested loops; Labeled Loops 
    'outer: for i in 1..=3 {
        for j in 1..=3 {
            if i == 2 && j == 2 {
                break 'outer; // Exit both loops
            }
            println!("i: {}, j: {}", i, j);
        }
    }
}