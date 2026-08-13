// Math properties and methods
/*
 1. Math is a built-in object that has properties and methods for mathematical constants and functions.
 2. Most methods are static, meaning they are called on the Math object itself.
*/

// Examples of Math methods
/*
 1. abs: Returns the absolute value of a number.
*/
console.log(Math.abs(-5)); // 5

/*
 2. ceil: Returns the smallest integer greater than or equal to a given number.
*/
console.log(Math.ceil(4.3)); // 5

/*
 3. floor: Returns the largest integer less than or equal to a given number.
*/
console.log(Math.floor(4.7)); // 4

/*
 4. round: Rounds a number to the nearest integer.
*/
console.log(Math.round(4.5)); // 5

/*
 5. max: Returns the largest of zero or more numbers.
*/
console.log(Math.max(1, 2, 3, 4)); // 4

/*
 6. min: Returns the smallest of zero or more numbers.
*/
console.log(Math.min(1, 2, 3, 4)); // 1

/*
 7. pow: Returns the base raised to the exponent power.
*/
console.log(Math.pow(2, 3)); // 8

/*
 8. sqrt: Returns the square root of a number.
*/
console.log(Math.sqrt(16)); // 4

/*
 9. random: Returns a pseudo-random number between 0 and 1.
*/
console.log(Math.random()); // e.g., 0.123456

/*
 10. floor: Returns the largest integer less than or equal to a given number.
*/
console.log(Math.floor(Math.random() * 10)); // random number between 0 and 9

/*
 11. sin: Returns the sine of a number (angle in radians).
*/
console.log(Math.sin(Math.PI / 2)); // 1

/*
 12. cos: Returns the cosine of a number (angle in radians).
*/
console.log(Math.cos(Math.PI)); // -1

/*
 13. tan: Returns the tangent of a number (angle in radians).
*/
console.log(Math.tan(Math.PI / 4)); // 1

/*
 14. exp: Returns E raised to the power of a given number.
*/
console.log(Math.exp(1)); // 2.718281828459045

/*
 15. log: Returns the natural logarithm (base E) of a number.
*/
console.log(Math.log(Math.E)); // 1

/*
 16. log10: Returns the base 10 logarithm of a number.
*/
console.log(Math.log10(100)); // 2

/*
 17. log2: Returns the base 2 logarithm of a number.
*/
console.log(Math.log2(8)); // 3

/*
 18. hypot: Returns the square root of the sum of squares of its arguments.
*/
console.log(Math.hypot(3, 4)); // 5

/*
 19. trunc: Returns the integer part of a number, removing any fractional digits.
*/
console.log(Math.trunc(4.9)); // 4

/*
 20. sign: Returns the sign of a number, indicating whether the number is positive, negative, or zero.
*/
console.log(Math.sign(-10)); // -1

/*
 21. PI: Represents the value of π (pi).
*/
console.log(Math.PI); // 3.141592653589793

/*
 22. E: Represents Euler's number (the base of natural logarithms).
*/
console.log(Math.E); // 2.718281828459045

/*
 23. random: Returns a pseudo-random number between 0 and 1.
*/
console.log(Math.random()); // e.g., 0.987654321

/*
 24. set: Defines a constant value for a mathematical constant.
*/
console.log(Math.LN2); // 0.6931471805599453 (natural logarithm of 2)

/*
 25. clamp: Clamps a number between a minimum and maximum value.
*/
function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}
console.log(clamp(10, 5, 8)); // 8

/*
 26. radians: Converts degrees to radians.
*/
function degreesToRadians(degrees) {
  return degrees * (Math.PI / 180);
}
console.log(degreesToRadians(180)); // 3.141592653589793

/*
 27. degrees: Converts radians to degrees.
*/
function radiansToDegrees(radians) {
  return radians * (180 / Math.PI);
}
console.log(radiansToDegrees(Math.PI)); // 180

/*
 28. average: Calculates the average of an array of numbers.
*/
function average(numbers) {
  return numbers.reduce((sum, num) => sum + num, 0) / numbers.length;
}
console.log(average([1, 2, 3, 4, 5])); // 3

/*
 29. median: Calculates the median of an array of numbers.
*/
function median(numbers) {
  numbers.sort((a, b) => a - b);
  const mid = Math.floor(numbers.length / 2);
  return numbers.length % 2 === 0 ? (numbers[mid - 1] + numbers[mid]) / 2 : numbers[mid];
}
console.log(median([1, 3, 2, 5, 4])); // 3

/*
 30. mode: Calculates the mode of an array of numbers.
*/
function mode(numbers) {
  const frequency = {};
  let maxFreq = 0;
  let modes = [];

  numbers.forEach((num) => {
    frequency[num] = (frequency[num] || 0) + 1;
    if (frequency[num] > maxFreq) {
      maxFreq = frequency[num];
    }
  });

  for (const num in frequency) {
    if (frequency[num] === maxFreq) {
      modes.push(Number(num));
    }
  }

  return modes;
}
console.log(mode([1, 2, 2, 3, 4, 4])); // [2, 4]
