// ============================== function to print 
// Option A: Print "#" 5 times in 4 places
console.log("Option A:");
for (let i = 1; i <= 4; i++) {
  let output = "";
  for (let j = 1; j <= 5; j++) {
    output += "# ";
  }
  console.log(output.trim());
}

// Option B: Print "*" 5 times in 4 places, but the 4th line prints only 3
console.log("\nOption B:");
for (let i = 1; i <= 4; i++) {
  let output = "";
  for (let j = 1; j <= (i === 4 ? 3 : 5); j++) {
    output += "* ";
  }
  console.log(output.trim());
}

// Option C: Print "#" in ascending order till 5 times
console.log("\nOption C:");
for (let i = 1; i <= 5; i++) {
  let output = "";
  for (let j = 1; j <= i; j++) {
    output += "# ";
  }
  console.log(output.trim());
}

//============================  Arrange numbers in ascending order
const ascendingOrder = () => {
    const numbers = [2, 10, 8, 11, 15];

    console.log(numbers.sort((a, b) => a - b));
 }

 ascendingOrder();

//=========================== print name with sentence
function printName( name ) {
    console.log(`hello ${name}, how are you?`)

}
printName("andrew")



//========================== function to check age
const ageCheck = (name, age) => {
  age >= 18
    ? console.log(`hi ${name} you're old enough`)
    : console.log(`hello ${name}, sorry but you're not old enough`);
};

const verify = ageCheck("andrew", 18)
