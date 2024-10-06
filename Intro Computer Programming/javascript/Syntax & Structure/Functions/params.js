/**     PARAMETERS AND ARGUMENTS
 *  they are placeholder values we want to work on / with in a function
 *  they are also placeholder for values we havn't initialized more like vars
 *   you can set multiple params seperate with commas
 *   params are like var declared inside the function () 
 *     
 * 
 *  ARGUMENTS
 *  the values passed while invoking the function is known as arguments
 *    e.g call of duty, below is an argument
 *  you can set multiple args seperate with commas
 *  they are array-like object and use indexing too
 * 
 * NOTE : make sure your args is same amount to params
 *        if args is not equal to params automatically the missing param
 *         without args is set to "undefined or NaN"
 * 
 *        2. if they are too many args to params the function ignores the rest args
 *         you can acess the remain args by use their indexing 
 *         and "arguments" in the console.log(arguments)
 * 
 *       3. the "argument"property is out of date; because you can't easily manupulate it using methods
 *           use the "REST" instead; you can using array methods, cuz rest returns it in an array
 * 
 * 
 * 
 */

 function FavGame (game){ // game serves as a placholder for new values dynamically
    console.log(`my fave game is ${game}`)
 }

 FavGame('call of duty'); // call of duty is the value to the empty param 'game' for this function
 FavGame('God of war');       /* as you can see "game param" aaccepts new args for the function*/
 FavGame('FreeFire'); 



 function nums(num1, num2) { // multiple params 
    console.log(`${num1} is bigger than ${num2}`) 
    
 }
  nums(10, 7); // multiple args




  function add (num3, num4){
    console.log(arguments[3, 4]) // special property to list all args in the function in array-like manner
                        //using indexing to access args

  }

  add(1,2,3,4,5) //excess args compared to params





  function man (big){
    if ( big === undefined ){ // if args is empty do this
        console.log(`please enter a value : `)
    } else {
        console.log(`begin game ${big}: `) // if args is present do this
    }
  }

  man("andrew");


  /*================================================================== RETURN VALUE*
   * the "return" key word comes last in the function block
   * if the functions hits the return line automatically it exits
   * you can use multiple return key word in thier respective code block
   *     not immediately after each other else the computer shows the first one only
   * 
   * 
   */

    let login = function( password ){
        if ( password === 'programmer' ){
            return (`successfully logged in`);

        } else {
            return (`login attempt failed`); //multiple return statement in unique code blocks
        }
        
    } 

    let result = login('programmer');
    console.log(result);

    function FavNum(num7){
        return num7;
    }

    let mynum = FavNum(7);
    console.log(`my fav num is ${mynum}`);