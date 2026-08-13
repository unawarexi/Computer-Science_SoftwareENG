// string properties
/*
 1. This is different from string methods.
    * E.g., var_name.length // length is a string property.
 2. Useful for form validations.
*/

// string methods
/*
 1. String methods end with brackets "()" like function names.
    * E.g., (var_name.trim()) // removes whitespaces at the beginning and end of the string.
*/

// Examples of string methods
let str = "I am watching DevDreamer";

// 1. toUpperCase: Converts all characters to uppercase.
console.log(str.toUpperCase()); // "I AM WATCHING DEVDREAMER"

// 2. toLowerCase: Converts all characters to lowercase.
console.log(str.toLowerCase()); // "i am watching devdreamer"

// 3. charAt: Returns the character at the specified index.
console.log(str.charAt(2)); // "a"

// 4. indexOf: Returns the index of the first occurrence of a specified value.
console.log(str.indexOf("watching")); // 5

// 5. lastIndexOf: Returns the index of the last occurrence of a specified value.
console.log(str.lastIndexOf("a")); // 2

// 6. slice: Extracts a section of a string and returns it as a new string.
console.log(str.slice(5, 14)); // "watching"

// 7. substring: Similar to slice but does not accept negative indices.
console.log(str.substring(2, 10)); // "am watch"

// 8. trim: Removes whitespace from both ends of a string.
console.log(str.trim()); // "I am watching DevDreamer"

// 9. split: Splits a string into an array of substrings.
console.log(str.split(" ")); // ["I", "am", "watching", "DevDreamer"]

// 10. concat: Joins two or more strings and returns a new string.
console.log(str.concat(" is great!")); // "I am watching DevDreamer is great!"

// 11. repeat: Returns a new string with a specified number of copies of the original string.
console.log("Hi! ".repeat(3)); // "Hi! Hi! Hi! "

// 12. includes: Checks if a string contains a specified value.
console.log(str.includes("watching")); // true

// 13. startsWith: Checks if a string starts with a specified value.
console.log(str.startsWith("I am")); // true

// 14. endsWith: Checks if a string ends with a specified value.
console.log(str.endsWith("Dreamer")); // true

// 15. match: Searches a string for a match against a regular expression.
console.log(str.match(/watching/)); // ["watching"]

// 16. replace: Replaces a specified value with another value in a string.
console.log(str.replace("watching", "learning")); // "I am learning DevDreamer"

// 17. search: Tests for a match in a string and returns the index of the match.
console.log(str.search("am")); // 2

// 18. valueOf: Returns the primitive value of a string object.
console.log(str.valueOf()); // "I am watching DevDreamer"

// 19. localeCompare: Compares two strings in the current locale.
console.log("apple".localeCompare("banana")); // -1

// 20. fromCharCode: Converts Unicode values to characters.
console.log(String.fromCharCode(65, 66, 67)); // "ABC"

// 21. fixed: Returns a string that is a fixed-point notation representation.
console.log((1234567.89).toFixed(2)); // "1234567.89"

// 22. search: Returns the index of the first match of a regular expression.
console.log(str.search(/watching/)); // 5

// 23. toString: Returns the string representation of the specified object.
console.log((123).toString()); // "123"

// 24. at: Returns the character at the specified index (ES2022 feature).
console.log(str.at(0)); // "I"

// 25. padStart: Pads the current string with another string (repeated, if needed) until the resulting string reaches the given length.
console.log("5".padStart(2, "0")); // "05"

// 26. padEnd: Pads the current string with another string until the resulting string reaches the given length.
console.log("5".padEnd(2, "0")); // "50"

// 27. toLocaleUpperCase: Converts a string to uppercase, taking into account the host environment's current locale.
console.log("hello".toLocaleUpperCase("en-US")); // "HELLO"

// 28. toLocaleLowerCase: Converts a string to lowercase, taking into account the host environment's current locale.
console.log("HELLO".toLocaleLowerCase("en-US")); // "hello"

// 29. bold: Converts a string to bold text (deprecated).
console.log("Bold text".bold()); // "<b>Bold text</b>"

// 30. small: Converts a string to small text (deprecated).
console.log("Small text".small()); // "<small>Small text</small>"
