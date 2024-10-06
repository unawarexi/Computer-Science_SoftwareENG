// primitive datatypes

/*
1 strings === enclosed in a semicolon;
2 boolen === true / false statements
3 number === intergers
4 bigInt === used to handle very big number values, 
             add "n" to the end of the vals to turn into bigInt
5 null === has a value but a value of NOTHING
6 Symbol
7 undefined === this is when ypu haven't assinged any val
                to the var but you've deeclared it

note : use "typeof" to known thr type of variable

*/

// non - primitive

/*
1 they are simply objects
   * arrays
      1 a var with a value of diff. primitive dataypes
      2 use [] to write array
      3 use varName and index to access values in the array

   * functions
      1 use "function" then fn_name() to start
      {
        your code and logic comes here
      }
      2 invoke your fn_name outside the fn block of code

   * objects
      1. var = {
            key: value
        }               this is how to write and object
      2. "obj_name.key" thats how you get the vals inside and object\0 
      3. it's just like arrays but holds more values and uses {} not []
*/

let boy = "andrew" //string
let age = 15 //number;
let my; // undefined
let cash = 8874348794747834n; // bigInt
let sis = null // null

let me = "big";  
console.log(me == "big" ); // boolen returns true or false


let person = ['andrew', '15', true, 7, null ] // this is an array
console.log(person[1]); // use indexing to access values

function infor(){ // this is a function
    console.log(`information is life`);
    console.log(`${boy} is ${age}`);

};

infor(); // this is calling function or invoking

let individual = {
 /* names: this is a key */ 
    names: "andrew",
    age: 15,
    height: "6ft",               // use , to seperate
    netWorth: "$6000000",        // contains diff datatypes, 
    complexion: "dark",
    hair: "type4b",
    chubby: true,
}; // this is an object
console.log(individual.netWorth); // this how to access object values