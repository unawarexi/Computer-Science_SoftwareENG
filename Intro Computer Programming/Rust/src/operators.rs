// operators.rs - Rust Operators Examples
// This file demonstrates all operators covered in the operators.md guide
#![allow(unused)]
pub fn operators() {
    println!("=== RUST OPERATORS EXAMPLES ===\n");
    
    //------------------------------------ 1. ARITHMETIC OPERATORS
    println!("1. ARITHMETIC OPERATORS");
    println!("------------------------");
    
    let a = 10;
    let b = 3;
    
    println!("a = {}, b = {}", a, b);
    println!("Addition: {} + {} = {}", a, b, a + b);
    println!("Subtraction: {} - {} = {}", a, b, a - b);
    println!("Multiplication: {} * {} = {}", a, b, a * b);
    println!("Division: {} / {} = {}", a, b, a / b);
    println!("Remainder (modulo): {} % {} = {}", a, b, a % b);
    
    // Demonstrating integer vs float division
    let x = 10.0;
    let y = 3.0;
    println!("Float division: {} / {} = {}", x, y, x / y);
    println!();
    
    //--------------------------------------- 2. COMPARISON OPERATORS
    println!("2. COMPARISON OPERATORS");
    println!("-----------------------");
    
    let num1 = 5;
    let num2 = 3;
    let num3 = 5;
    
    println!("num1 = {}, num2 = {}, num3 = {}", num1, num2, num3);
    println!("Equal to: {} == {} = {}", num1, num3, num1 == num3);
    println!("Not equal to: {} != {} = {}", num1, num2, num1 != num2);
    println!("Greater than: {} > {} = {}", num1, num2, num1 > num2);
    println!("Less than: {} < {} = {}", num2, num1, num2 < num1);
    println!("Greater than or equal: {} >= {} = {}", num1, num3, num1 >= num3);
    println!("Less than or equal: {} <= {} = {}", num2, num1, num2 <= num1);
    println!();
    
    //----------------------------------- 3. LOGICAL OPERATORS
    println!("3. LOGICAL OPERATORS");
    println!("--------------------");
    
    let is_logged_in = true;
    let has_permission = false;
    let is_admin = true;
    
    println!("is_logged_in = {}, has_permission = {}, is_admin = {}", 
             is_logged_in, has_permission, is_admin);
    
    // AND operator
    println!("AND (&&): {} && {} = {}", 
             is_logged_in, has_permission, is_logged_in && has_permission);
    
    // OR operator
    println!("OR (||): {} || {} = {}", 
             has_permission, is_admin, has_permission || is_admin);
    
    // NOT operator
    println!("NOT (!): !{} = {}", has_permission, !has_permission);
    
    // Practical example
    let can_access = is_logged_in && (has_permission || is_admin);
    println!("Can access system: {}", can_access);
    println!();
    
    //------------------------------ 4. ASSIGNMENT OPERATORS
    println!("4. ASSIGNMENT OPERATORS");
    println!("------------------------");
    
    let mut value = 10;
    println!("Initial value: {}", value);
    
    // Basic assignment
    value = 15;
    println!("After assignment (=): {}", value);
    
    // Add and assign
    value += 5;
    println!("After add assign (+=): {}", value);
    
    // Subtract and assign
    value -= 3;
    println!("After subtract assign (-=): {}", value);
    
    // Multiply and assign
    value *= 2;
    println!("After multiply assign (*=): {}", value);
    
    // Divide and assign
    value /= 4;
    println!("After divide assign (/=): {}", value);
    
    // Modulo and assign
    value %= 3;
    println!("After modulo assign (%=): {}", value);
    println!();
    
    //--------------------------------------- 5. BITWISE OPERATORS
    println!("5. BITWISE OPERATORS");
    println!("--------------------");
    
    let bit_a = 0b1010; // 10 in binary
    let bit_b = 0b1100; // 12 in binary
    
    println!("bit_a = {} (binary: {:04b})", bit_a, bit_a);
    println!("bit_b = {} (binary: {:04b})", bit_b, bit_b);
    
    // Bitwise AND
    let and_result = bit_a & bit_b;
    println!("Bitwise AND: {} & {} = {} (binary: {:04b})", 
             bit_a, bit_b, and_result, and_result);
    
    // Bitwise OR
    let or_result = bit_a | bit_b;
    println!("Bitwise OR: {} | {} = {} (binary: {:04b})", 
             bit_a, bit_b, or_result, or_result);
    
    // Bitwise XOR
    let xor_result = bit_a ^ bit_b;
    println!("Bitwise XOR: {} ^ {} = {} (binary: {:04b})", 
             bit_a, bit_b, xor_result, xor_result);
    
    // Left shift
    let left_shift = bit_a << 1;
    println!("Left shift: {} << 1 = {} (binary: {:04b})", 
             bit_a, left_shift, left_shift);
    
    // Right shift
    let right_shift = bit_a >> 1;
    println!("Right shift: {} >> 1 = {} (binary: {:04b})", 
             bit_a, right_shift, right_shift);
    println!();
    
    //------------------------------------------- 6. TYPE CASTING (as operator)
    println!("6. TYPE CASTING (as operator)");
    println!("------------------------------");
    
    let integer = 42;
    let float_from_int = integer as f64;
    println!("Integer to float: {} as f64 = {}", integer, float_from_int);
    
    let float_val = 3.14;
    let int_from_float = float_val as i32;
    println!("Float to integer: {} as i32 = {}", float_val, int_from_float);
    
    let char_val = 'A';
    let ascii_val = char_val as u8;
    println!("Char to ASCII: '{}' as u8 = {}", char_val, ascii_val);
    println!();
    
    //----------------------------------------- 7. RANGE OPERATORS
    println!("7. RANGE OPERATORS");
    println!("------------------");
    
    println!("Exclusive range (1..5):");
    for i in 1..5 {
        print!("{} ", i);
    }
    println!();
    
    println!("Inclusive range (1..=5):");
    for i in 1..=5 {
        print!("{} ", i);
    }
    println!();
    println!();
    
    // 8. OPERATOR PRECEDENCE EXAMPLES
    println!("8. OPERATOR PRECEDENCE EXAMPLES");
    println!("--------------------------------");
    
    let result1 = 2 + 3 * 4;
    println!("2 + 3 * 4 = {} (multiplication first)", result1);
    
    let result2 = (2 + 3) * 4;
    println!("(2 + 3) * 4 = {} (parentheses first)", result2);
    
    let result3 = 5 > 3 && 2 < 4;
    println!("5 > 3 && 2 < 4 = {} (comparison before logical)", result3);
    
    let result4 = !false || true && false;
    println!("!false || true && false = {} (! then && then ||)", result4);
    println!();
    
    // 9. PRACTICAL EXAMPLES
    println!("9. PRACTICAL EXAMPLES");
    println!("---------------------");
    
    // Age verification
    let age = 20;
    let is_adult = age >= 18;
    println!("Age check: {} years old, is adult: {}", age, is_adult);
    
    // Even/odd check
    let number = 17;
    let is_even = number % 2 == 0;
    println!("Number {} is even: {}", number, is_even);
    
    // Grade calculation
    let score = 85;
    let grade = if score >= 90 {
        'A'
    } else if score >= 80 {
        'B'
    } else if score >= 70 {
        'C'
    } else if score >= 60 {
        'D'
    } else {
        'F'
    };
    println!("Score: {}, Grade: {}", score, grade);
    
    // Temperature conversion
    let celsius = 25.0;
    let fahrenheit = celsius * 9.0 / 5.0 + 32.0;
    println!("{}°C = {:.1}°F", celsius, fahrenheit);
    
    // Compound conditions
    let has_money = true;
    let store_open = true;
    let has_transport = false;
    
    let can_shop = has_money && store_open && has_transport;
    let can_try_shop = has_money && store_open;
    
    println!("Can definitely shop: {}", can_shop);
    println!("Can try to shop: {}", can_try_shop);
    
    println!("\n=== END OF OPERATORS EXAMPLES ===");
}

