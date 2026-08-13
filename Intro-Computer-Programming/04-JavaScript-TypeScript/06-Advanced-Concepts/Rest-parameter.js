/**
 *  rest param is the opposite of spread opp
 * it bundles and pack values into non-primitives
 * used when we want our fun to be dynamic and when we're unsure values it can take
 * SYNTAX
 * "..." same as spread opp the diff is how we use it
 */


function restparam(...z) { // this is a rest param; bundles all values
    console.log(...z) // this is a spread opp; displays all the values

}

restparam('love', 'hate', 'anger', 'anxiety', 'depression') //unknown amount of values



function restpara(x, y, ...b) { // this is a rest param; 
    console.log(`the value of x is  ${x}`) // this is normal args
    console.log(`the value of y is  ${y}`) 
    console.log(b) // this contains the unsed arg-values and bundle it in an array === "rest-param"

}

restpara(1, 2, 'anger', 'anxiety', 'depression') // first 2 values goes in as args to x and y,
// the rest are bundled up in an array...; 
//do not use special fn "arguments" to access the remaining unsed values it''s outdated use rest-param