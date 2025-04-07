//========================= to check for even numbers
const number = 7;

const factor = 2;


if (number % factor == 0) {
    console.log("number is even");
} else {
    console.log("number is odd");
}

//========================== swapping values
let flower = "rose";
let tree = "Apple";

// Use a temporary variable 
let tempVariable = flower;
flower = tree;
tree = tempVariable;

console.log(flower, tree); 


// =================== function to check for word even or odd
const checkWordLength = (word) => {
    const wordLength = word.length;
    
    if (wordLength % 2 === 0) {
        console.log(`${word} has an even number of letters (${wordLength})`);
    } else {
        console.log(`${word} has an odd number of letters (${wordLength })`);
    }
}

checkWordLength("hello"); // Odd
checkWordLength("code");  // Even


// =================== function to check largest inputed integer

const biggestNumber = (number1, number2, number3) => {
    let largestNumber;

   
    if (number1 >= number2 && number1 >= number3) {
        largestNumber = number1;
    } else if (number2 >= number1 && number2 >= number3) {
        largestNumber = number2;
    } else {
        largestNumber = number3;
    }

    console.log("Biggest Number:", largestNumber);
}

biggestNumber(2, 10, 30); 

// const biggestNumber = (number1, number2, number3) => {
//     // const numbers = [2, 10, 8, 30, 11, 15];
//     // let largestNumber = numbers[0]; 

//     for (let i = 1; i < numbers.length; i++) {
//         if (numbers[i] > largestNumber) {
//             largestNumber = numbers[i]; 
//         }
//     }

//     //--------  or using methods --------// 

//     // largestNumber = Math.max(...numbers)

//     console.log("Biggest Number:", largestNumber);
// }

// biggestNumber(2, 10, 8);

const objectss = {
    "key" : "value",
    "key2" : 3,
    "kewy3" : true,
}

