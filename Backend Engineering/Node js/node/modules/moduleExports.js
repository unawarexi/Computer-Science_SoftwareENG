/**
 * the exports in node js modules helps to move functions to other files
 * you can make use of "module.exports"
 *
 * they're three ways of exports know as "import an export patterns"
 * @param {*} a
 * @param {*} b
 * @returns sum
 */

// by  assigning the function name to the "export function" using "="
const addNumbers = (a, b) => {
  return a + b;
};

// module.exports = addNumbers; // exports to index.js

// const sum = addNumbers(2, 3);
// console.log(sum)




// 2. by assignig "module.exports" directly without "const" or names
module.exports = (a, b) => {
    return a-b
};




// 3. by assigning function names as object properties to export
const greetings1 = (name) => {
  return "hello you look awesome", name;
};
const greetings2 = (name) => {
  return "hello you look awesome", name;
};

module.exports = {
  // allows to export multiple functions as an object
  greetings1,
  greetings2,
  addNumbers, // this is coming from the first one
};


 /**
  * NOTE
  * you cannot have more than one "module.exports" declaration IN YOUR MODULE file
 */