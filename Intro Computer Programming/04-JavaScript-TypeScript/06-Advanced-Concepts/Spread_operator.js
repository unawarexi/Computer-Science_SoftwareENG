/**
 * used for non-primitive datatypes
 * allows it to be unpacked
 * allows it to be seprated into individual values
 * allows to duplicate arrays and not alter the main one
 * SYNTAX
 *  "..." three dots == spread operator
 * 
 *  Arrays object and function
 */

//============================================================== USING ARRAYS

let nums = [1, 2, 3]
let letters = ['a', 'b', 'c']

let myArray = [...nums, ...letters, 4, 5, 6]; // it merges other arrays and adds 456 to them
// it also does not display them in nested arrays

console.log(`${myArray}`);


let woman = [
    { id : 1, name: "betty"},
    
    { id : 2, name: "beauty"},
    
    { id : 3, name: "beatrice"},
    
];

const secondArray = woman; //duplicating datastruct from main
console.log(secondArray);

let updatedArray = {id : 4, name: "kostian"}
let newArray = [...woman,updatedArray];

console.log(newArray);

//======================================================================= USING OBJECTS
const book = {
    title : "ojo and his friend",
    author : "unaware",
    release : "20/10/1999",
    relatedBooks : {
        title1 : "big_boyz",
        title2 : "chapman",
        title3 : "revenge",
    }
}

const updatedBook = {
    ...book,
    price: 300000,
    relatedBooks: {
        ...book.relatedBooks, //accessing relatedbooks from book object
            title4 : "glory",
    
    
    }
    
}

console.log(updatedBook)
console.log(book)

//=============================================================== USING FUNCTION

function sum(a, b, c){
    console.log(a + b + c)
}

const numbers = [3, 5, 6];

sum(...numbers)
