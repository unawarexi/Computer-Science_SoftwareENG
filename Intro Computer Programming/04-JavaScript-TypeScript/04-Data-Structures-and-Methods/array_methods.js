// Array properties
/*
 1. Arrays are special types of objects that hold multiple values.
 2. They can store different types of data (e.g., numbers, strings, objects).
*/

// Array methods
/*
 1. Array methods end with brackets "()" like function names.
    * E.g., (array_name.push(value)) // adds an element to the end of the array.
*/

// Examples of array methods
let fruits = ["apple", "banana", "orange"];

// 1. push: Adds one or more elements to the end of an array and returns the new length.
fruits.push("mango");
console.log(fruits); // ["apple", "banana", "orange", "mango"]

// 2. pop: Removes the last element from an array and returns that element.
let lastFruit = fruits.pop();
console.log(lastFruit); // "mango"

// 3. shift: Removes the first element from an array and returns that element.
let firstFruit = fruits.shift();
console.log(firstFruit); // "apple"

// 4. unshift: Adds one or more elements to the beginning of an array and returns the new length.
fruits.unshift("grape");
console.log(fruits); // ["grape", "banana", "orange"]

// 5. concat: Merges two or more arrays and returns a new array.
let moreFruits = fruits.concat(["kiwi", "pear"]);
console.log(moreFruits); // ["grape", "banana", "orange", "kiwi", "pear"]

// 6. slice: Returns a shallow copy of a portion of an array into a new array.
console.log(fruits.slice(1, 3)); // ["banana", "orange"]

// 7. splice: Changes the contents of an array by removing or replacing existing elements.
fruits.splice(1, 1, "strawberry");
console.log(fruits); // ["grape", "strawberry", "orange"]

// 8. indexOf: Returns the first index at which a given element can be found.
console.log(fruits.indexOf("orange")); // 2

// 9. lastIndexOf: Returns the last index at which a given element can be found.
console.log(fruits.lastIndexOf("banana")); // -1 (not found)

// 10. forEach: Executes a provided function once for each array element.
fruits.forEach((fruit) => console.log(fruit)); // logs each fruit

// 11. map: Creates a new array with the results of calling a provided function on every element.
let upperFruits = fruits.map((fruit) => fruit.toUpperCase());
console.log(upperFruits); // ["GRAPE", "STRAWBERRY", "ORANGE"]

// 12. filter: Creates a new array with all elements that pass the test implemented by the provided function.
let filteredFruits = fruits.filter((fruit) => fruit.includes("e"));
console.log(filteredFruits); // ["grape", "orange"]

// 13. reduce: Executes a reducer function on each element of the array, resulting in a single output value.
let totalLength = fruits.reduce((acc, fruit) => acc + fruit.length, 0);
console.log(totalLength); // Total length of all fruit names

// 14. find: Returns the value of the first element that satisfies the provided testing function.
let foundFruit = fruits.find((fruit) => fruit.startsWith("s"));
console.log(foundFruit); // "strawberry"

// 15. findIndex: Returns the index of the first element that satisfies the provided testing function.
let foundIndex = fruits.findIndex((fruit) => fruit.startsWith("s"));
console.log(foundIndex); // 1

// 16. includes: Determines whether an array includes a certain value among its entries.
console.log(fruits.includes("banana")); // false

// 17. every: Tests whether all elements in the array pass the test implemented by the provided function.
console.log(fruits.every((fruit) => fruit.length > 4)); // false

// 18. some: Tests whether at least one element in the array passes the test implemented by the provided function.
console.log(fruits.some((fruit) => fruit.length > 5)); // true

// 19. sort: Sorts the elements of an array in place and returns the sorted array.
console.log(fruits.sort()); // ["grape", "orange", "strawberry"]

// 20. reverse: Reverses the order of the elements of an array in place.
console.log(fruits.reverse()); // ["strawberry", "orange", "grape"]

// 21. join: Joins all elements of an array into a string.
console.log(fruits.join(", ")); // "strawberry, orange, grape"

// 22. fill: Fills all the elements of an array from a start index to an end index with a static value.
let filledArray = new Array(3).fill("empty");
console.log(filledArray); // ["empty", "empty", "empty"]

// 23. flat: Creates a new array with all sub-array elements concatenated into it recursively up to the specified depth.
let nestedArray = [1, [2, [3, 4]]];
console.log(nestedArray.flat(2)); // [1, 2, 3, 4]

// 24. flatMap: First maps each element using a mapping function, then flattens the result into a new array.
let numbers = [1, 2, 3];
let flattened = numbers.flatMap((n) => [n, n * 2]);
console.log(flattened); // [1, 2, 2, 4, 3, 6]

// 25. toString: Converts an array to a string, using a comma as the default separator.
console.log(fruits.toString()); // "strawberry,orange,grape"

// 26. copyWithin: Shallow copies part of an array to another location in the same array.
let arrayCopy = [1, 2, 3, 4, 5];
arrayCopy.copyWithin(0, 3);
console.log(arrayCopy); // [4, 5, 3, 4, 5]

// 27. entries: Returns a new Array Iterator object that contains the key/value pairs for each index in the array.
let entries = fruits.entries();
console.log(entries.next().value); // [0, "strawberry"]

// 28. keys: Returns a new Array Iterator object that contains the keys for each index in the array.
let keys = fruits.keys();
console.log(keys.next().value); // 0

// 29. values: Returns a new Array Iterator object that contains the values for each index in the array.
let values = fruits.values();
console.log(values.next().value); // "strawberry"

// 30. from: Creates a new, shallow-copied Array instance from an array-like or iterable object.
let strArray = Array.from("Hello");
console.log(strArray); // ["H", "e", "l", "l", "o"]
