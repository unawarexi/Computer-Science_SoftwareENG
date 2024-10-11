// ============================== function to print 
// Print "#" 5 times 
console.log("Option A:");
for (let i = 1; i <= 4; i++) {
  let output = "";
  for (let j = 1; j <= 5; j++) {
    output += "# ";
  }
  console.log(output.trim());
}

// Print "*" 5 times in 4 places, 
console.log("\nOption B:");
for (let i = 1; i <= 4; i++) {
  let output = "";
  for (let j = 1; j <= (i === 4 ? 3 : 5); j++) {
    output += "* ";
  }
  console.log(output.trim());
}

//  Print "#" in ascending order till 5 times
console.log("\nOption C:");
for (let i = 1; i <= 5; i++) {
  let output = "";
  for (let j = 1; j <= i; j++) {
    output += "# ";
  }
  console.log(output.trim());
}

//============================  Arrange numbers in ascending order
const ascendingOrder = (a, b, c) => {
  let firstNumber, secondNumber, thirdNumber;

  if (a <= b && a <= c) {
      firstNumber = a;
      if (b <= c) {
          secondNumber = b;
          thirdNumber = c;
      } else {
          secondNumber = c;
          thirdNumber = b;
      }
  } else if (b <= a && b <= c) {
      firstNumber = b;
      if (a <= c) {
          secondNumber = a;
          thirdNumber = c;
      } else {
          secondNumber = c;
          thirdNumber = a;
      }
  } else {
      firstNumber = c;
      if (a <= b) {
          secondNumber = a;
          thirdNumber = b;
      } else {
          secondNumber = b;
          thirdNumber = a;
      }
  }

  return `${firstNumber}, ${secondNumber}, ${thirdNumber}`;
}

console.log(ascendingOrder(7, 6, 8)); 
console.log(ascendingOrder(15, 2, 6)); 
console.log(ascendingOrder(6, 9, 2)); 
console.log(ascendingOrder(2, 7, 1));

// const ascendingOrder = (...numbers) => {
//     // const numbers = [2, 10, 8, 11, 15];

//     console.log(numbers.sort((a, b) => a - b));
//  }

//  ascendingOrder(2, 10, 8, 11, 15);

//=========================== print name with sentence
function printName( name ) {
    console.log(`hello ${name}, how are you?`)

}
printName("andrew")



// //========================== function to check age
const ageCheck = (name, age) => {
  age >= 18
    ? console.log(`hi ${name} you're old enough`)
    : console.log(`hello ${name}, sorry but you're not old enough`);
};

const verify = ageCheck("andrew", 18)
