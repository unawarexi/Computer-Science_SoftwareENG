/*
 1  to use the date and time object we need to call it first
     * e.g var_name = " new date()"; // this is how to call;
     * then console and use var_name.mtds to manipulate
     * 
     * note: for javascript to understand  dates it needs to know 
     * the total number of elasped time in millisconds ( timestamp)
     * this stamp is since january 1st 1970
     * this is called unix / epoch time

 // THE SECOND METHOD TO DO THIS   ( using miliseconds)
    2  var_name = new date( // put the total number of millisecs here);
    *   search google for total number of millisecs

// THE 3RD METHOD 
   * follow saame declaration method 
   * use a string to assign the date and time in a params
   * in the new Date(); just like normal way without coding.

// the fourth method // using components
    * make sure your declaring and assining the new Date() this is a must
    * as params no ned to string it
    *    use i.e ( 1998. 11, 25, 14, 00, 0, 0)
    * the month and days uses indexing hence december == 11


// THE FIFTH METHOD (USING THE "GETS" FUNCTION)
   * after declaraing 
   * console.log(
   *    var_name.getTime() // this would display the total num of millisecs
   *    var_name.getmonth() // e. t. c
   *   )
   * 
   * the set methods set the date and time
   * 
   * this method is based on the users time zone
   *    we can get the UtC standard, theres inbuilt methods for it.
   * 
   * 
   *  NOTE: TO GET EVERYTHONG IN SPELLINGS INSTEAD OF NUMBERS
   *  .TOLOCALESTRING ('default', {month: 'long or short'})
   *     var_name.mtd (set to default. make object, then month:to display fmt)
 */

let currentDate = new Date(1680387344558);

console.log (
    currentDate
)

let currentDay = new Date();

console.log(
    currentDay.toLocaleString('default', {
        month: 'long',
        weekday: 'short',
    })
)