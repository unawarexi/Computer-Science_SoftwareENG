/**
 * similar to objects
 *  allow  keys of anytype
 *  start with
 *    var_name = new map();
 *       var_name.set( key dataype, value)
 *  new var = oldvar.prop(key) // to get spec values stored
 * 
 *  set get delete // properties
 * 
 * 
 *  NOTE: the differrence btw maps and objects is that 
 *        1 objects converts keys to strings and map don't
 */

let game = new Map();

game.set( 'Name', 'andrew chukuwueike');
game.set(  10, 'times this is ten thousnad');  // allows differ.. keys, 
game.set( true, 'boolen');

let gamers = game.get(10); // to get spec val
let gamerss = game.delete(true);  // delete

console.log(game);
console.log(gamerss);

let girls = new Map();
 girls.set('ayu', 'japan')
 girls.set('lopez', 'USA')
 girls.set('roland', 'brazil')
 girls.set('chioma', 'nigeria')

 for ( let [gs, gf] of girls.entries()){
    console.log(`${gs} is from ${gf} im surprised`);
 }

/** ===================================== MAP ITERATION 
 * // USING KEYS
 * 
 * // USING VALUES
 * 
 * // USING ENTRIES 
 * 
 *  these are all inbuilt funtions
 */


for (let x of game.keys()){
    console.log(`${x}`);  // this gets the keys
}

for ( let j of game.values()){
    console.log(`${j}`); // gets the values
}

for (let [k, v] of game.entries()){
    console.log(`i did not know ${k} was ${v}`); // gets both 
}

/*================================================ WEAK MAPS*
 * for non-primitive (objects)
 * does not support iteration
 */

let offer = new WeakMap();

let girlies = ['ayu', 'choima', 'davido', 'king'];
let newest = offer.set(girlies);

console.log(`${girlies}`)
