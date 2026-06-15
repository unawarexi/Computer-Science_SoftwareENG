// primitive data types

/*
1. String: Enclosed in quotes, used for text.
2. Boolean: Represents true/false values.
3. Number: Represents integers and floating-point numbers.
4. BigInt: Used to handle very large integers; append "n" to a number to convert it to BigInt.
5. Null: Represents a variable with a value of nothing.
6. Symbol: A unique and immutable primitive value, often used as object property keys.
7. Undefined: Indicates a variable that has been declared but not assigned a value.

Note: Use "typeof" to determine the type of a variable.
*/

// non-primitive data types

/*
Non-primitive types are objects, which can be further categorized as follows:

1. Arrays:
   * A collection of values, which can be of different primitive types.
   * Declared using square brackets [].
   * Accessed using the variable name followed by an index.

2. Functions:
   * Declared using the "function" keyword, followed by a function name and parentheses.
   * The function body contains the code to execute.
   * Invoked by calling the function name outside its declaration.

3. Objects:
   * Declared using curly braces {} to define key-value pairs.
   * Accessed using dot notation (obj_name.key) or bracket notation (obj_name['key']).
   * Objects can hold multiple values and types.
*/

// Example usage of primitive data types
let boy = "andrew"; // String
let age = 15; // Number
let my; // Undefined
let cash = 8874348794747834n; // BigInt
let sis = null; // Null

// Boolean check
let me = "big";
console.log(me == "big"); // Boolean returns true or false

// Example usage of non-primitive data types

// Array example
let person = ["andrew", "15", true, 7, null]; // This is an array
console.log(person[1]); // Accessing the second element using indexing

// Function example
function information() {
  // This is a function
  console.log(`information is life`);
  console.log(`${boy} is ${age}`);
}

information(); // Invoking the function

// Object example
let individual = {
  names: "andrew", // Key-value pair
  age: 15,
  height: "6ft", // Properties separated by commas
  netWorth: "$6000000", // Contains different data types
  complexion: "dark",
  hair: "type4b",
  chubby: true,
};

console.log(individual.netWorth); // Accessing the value of the 'netWorth' property
