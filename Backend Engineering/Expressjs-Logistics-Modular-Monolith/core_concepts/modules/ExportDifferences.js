/**============= MODULES.EXPORTS  VS  EXPORTS 
 * It is advisable to use "module.exports" instead of just "exports"
 * because `exports` is simply a reference to `module.exports`.
 * 
 * When you use `exports`, you’re working with an alias or a shortcut that points to the same object as `module.exports`. 
 * However, if you reassign `exports`, it no longer points to `module.exports`, breaking the connection between the two.
 * 
 * To understand this better, consider the following analogy with objects:
 * 
 * We will demonstrate how two objects referencing the same memory location can affect each other, 
 * and how reassignment causes them to no longer share the same reference.
 */

// The first object `object1`
const object1 = {
    name: "Bruce Wayne"
};

// Here, `object2` is simply a reference to `object1`.
// They both point to the same object in memory.
const object2 = object1;


/**
 * Changing the value of `name` in `object2` also changes `object1`
 * because both `object1` and `object2` reference the same memory location. 
 */
object2.name = "Clark Kent"; // Now, `object1.name` is also "Clark Kent".
console.log(object1.name); // Prints "Clark Kent"

/**
 * The problem arises when you try to reassign `object2`.
 * Reassigning `object2` breaks its reference to `object1` and creates a new object.
 * This is similar to what happens when you try to reassign `exports`—it breaks the connection with `module.exports`.
 */

// This would throw an error in strict mode (or cause issues in other contexts)
// because `object2` was already declared with `const`, and reassignment would alter its reference.
let object2 = {
    name: "Clark Kent"
};  // Throws an error, or breaks the reference in non-strict mode




// Defining an object that we want to export
const superhero = {
    name: "Bruce Wayne",
    alias: "Batman"
};

// Exporting the object using module.exports
module.exports = superhero;


// Defining properties on exports (a reference to module.exports)
exports.name = "Clark Kent";
exports.alias = "Superman";
