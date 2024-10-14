/**
 * recives a function as an argument
 * returns a function as an output
 * can be used dynamically
 * they're inbuilt
 *
 * e.g
 * addEventlistener, and datatype methods
 */

/*====================================================== PURE FUNCTIONS*
 * produces the same expected outcome with the value args given
 * doesn't change stuffs outside of itself
 *
 * ==================================================== INPURE FUNCTIONS
 * generates unexpected output
 * changes stuffs outside of itself
 *
 */

const nums = (n) => {
  console.log(n * 2);
};
let numsArray = [1, 2, 3, 4, 5];
let total = numsArray.map(nums); // map higher functions

//========================== pure
const numbers = function (x, y) {
  // pure functions
  console.log(x + y);
};

numbers(5, 7); // returns expected results

//============================ impure
const numerals = (nume) => console.log(nume + Math.random()); //impure functions

numerals(5); // woud always generate unpredictible answeers
