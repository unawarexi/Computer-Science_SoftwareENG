/**
 * In Node.js, exports allow you to share functions, objects, or values across files.
 * You can use "module.exports" or "exports" to export functions or data.
 * 
 * There are five common export patterns known as "import and export patterns."
 * Each pattern demonstrates a different way to share functionality between modules.
 * 
 * "Direct Function Export": module.exports = functionName.
 * "Anonymous Function Export": module.exports = (a, b) => {}.
 * "Object Export": module.exports = { function1, function2 }.
 * "exports Shortcut": exports.propertyName = function.
 * "Class Export": module.exports = className
 */

/**
 * 1. Exporting by assigning the function name to "module.exports" using "="
 * @param {*} a
 * @param {*} b
 * @returns sum
 */
const addNumbers = (a, b) => {
  return a + b;
};

// Export the function directly using module.exports
module.exports = addNumbers; // Now, addNumbers can be used in another file after import

// Example in index.js:
// const addNumbers = require('./moduleA');
// const sum = addNumbers(2, 3);
// console.log(sum); // Outputs: 5

/**
 * 2. Exporting by assigning "module.exports" directly without "const" or function names
 *
 * You can export a function anonymously without assigning a name to it.
 * This is useful if you don’t need to export a named function.
 */
module.exports = (a, b) => {
  return a - b;
};

// Example in index.js:
// const subtract = require('./moduleB');
// console.log(subtract(5, 3)); // Outputs: 2

/**
 * 3. Exporting multiple functions as properties of an object
 *
 * By exporting an object, you can share multiple functions from a single module.
 */
const greetings1 = (name) => {
  return `Hello, ${name}, you look awesome!`;
};

const greetings2 = (name) => {
  return `Hey, ${name}, great to see you!`;
};

// Exporting multiple functions as part of an object
module.exports = {
  greetings1, // Property name is the same as the function name
  greetings2, // Another function
  addNumbers, // You can also reuse previously defined functions
};

// Example in index.js:
// const { greetings1, greetings2, addNumbers } = require('./moduleC');
// console.log(greetings1('Bruce')); // Outputs: Hello, Bruce, you look awesome!
// console.log(addNumbers(10, 15));  // Outputs: 25

/**
 * 4. Exporting individual properties using "exports" shortcut
 *
 * The "exports" keyword is a shorthand for "module.exports" and allows you to add properties directly to the exports object.
 */
exports.multiply = (a, b) => {
  return a * b;
};

exports.divide = (a, b) => {
  return a / b;
};

// Example in index.js:
// const { multiply, divide } = require('./moduleD');
// console.log(multiply(4, 5));  // Outputs: 20
// console.log(divide(10, 2));   // Outputs: 5

/**
 * 5. Exporting a class or constructor function
 *
 * Instead of exporting just functions, you can also export classes or constructor functions.
 * This pattern is useful when you want to create reusable objects with methods.
 */
class Calculator {
  add(a, b) {
    return a + b;
  }
  subtract(a, b) {
    return a - b;
  }
}

// Export the class using module.exports
module.exports = Calculator;

// Example in index.js:
// const Calculator = require('./moduleE');
// const calc = new Calculator();
// console.log(calc.add(3, 4));      // Outputs: 7
// console.log(calc.subtract(9, 5)); // Outputs: 4

/**
 * NOTE:
 * You cannot have more than one "module.exports" declaration in your module file,
 * because it will overwrite any previous "module.exports" declaration.
 *
 * However, you can export multiple functions, objects, or classes by attaching them to an object or using "exports".
 */
