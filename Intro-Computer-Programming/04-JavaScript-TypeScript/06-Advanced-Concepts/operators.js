// operators.js

//============================ COMPARISON OPERATORS

/**
 * Comparison operators are used to compare values and return a boolean value (true or false).
 * There are 3 main types of comparison operators:
 *
 * 1. Relational - compares values in relation to one another.
 * 2. Abstract - checks for equality without considering data types.
 * 3. Strict - checks for equality, considering both value and data type.
 *
 * Common relational operators include:
 * - `>`  (greater than)
 * - `<`  (less than)
 * - `<=` (less than or equal to)
 * - `>=` (greater than or equal to)
 */

// Example of comparison operators
let a = 5;
let b = "5";

console.log(a > 3); // true
console.log(a < 3); // false
console.log(a == b); // true (abstract equality)
console.log(a === b); // false (strict equality)
console.log(a != b); // false (abstract inequality)
console.log(a !== b); // true (strict inequality)

//============================== Logical Operators

/**
 * Logical operators are used to combine boolean values.
 *
 * There are two types of logical operators:
 *
 * 1. Truthy Operators: These evaluate to true. Examples include `&&` (AND), `||` (OR), and `!` (NOT).
 * 2. Falsy Operators: These evaluate to false. Examples include `null`, `undefined`, `0`, `false`, and an empty string.
 *
 * There is a special operator called the nullish coalescing operator "??".
 *
 * NOTE: The difference between ?? and ||:
 * - The nullish operator "??" returns the right-hand side value if the left-hand side is `null` or `undefined`.
 * - The OR operator "||" returns the right-hand side value if the left-hand side is falsy (including 0, empty string, etc.).
 */

let course;

// Displays a message if 'course' is null or undefined.
console.log(course ?? "Please select a course"); // Output: "Please select a course"

let courseProgress = 0;

// Displays the value of 'courseProgress' since it is not null or undefined.
console.log(courseProgress ?? "Start the course"); // Output: 0

// Example of logical operators
let isLoggedIn = true;
let hasAccess = false;

console.log(isLoggedIn && hasAccess); // false (AND)
console.log(isLoggedIn || hasAccess); // true (OR)
console.log(!isLoggedIn); // false (NOT)

//========================= ARITHMETIC OPERATORS

/**
 * Arithmetic operators perform basic mathematical operations.
 *
 * Common arithmetic operators include:
 * - `+`  (addition)
 * - `-`  (subtraction)
 * - `*`  (multiplication)
 * - `/`  (division)
 * - `%`  (modulus)
 * - `**` (exponentiation)
 */

// Example of arithmetic operators
let x = 10;
let y = 2;

console.log(x + y); // 12
console.log(x - y); // 8
console.log(x * y); // 20
console.log(x / y); // 5
console.log(x % y); // 0
console.log(x ** y); // 100

// End of operators.js
