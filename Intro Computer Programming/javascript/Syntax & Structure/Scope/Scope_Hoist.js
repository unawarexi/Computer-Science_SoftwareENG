// scope.js

/** 
 * SCOPE
 * Scope refers to where a variable is declared and from where it can be accessed.
 * 
 * There are two main types of scope:
 * 
 * 1. Local Scope: Variables declared inside a function or block (data structure) 
 *    cannot be used outside of that specific code block.
 * 2. Global Scope: Variables declared outside of any function can be accessed anywhere in the code.
 * 
 * When using local scope, you can redeclare a variable with the same name, 
 * but it must be in a different code block.
 * 
 * NOTE: It is important to use local scope more than global scope. 
 * Avoid using `var` as it is only locally scoped in a function.
 */

// Example of Local Scope
function localScopeExample() {
    let localVar = "I am local"; // local variable
    console.log(localVar);        // Output: "I am local"
}

localScopeExample();
// console.log(localVar); // Uncaught ReferenceError: localVar is not defined

// Example of Global Scope
let globalVar = "I am global"; // global variable

function globalScopeExample() {
    console.log(globalVar);      // Output: "I am global"
}

globalScopeExample();

// Redeclaring Local Variable
function redeclareLocalVar() {
    let localVar = "I am local 1";
    {
        let localVar = "I am local 2"; // different block
        console.log(localVar);          // Output: "I am local 2"
    }
    console.log(localVar);              // Output: "I am local 1"
}

redeclareLocalVar();

/*============================================================== HOISTING */
/**
 * HOISTING refers to the default behavior in JavaScript where variable and function 
 * declarations are moved to the top of their containing scope during compilation.
 * 
 * Important points about hoisting:
 * - Variables declared with `var` are hoisted, but not their assignments.
 * - Function declarations are fully hoisted, meaning you can call the function 
 *   before its definition in the code.
 * - Hoisting does not affect assignment/initialization; only declarations are hoisted.
 */

// Example of Hoisting with Functions
hoistedFunction(); // Output: "This function is hoisted!"

function hoistedFunction() {
    console.log("This function is hoisted!");
}

// Example of Hoisting with Variables
console.log(hoistedVar); // Output: undefined (due to hoisting)
var hoistedVar = "I am hoisted";

// console.log(hoistedVar); // Output: "I am hoisted"
