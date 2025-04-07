/**
 * every module in node js gets wrapped in an IIFE before loaded
 * it helps keep top level variables scoped to the module rather than global object
 * 
 * it contains 5 parameters that are essential for runnnig the modules
 *  exports, require, module,  __dirname, __filename
 */


(function (message) {
    const superHero = "BatMan";
    console.log(`${message} ${superHero}`)
})("hello");


(function (message) {
    const superHero = "superMan";
    console.log(`${message} ${superHero}`)
})("hey");