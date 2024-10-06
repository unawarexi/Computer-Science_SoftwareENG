/** FUNCTIONS
 *  functions can be stored in a var, 
 *  can contain values by decelaring vars in them
 *  they can be created in literals
 * whatever an object datatype does a function can
 *  reusable block of code
 *  any var in the fn is a local var but outside is global
 * 
 *  NOTE : the diff btw and object and a function is that we can invoke a function
 *         also remember a function is also an object datatype (non - primitive);
 *         you can call functions dynamically using events.
 * 
 * =============== creating a function
 *  function declaration ====== "function my_function()"
 *  arrow functions ======= es6 update
 *  function constructors
 *  generator functions ========== can be exited and re-entered
 * 
 *  NOTE : THERE'S AN ANONYMOUS FUNCTION; meaning function without a name
 *         used mostly during addeventlisterner and handling dom
 *  
 */

 function my_function(){ // creating function by declaring
    console.log(`Andrew is a billionaire`)

    let andrew = 'male';   // local variable
    let billion = 20000000000
    console.log(`andrew ${andrew} is worth $${billion}`)

 }

 my_function(); // invoking / calling function the " () " is important



//  let btn = document.querySelector('.btn')

//  btn.addEventListener("click", function () { //anonymous fun...
//     console.log(`sonic`);
//  });


 /*================================================================== FUNCTION EXPRESSION *
  * they're functions
  * created inside an expression or inside another syntax
  *  assining fns to vars is anonymous fns and the var_name is what we call 
  *             var_name(); //since fn is anonymous
  * 
  * you can use a new var to invoke the exp fn
  * 
  *  NOTE: the diffference btw fn exp... and decla... is 
  *        1 fnname is compulsory in declaration but not in expressions
  *        2 fn_decl... can be invoke before writing the codes but exp_fns can't
  */

  let ruler = 'jennifer'; // global variable

     let brother = function (){
           console.log(`this would be bad if ${ruler} rules`);
     };

     let chairman = brother; // assing to new var_name to invoke same funt...
    
    //  brother(); old var name
   chairman(); // invoking new var_name

   

   /*================================================================================= ARROW FUNCTIONS*
    *  They are always anonymous
    * provides a shorter way to write "FUNCTION EXPRESSIONS"
    * from the es6 update 2015
    

    * SYNTAX
    *  var_name = (multi-params) => {}  
    *  for single param no need for the (), just write the param name there then arrow
    *  for single line statement remove the {} and just put it in same line
    *  do not use to access object props stick to regulalr exp functions
    * use it when it's inside an exp_fn in an object 
    *    // it ppoints to the global window object not main object
    * used inside an inbuilt method too
    * 
    * 
    * just take it as a weaker function used for specific task not major
    */

   const babies = () => { //normal arrow function
      console.log(`emmanuel`)
   }

   babies(); // shorter method below


   const baddie = () => "Amber" ;// shorter normal arrow fun...

   console.log(baddie()) 



   const baby = (a, b) => { //no need to write out "function"
      console.log(a + b)
   }

   baby(2, 3);



   const bad = FirstNames => { // single param "FIRSTNAMES" remove brackets
      console.log(`his Firstname is ${FirstNames}`)
   }

   bad("FredSwaniker");




   const musicians = {
      artist : "Kanye-West",
      genre : "Hip-hop",
      kids : "5-kids",
      height : "6ft",
      Moreinfo() {
         console.log(`${this.artist} is having quality time with his ${this.kids}`)


      },

      // passinfo: () => {
      //    console.log(`${this.genre} is great cuz ${this.height} man`)
      // } 

      // this would not work use a normaal function exp.. for objects
   }
musicians.Moreinfo();
// musicians.passinfo();


  
const games = {
   title : "sonic hedge-Hog",
   related : ['born of hedge', 'sonic 3', 'sonic & knuckles'],
   year : 1991,
   showrelated : function () { // main function
      //method "foreach" looping inside "related" property
      this.related.forEach((relatedgames) => { //arrow function inside a method
         console.log(`the return of ${this.title} - ${relatedgames}`)
      }
   )}
}

games.showrelated();