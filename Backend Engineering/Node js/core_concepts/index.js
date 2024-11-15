/**
 * Running a Node.js Script
 * You can create a basic JavaScript file and run it using Node.js.
 * Create a new file named app.js or index.js with the following content:
 * open your terminal path to file and run "node index.js"
*/

console.log("Hello, Node.js!");
//Run the script in your terminal:


/** ============== require and exports
 *  use the "require" method to call modules in your file
 */

const sum = require("./modules/moduleExports"); // import from modeuleExports
const totalNumber = sum(3, 2);
console.log(totalNumber)





// =============== export differences Importing the exported module
const hero = require('./moduleA');

console.log(hero.name);  // Prints: Bruce Wayne
console.log(hero.alias); // Prints: Batman
