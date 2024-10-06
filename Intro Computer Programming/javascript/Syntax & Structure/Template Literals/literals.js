/*
template literals includes the "BACKTICKS"  " `` " 

it includes "\n" for a new line 
      * this is usefyul when youre not use ${}

it includes ${var_name} 
   * you write this inside the backticks
   * to go to a new line using this just press enter to a new line

it used for concating strings together
 
*/

let man = "andrew";
let course = " javascript";
let channel = "devDreamer";

let info = `${man} is learning ${course} with ${channel}`;
console.log(info);