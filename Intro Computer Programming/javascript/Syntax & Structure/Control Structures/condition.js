/**
 *  // IF STATEMENTS
 *  has a syntax of if ()
 * the conditions runs in the bracket 
 * and the code runs if the condition is TRUE
 * 
 * // ELSE IF STATEMENTS
 *  comes in hady for making multiple conditions
 * comes befere the else statement
 * 
 * // IF ELSE STATEMENTS
 * same syntax withe the if 
 * works for when condition turns out to  be false
 */


let num = 10;
let num1 = 2;

let total = num + num1;

if (total > num1 && total < 20){
    console.log(`total is true`);

} else {
    console.log(`total is false`)
};

let user = "employee";
let guest;

if (user == guest){
    console.log(`access denied`)

} else if (user === "employee")
 {
    console.log(`successfully logged in`); 
};

let myName = "andrew"

if (myName.length > 5){
    alert(`More than 5`)

} else if (myName.length == 5){
    alert(`Exactly 5 letters`)

} else {
    alert (`less than 5 letters`)
};


// SWITCH STATEMENT
/**
 * it is used when the conditions are becoming much
 *  takes a value loops through " cases" to find the code it match
 * each case ends with a break;
 * end with "default" just like else statement
 * 
 *  start with " switch(var_name or boolen)"
 *     e.g switch(var_name){
 *             case 1:
 *                // code to run;
 *                  break;
 *             case 2 (2 is the value assigned to var_name / condition here too):
 *             default: // code to run
 *          }
 */

let FavFood = "Spaghetti";

switch (true){
    case FavFood == "rice":
       console.log(`Not my favourite`);
       break;

    case FavFood == "beans":
        console.log(`Not my favourite`);
        break;

    case FavFood == "Spaghetti":
        console.log(`Thats right ${FavFood} is my favourite`);
        break;

    case FavFood == "potato":
        console.log(`Not my favourite`);
        break;

    case FavFood == "tobacco":
        console.log(`Not my favourite`);
        break;

    default :
    console.log(`${FavFood} not found...i'm hungry`);
}


/**
 * //TERNARY OPERATORS
 * helps us write if statesments in a faster cleaner way
 *  ternary = composed of three parts
 * 
 * var_name = ASSIGNED var_name , conditional operators, ? //CODE TO RUN IF TRUE : CODE TO RUN IF FALSE
 *     E.G 
 *             new var_name = old_var_name >= value ? " not true" : " not false"
 * 
 * the ? is essential
 * 
 */

let body = document.querySelector("body");

let choice = "Dark";

choice === "Dark" ? body.classList.add("DarkMode"): null; //ternary operatior



let message = '';
let newMessage = message = ( 1 > 10 ) ? "condition is TRUE" : "condition is FALSE";
console.log(newMessage);

 let Time = "12:00";
 let greeting = Time === "12:00" ? "good morning" : "good night";
 console.log(greeting);



 

