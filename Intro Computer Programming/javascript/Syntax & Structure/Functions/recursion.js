/**
 * they're functions that calls itself inisde a function body
 * it stops itself
 * they must be a condition to stop the function else inifinite loop
 *
 * this condition is called the "base case"
 */

const count = (num) => {
  // prints in reverse
  console.log(num);

  let updated = num - 1;

  if (updated >= 0) {
    //base case
    count(updated); // recursive
  }
};

count(10);

const numbers = (num1) => {
  console.log(num1);

  let updatedNum = num1 + 1;

  if (updatedNum <= 10) {
    numbers(updatedNum);
  }
};

numbers(0);
