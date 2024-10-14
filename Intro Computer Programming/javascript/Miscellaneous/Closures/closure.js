/**
 *  it uses the concept of scoping
 *  it is known as nested function
 *  the inner function should be called inside the outer function body
 *  the inner function can access values in the outer but outer can't
 *
 *  it depends on lexical envirenments
 *   1 environment record == the main object it's in
 *   2 reference to outer lexical environ
 *
 *  ================== what are closures? =================
 * they're inner functions
 *  they're bundled together with the lexical environ : datatypes
 *  they're declared inside the datatype
 *    in other words the inner functions contains the var of the outer function
 */

const crust = "crust";
function earth() {
  let center = "mantle";

  function message() {
    let deep = "core";

    console.log(`the earth is made up of the ${crust} ${center} and ${deep}`);
  }

  message();
}
earth();
