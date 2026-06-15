// templateLiterals.js

/*
 * TEMPLATE LITERALS
 * Template literals are enclosed in backticks (``) and offer enhanced string 
 * functionalities compared to regular strings.
 * 
 * Key Features:
 * 
 * 1. Multi-line Strings: You can use "\n" to create a new line, which is useful when 
 *    you're not using ${} for variable interpolation.
 * 
 * 2. Variable Interpolation: You can insert variables directly into the string 
 *    using the ${var_name} syntax.
 * 
 * 3. String Concatenation: Template literals make it easy to concatenate strings 
 *    without needing to use the '+' operator.
 */

let man = "Andrew";
let course = "JavaScript";
let channel = "DevDreamer";

// Using template literals to concatenate strings
let info = `${man} is learning ${course} with ${channel}`;
console.log(info); // Output: "Andrew is learning JavaScript with DevDreamer"

// Example of multi-line string using template literals
let multiLine = `This is line one.
This is line two.
This is line three.`;
console.log(multiLine);

/* 
 * In the example above, pressing enter creates a new line within the template 
 * literal without needing to use the "\n" character explicitly.
 * 
 * You can also embed expressions inside template literals.
 */

let a = 5;
let b = 10;
console.log(`The sum of ${a} and ${b} is ${a + b}.`); // Output: "The sum of 5 and 10 is 15."
