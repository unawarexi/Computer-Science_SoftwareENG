// destructuring.js

/**
 * ES6 Destructuring Assignment
 * Destructuring allows unpacking values from arrays or properties from objects 
 * into distinct variables. This feature helps to quickly assign object keys and 
 * values as variables and works for non-primitive data types, including nested structures.
 * 
 * Key Points:
 * - Works primarily for properties in objects.
 * - It allows renaming keys during assignment.
 * - Does not affect the original object or array.
 * - Can skip values by using commas with spaces in arrays.
 * 
 * Usage:
 * 1. For Objects:
 *    Syntax: let { key1, key2 } = objectName;
 *    Example: let { objKey1, objKey2 } = mainObj;
 *
 * 2. For Arrays:
 *    Syntax: let [var1, var2] = arrayName;
 *    Example: let [var1, var2] = mainArray; // Automatically assigns values
 */

//================= FOR OBJECT AND NESTED OBJECTS
let cars = {
    mercedes: "g-wagon",
    bmw: "m8-grandeCoupe",
    lambo: "urus_performante",
    jeep: "trackhawk",
    others: {
        jaguar: "f8",
        ferrari: "Super_Fast",
        McLaren: "765",
    },
};

// Destructuring the cars object
let {
    mercedes,
    bmw,
    lambo: Lamborghini, // Renaming 'lambo' to 'Lamborghini'
    jeep,
    others: { jaguar, ferrari, McLaren }, // Nested destructuring
} = cars;

console.log(
    mercedes, // Output: "g-wagon"
    bmw,      // Output: "m8-grandeCoupe"
    Lamborghini, // Output: "urus_performante"
    jeep,     // Output: "trackhawk"
    jaguar,   // Output: "f8"
    ferrari,  // Output: "Super_Fast"
    McLaren   // Output: "765"
);

//=============== FOR ARRAY AND NESTED ARRAY
let boys = [
    "king_von",
    "64th cleveland",
    "drill rapper",
    28,
    ["muwop", "lil_durk", "quando"], // Nested array
];

// Destructuring the boys array
let [names, address, occupation, age, [right_hand, brother, best_opp]] = boys;

console.log(
    names,      // Output: "king_von"
    address,    // Output: "64th cleveland"
    occupation, // Output: "drill rapper"
    age,        // Output: 28
    right_hand, // Output: "muwop"
    brother,    // Output: "lil_durk"
    best_opp    // Output: "quando"
);

//=============== USING OTHER PROPERTIES WITH DESTRUCTURING
let { length } = "andrew-C.J"; // Destructuring string to get its length property
console.log(length); // Output: 10 (length of the string)
