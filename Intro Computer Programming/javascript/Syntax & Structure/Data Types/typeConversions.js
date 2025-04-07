// Type Conversion Examples in JavaScript

/** 
 * STRING CONVERSIONS 
 * Methods to convert other types to string.
 */

// Using String() method
let num = 123;
let numToStr = String(num);  // "123"

// Using .toString() method
let bool = true;
let boolToStr = bool.toString();  // "true"

// Implicit type conversion (coercion)
let implicitStr = 123 + "";  // "123"


/**
 * NUMBER CONVERSIONS 
 * Methods to convert other types to number.
 */

// Using Number() method
let str = "456";
let strToNum = Number(str);  // 456

// Parsing integers and floats
let parsedInt = parseInt("123abc");  // 123
let parsedFloat = parseFloat("123.45abc");  // 123.45

// Implicit type conversion (coercion)
let implicitNum = +"789";  // 789

// Using unary plus for conversion
let str1 = "5";
let strToNumUnary = +str1;  // 5


/**
 * BOOLEAN CONVERSIONS 
 * Methods to convert other types to boolean.
 */

// Using Boolean() method
let falsyVal = 0;
let falsyToBool = Boolean(falsyVal);  // false

// Implicit conversion in conditionals
let emptyStr = "";
if (emptyStr) {
  console.log("This won't log because emptyStr is falsy");
} else {
  console.log("Empty string is falsy");  // This will log
}

// Truthy and falsy values
let truthyVal = "hello";
let truthyToBool = Boolean(truthyVal);  // true


/**
 * CONVERTING TO JSON STRING 
 * Methods to convert objects to JSON strings and vice versa.
 */

// Convert object to JSON string
let person = { name: "Alice", age: 25 };
let objToJson = JSON.stringify(person);  // '{"name":"Alice","age":25}'

// Parse JSON string to object
let jsonStr = '{"name":"Bob","age":30}';
let jsonToObj = JSON.parse(jsonStr);  // { name: "Bob", age: 30 }


/**
 * SPECIAL CASES 
 * Edge cases in type conversion.
 */

// Converting undefined and null
let undef = undefined;
let undefToStr = String(undef);  // "undefined"
let nullToNum = Number(null);  // 0

// Converting arrays
let arr = [1, 2, 3];
let arrToStr = String(arr);  // "1,2,3"
let arrToNum = Number(arr);  // NaN

// Converting booleans to numbers
let boolToNumTrue = Number(true);  // 1
let boolToNumFalse = Number(false);  // 0

