// theres 3 ways to this 
/*
1. using const
2. using let
3. using var

const doesnt allow you to change the value of the varaible
let allows you to change
var also allows you to
   * var would allow you to declare without assigning
   * same as let
   

 SYNTAX

 1. do not use an inbuilt fn name
 2 start with an alphabet, $ and _ , but not a number and spaces
     * but it can contain a num but not begin with one
 3 use camelcasing e.g camelCasing
 4. do not redeclare a varaible with same name
 5. dont write all varaibles in one line
      e.g 
           let andrew = "boy", gender = "male", height = "6ft"
             *instead do this 
           let andrew = "boy";
           let gender = "male";
           let height = "6ft";
6. var are case sensitive
7. to change the value of a var do not redclare it
     *instead write the same varname = newvalue

*/

let names = "andrew justice";
let height = "6ft";
let complexion = "dark";
let voice = "deep";
height = "7ft";

console.log(`${names} is a ${height} ${complexion} ${voice} voiced man`);


var man;
man = "andrew justice";
height = "8ft";
console.log(`${man} is ${height}`);

console.log(this) // the this prints the object methods. it auto sets to windows

