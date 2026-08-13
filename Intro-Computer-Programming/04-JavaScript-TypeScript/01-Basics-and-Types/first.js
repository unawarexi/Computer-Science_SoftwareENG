// const number = 7;

// const factor = 2;

// // to check for even numbers
// if (number % factor == 0) {
//     console.log("number is even");
// } else {
//     console.log("number is odd");
// }


// // function to check if a number is prime
// function isPrime(n) {
//     if (n <= 1) return false;  // Numbers less than or equal to 1 are not prime
//     if (n === 2) return true;  // 2 is the only even prime number
//     for (let i = 2; i <= Math.sqrt(n); i++) {
//         if (n % i === 0) {
//             return false;  // If divisible by any number other than 1 and itself, it's not prime
//         }
//     }
//     return true;
// }

// // to check if the number is prime
// if (isPrime(number)) {
//     console.log("this is a prime number");
// } else {
//     console.log("this is not a prime number");
// }

// let person = {
//     firstName : "Andrew",
//     lastName : "chukwuweike",
//     age: 40,
//     eyeColor: "black",
//     height: "6.3ft",
//     complexion: "dark"
// }

// const sentence  =  `${person.firstName} ${person.lastName} is almost ${person.age}, ${person.complexion} in tone and ${person.height}  `
// console.log(sentence)


// function greeting(firstName) {
//     console.log(`goodMormning ${firstName}`)
// }
// greeting("andrew")


// function formatter (num ) {
//     const formatter_num = `+234 ${num}`
//     return formatter_num
// }

// const result = formatter("8106046596");
// console.log(`your formatted number is ${result}`)


function createStudent(studentName, studentScore) {
    return {
        studentName,
        studentScore,
        studentGrade: null
    };
}


function calculateGrade(student) {
    const totalScore = student.studentScore;

    if (totalScore >= 70) {
        student.studentGrade = "A";
    } else if (totalScore >= 60) {
        student.studentGrade = "B";
    } else if (totalScore >= 40 && totalScore < 60) {  
        student.studentGrade = "C";
    } else {
        student.studentGrade = "failed";
    }
}


function displayStudentDetails(student) {
    console.log(`Student Name: ${student.studentName}`);
    console.log(`Student Score: ${student.studentScore}`);
    console.log(`Student Grade: ${student.studentGrade ?? 'Not Calculated'}`);
    if (student.studentGrade === "failed") {
        console.log(`${student.studentName} has failed` ?? "Not Calculated");
    } else {
        console.log(`${student.studentName} has passed`);
    }
}

function main() {
    const student = createStudent("Andrew", 61);
    calculateGrade(student);

    displayStudentDetails(student);
}

main();
