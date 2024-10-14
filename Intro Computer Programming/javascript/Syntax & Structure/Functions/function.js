// functions.js

/**
 * FUNCTIONS
 * Functions are reusable blocks of code that can be stored in a variable,
 * contain local variables, and are created using different methods.
 * 
 * Key Points:
 * 1. Functions can be treated like objects (non-primitive data types).
 * 2. Variables declared within a function are local, while those outside are global.
 * 
 * NOTE: The difference between an object and a function is that functions can be invoked.
 * Functions can be called dynamically using events.
 * 
 * Types of Functions:
 * 1. Function Declaration: e.g., function my_function() { ... }
 * 2. Function Expression: e.g., let myFunc = function() { ... }
 * 3. Arrow Functions: e.g., const myFunc = () => { ... }
 * 4. Function Constructors: e.g., new Function('...') { ... }
 * 5. Generator Functions: Functions that can be exited and re-entered.
 * 6. Anonymous Functions: Functions without names, commonly used in event listeners.
 */

// Function Declaration
function my_function() { // Creating a function by declaration
   console.log(`Andrew is a billionaire`);

   let andrew = 'male';   // Local variable
   let billion = 20000000000;
   console.log(`Andrew ${andrew} is worth $${billion}`);
}

my_function(); // Invoking the function (the "()" is important)

/* 
* Example of an anonymous function used with an event listener:
* Uncomment to use in a browser environment with a button element.
*/

// let btn = document.querySelector('.btn');
// btn.addEventListener("click", function () { // Anonymous function
//     console.log(`sonic`);
// });

/*============================================================== FUNCTION EXPRESSION
* Function expressions are functions defined inside expressions or other syntax.
* Assigning functions to variables creates anonymous functions.
* 
* NOTE: 
* 1. Function declarations must have a name, while function expressions do not.
* 2. Function declarations can be invoked before they are defined, but function expressions cannot.
*/

let ruler = 'Jennifer'; // Global variable

let brother = function () { // Function expression
   console.log(`This would be bad if ${ruler} rules.`);
};

let chairman = brother; // Assign to a new variable to invoke the same function

// brother(); // Old variable name
chairman(); // Invoking new variable name

/*================================================================== ARROW FUNCTIONS
* Arrow functions provide a shorter syntax for writing function expressions.
* Introduced in ES6 (2015).
* 
* SYNTAX:
* var_name = (multi-params) => { ... }
* For single parameter, omit the parentheses: param => { ... }
* For single-line statements, omit the braces and use the same line.
* 
* NOTE: Do not use arrow functions to access object properties as they point 
* to the global context instead of the main object.
*/

const babies = () => { // Normal arrow function
   console.log(`Emmanuel`);
};

babies(); // Invoking the arrow function

const baddie = () => "Amber"; // Shorter arrow function
console.log(baddie());

const baby = (a, b) => { // Arrow function with multiple parameters
   console.log(a + b);
};

baby(2, 3); // Output: 5

const bad = FirstNames => { // Arrow function with a single parameter
   console.log(`His Firstname is ${FirstNames}`);
};

bad("Fred Swaniker"); // Output: "His Firstname is Fred Swaniker"

// Using arrow functions within an object method
const musicians = {
   artist: "Kanye West",
   genre: "Hip-hop",
   kids: "5 kids",
   height: "6ft",
   Moreinfo() {
       console.log(`${this.artist} is having quality time with his ${this.kids}`);
   }
};

musicians.Moreinfo(); // Output: "Kanye West is having quality time with his 5 kids."

// Example of using an arrow function inside a method
const games = {
   title: "Sonic Hedgehog",
   related: ['Born of Hedge', 'Sonic 3', 'Sonic & Knuckles'],
   year: 1991,
   showrelated: function () { // Main function
       // Method "forEach" looping inside "related" property
       this.related.forEach((relatedgames) => { // Arrow function inside a method
           console.log(`The return of ${this.title} - ${relatedgames}`);
       });
   }
};

games.showrelated(); // Output: "The return of Sonic Hedgehog - Born of Hedge", etc.
