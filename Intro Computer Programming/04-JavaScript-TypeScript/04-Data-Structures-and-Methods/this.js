/**THIS
 *  ASSOOCIATED with object oreinted programming
 *  ======================================= ways to be defined
 *   1 the global obj
 *   2 method within the obj
 *   3 constructor on a fn or class
 *   4 dom event handler
 * 
 *  it is mainly used in method 2
 *  this is also the object_name / function! it's specified to
 */

let game = {
    name : "andrew chukwuweike",
    hobby : "travelling",
    year : 1991,
    release : function (){
        console.log(`this game was realeased in ${this.year}`)
    } // in order to reference or access and obj key_value use "this" = game.year too
}

game.release(); 

let book = {
    title : "murder scene",
    author : " c.j andrew",
    
    info() { // our own made method - method with obj using "this"
        console.log(`${this.title} by ${this.author}`);
    }
}

book.info();

/*=========================================== call, apply and bind*
 * we use the "call" to control what this refers to
 * used when we want to pass additional arguments that's mignt not 
 *            existing on the main data struct but in the function this is refer to.
 *  it doesn't affect the function itself in a call back
 * only used once
 *  
 * ====== USING APLYING
 * same as call
 * but we use an "array" [] to enclose additional args value in the call backs
 * add the new args as params 
 * it doesn't affect the function itself in a call back too
 * only used once too
 * 
 * ========== USING BIND
 *  the bind enables us to use a var as the call back 
 *        by linking the function to it
 *  we can use it multiple times just like the function itself
 * it doesn't change it will always refer to the object it's bind to
 * you don;t need []
 * 
 *  
 * 
*/

let madame =  {
    madams : "orobor",
    height : "6ft",
}

function chara (){
    console.log(`${this.madams} is ${this.height} tall`);
}

chara.call(madame); // using call method to control this referrence



// USING THE APPLY TO CONTROL THIS REFERENCE
let boss =  {
    namess : " kenubia",
    height: "5.9ft"
}
 
function oga(children, married){
    console.log(
        `${this.namess} is a very good man though he is ${this.height}
        he has 3 ${children} and one ${married}`

    );
}

oga.apply(boss, ["kids", "wife"]);


//==============    USING BIND TO CONTROL THIS REFERENCE

const bossinfo = oga.bind(boss, "children", "queen"); // diff is we used "bind" and assigned it to var_name
bossinfo(); // used the var_name as callback;
