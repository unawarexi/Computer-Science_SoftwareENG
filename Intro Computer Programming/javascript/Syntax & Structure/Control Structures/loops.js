// loops.js

/**
 * FOR LOOPS
 * Used for executing a block of code a fixed number of times.
 * Syntax:
 *   1. Initialization
 *   2. Condition
 *   3. Increment/Final Expression
 *
 * Structure:
 * for (initializer; condition; increment) {
 *     // Code to be executed
 * }
 *
 * - The initializer is executed first.
 * - As long as the condition is true, the code block runs.
 * - The increment is executed after each iteration.
 */

for (let i = 0; i <= 10; i++) {
  console.log(i); // Outputs numbers from 0 to 10
}

// Example using an array of characters
const characters = ["andrew", "chukwuweike", "chindeu", "justice"];
let info = `The characters are `;

const colors = ["orange", "purple", "maroon", "blue", "green"];
let statement = `is my favourite color `;

// Looping through colors array
for (let m = 0; m < colors.length; m++) {
  if (m === 1) {
    console.log(`${colors[1]}, ${statement}`); // Outputs: "purple, is my favourite color"
  }
}

/*=======================================================================================*
 * FOR-IN LOOP
 * Used to iterate over enumerable properties of an object.
 */

const dreamCar = {
  brand: "lamborghini",
  model: "huracan",
  speed: "650MPH",
  color: "white",
  weight: 100,
};

// Adding properties
dreamCar.turbo = "ghost_cylinder";
dreamCar.engine = "v12 bi-turbo";
delete dreamCar.weight; // Removing a property

// Define property attributes
Object.defineProperty(dreamCar, "brand", {
  configurable: true,
  enumerable: true, // Makes property visible
  value: "lamborghini",
  writable: true,
});

// Iterating over properties of the dreamCar object
for (let car in dreamCar) {
  console.log(`${car}: ${dreamCar[car]}`);
}

// Example with salaries object
const salaries = {
  peter: 55000,
  andrew: 300000,
  harvey: 150000,
};

// Looping through salaries object
for (let salary in salaries) {
  let cash = `$${salaries[salary]}`;
  console.log(`${salary} earns ${cash} per year`);
}

/*======================================================================*
 * FOR OF LOOP
 * A new feature from ES6, used to iterate over iterable data structures (arrays, strings).
 * Use 'break;' to exit the loop when a condition is met.
 *
 * Differences between for-in and for-of:
 *   1. for-in is for objects.
 *   2. for-of is for iterable data structures (e.g., arrays).
 */

const beautyColors = ["purple", "maroon", "gold", "orange", "green"];

for (let beauty of beautyColors) {
  if (beauty === "orange") {
    break; // Exits the loop if 'orange' is found
  } else {
    console.log(`${beauty}`); // Outputs colors until 'orange'
  }
}

/*==============================================================================*
 * WHILE LOOP
 * Initialize the loop variable first.
 * Structure:
 * while (condition) {
 *     // Code to execute
 *     increment;
 * }
 */

let colorsArray = ["red", "blue", "green", "orange", "purple"];
let colorIndex = 0;

// Looping through colors array
while (colorIndex < colorsArray.length) {
  console.log(`${colorsArray[colorIndex]}`); // Outputs each color
  colorIndex++; // Increment the index
}

// Another example using a speed counter
let speedInfo = `the speed of the car is `;
let speedLimit = 100;
let speed = 0;

while (speed <= speedLimit) {
  console.log(`${speedInfo} ${speed} MPH`); // Outputs speed increments
  speed += 10; // Increment speed by 10
}

/*==================================================================================================*
 * DO-WHILE LOOP
 * Runs at least once, as the code executes before the condition is tested.
 * Structure:
 * do {
 *     // Code to execute
 * } while (condition);
 */

let a = 0;

do {
  console.log(`the number is ${a}`); // Outputs the number
  a++; // Increment a
} while (a <= 10);

let b = 1;
let c = 10;

do {
  console.log(b); // Outputs the number
  b++; // Increment b
} while (b <= c);
