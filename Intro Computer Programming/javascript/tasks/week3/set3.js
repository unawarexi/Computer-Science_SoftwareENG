// --------------- using modulus
for (let evenNumbers = 0; evenNumbers <= 50; evenNumbers++) {
  evenNumbers % 2 == 0
    ? console.log(`these are the even numbers: ${evenNumbers}`)
    : null;
}

//--------------- without moudulus
for (let evenNumbers = 0; evenNumbers <= 50; evenNumbers++) {
  if ((evenNumbers & 1) === 0) {
    console.log(evenNumbers + " is even");
  }
}

// ================= to add numbers in range of 0 to 20
let addNumbers = 0;
let sum = 0;

while (addNumbers <= 20) {
  sum += addNumbers;
  addNumbers += 1;
}

console.log("Sum of numbers from 0 to 20 is:", sum);

// //==================== checking for odd numbers between 0 to 100
for (let oddNumbers = 0; oddNumbers <= 100; oddNumbers++) {
  oddNumbers % 2 != 0
    ? console.log(`this is an odd number ${oddNumbers}`)
    : null;
}
