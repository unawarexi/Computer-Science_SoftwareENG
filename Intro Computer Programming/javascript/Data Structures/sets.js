/**
 * they're similar to arrays 
 *  thre is no room for duplicate
 *  collection of vals where each vals can appear once
 *  identification and deleting vals are easier with sets
 *  you can assign an array to a set
 *  start with 
 *        var name_ = new Set()
 *            varname.add(' value ') .add (' val ') // for adding multiple  in a single line
 */

let vals = new Set();
    vals.add('cry');
    vals.add('jump'),
    vals.add('begin'),
    vals.add('magnum').add('ashawo').add('lover')

    vals.delete('magnum') // to delete in sets

    let check = vals.has('jump') // check if the set contains spec. values
    console.log(vals)
    console.log(check)

let color = ['red', 'blue', 'yellow', 'green']
let another = new Set(color);          // setting an array to a set
console.log(another)

let mortal = new Set();
mortal.add('reptilia').add('lui-kang').add('scorpio').add('sub-zero');

// using loops to iterate
 for (let charac of mortal){
    console.log(`there are ${charac}`)
 }

 // or you can use functions and methods to iterate too

 function added (mortal){
    console.log(` they are ${mortal}`)
 }

 let eachs = mortal.forEach(added);
 console.log(eachs);

/*============================================================ WEAKSETS*
 * they contain only non-primitive datatype
 *   
 * NOTE: sets still produces the value of the formal calls
 *       even if the var_name has been reassigned another value
 *       as long it still present in the code to avoid GARBAGE COLLECTION
 * 
 *  has delete clear has //set properties
 */


let nums = [1, 2, 3, 4, 5];
let weaksets = new WeakSet();
weaksets.add(nums);

nums = null;     // even after changing value of nums it print the former values along side
console.log(nums); 

console.log(weaksets); // as long i still have this in the code