// Helper function to demonstrate more complex operator usage
fn demonstrate_bitwise_flags() {
    println!("\nBONUS: Bitwise Flags Example");
    println!("----------------------------");
    
    // Permission flags
    const READ: u8 = 0b001;    // 1
    const WRITE: u8 = 0b010;   // 2
    const EXECUTE: u8 = 0b100; // 4
    
    let mut permissions = 0b000; // No permissions
    
    // Grant read permission
    permissions |= READ;
    println!("After granting READ: {:03b}", permissions);
    
    // Grant write permission
    permissions |= WRITE;
    println!("After granting WRITE: {:03b}", permissions);
    
    // Check if has read permission
    let has_read = (permissions & READ) != 0;
    println!("Has READ permission: {}", has_read);
    
    // Remove write permission
    permissions &= !WRITE;
    println!("After removing WRITE: {:03b}", permissions);
    
    // Toggle execute permission
    permissions ^= EXECUTE;
    println!("After toggling EXECUTE: {:03b}", permissions);
}

// Additional examples for students to try
#[allow(dead_code)]
fn practice_exercises() {
    println!("\nPRACTICE EXERCISES (uncomment to run):");
    println!("======================================");
    
    // Exercise 1: Calculator
    // let num1 = 10;
    // let num2 = 3;
    // println!("Calculator: {} + {} = {}", num1, num2, num1 + num2);
    // println!("Calculator: {} - {} = {}", num1, num2, num1 - num2);
    // println!("Calculator: {} * {} = {}", num1, num2, num1 * num2);
    // println!("Calculator: {} / {} = {}", num1, num2, num1 / num2);
    
    // Exercise 2: Leap year checker
    // let year = 2024;
    // let is_leap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    // println!("Year {} is leap year: {}", year, is_leap);
    
    // Exercise 3: Number range checker
    // let value = 75;
    // let in_range = value >= 50 && value <= 100;
    // println!("Value {} is in range 50-100: {}", value, in_range);
    
    // Exercise 4: Password strength checker
    // let password_length = 12;
    // let has_special_char = true;
    // let has_number = true;
    // let is_strong = password_length >= 8 && has_special_char && has_number;
    // println!("Password is strong: {}", is_strong);
}