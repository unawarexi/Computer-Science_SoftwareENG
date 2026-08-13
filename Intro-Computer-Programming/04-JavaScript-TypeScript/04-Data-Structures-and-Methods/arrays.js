/**
 * OBJECT ARRAYS;
 *  It is and ordered list of values - represented by index
 *  it is contains any values
 *     strings, numbers, boolens, and even an array, functions
 *  arrays containing another array is multi-dimensional array
 *      1 it uses indexing too to access
 * 
 * NOTE: when you delete a value the value is remove but the indexing remains
 *       if use an existing index to  a new value the former val is completely replace
 *       to add a new val to the array you need to specify the indexing posititon
 */

//    let arr = ['body', 'man', 'vagina', 'height', 'love'];
//     arr[5] = 'hatred'; // adding new value
//     delete arr[3]; // deleting value but indexing remains
//     console.log(arr);

//     let arry = ['body', 'man', 'vagina', 'height', 'love', 10, true, 
//     ['peery', 'yung', 'tyler']]; // multi-dimensional array

//     console.log(`${arry[7][1]}`) // accessing multi-dimensional array


/*============================================================================* ARRAY METHODS
 * array property = "length";
 * array methods is difeerent from property
 */

let prop = ['body', 'man', 'vagina', 'height', 'love', 10, true, 
    ['peery', 'yung', 'tyler']];
let sec_arr = ['stop', 'thight', 'pastor'];


    //prop.length = 3; // display only the first 3 values
    //console.log(`${prop[prop.length -1]}`); //getting the last itrm in array

    /**====================================== METHODS =========================================== */
    // let reverse =  prop.reverse(); console.log(`${reverse}`) ; // prints in reverse 
    // let pops = prop.pop(); console.log(`${pops}`); // removes the last value
    // let sorts = prop.sort(); console.log(`${sorts}`); // sorts values in alphabetical order
    // let fills = prop.fill('filling'); console.log(`${fills}`); // changes all values at once to ...
    //  let joins = prop.join(''); console.log(`${joins}`); // jampack all values together
    // let tostrng = prop.toString(); console.log(`${tostrng}`); // removes all strings
    // let shifts = prop.shift(); console.log(`${shifts}`); // removes the first value
    // let pushs = prop.push('crime'); console.log(`${pushs}`); // adds value to the end and returns total index
    // let unshifts = prop.unshift(); console.log(`${unshifts}`); // adds to the begin of array
    // let concats = prop.concat(sec_arr); console.log(`${concats}`); // adds two or more arrays together
    // let splices = prop.splice(2, 1, 'greenlantern'); console.log(`${splices}`); console.log(`${prop}`);

    /*=============================================================* iterator arrays methods
     * they're 8 in number
     * they're mostly used for looping
    */


    //  function adding(prop){
    //     console.log(`${prop} + ${prop}`)        // foreach uses a function , puts the effect on every value respe...ly

    //  }
    //  let eachs = prop.forEach(adding); console.log(`${eachs}`);

