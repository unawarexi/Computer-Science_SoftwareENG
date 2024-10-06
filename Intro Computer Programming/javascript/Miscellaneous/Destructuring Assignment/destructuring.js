/**
 *  new es6 update
 *  quickly helps us assign object keys as a var
 * works for non-primitive datatype, nested datastructs too
 * used mainly for properties;
 * 
 * //============ FOR OBJECTS 
 *  let {}
 * e.g let {obj_keys, obj_keys} = main obj_name
 * 
 * you can change the key name while in the var
 *          e.g let {obj_keys, obj_keys : newKey_name} = main obj_name
 * 
 * //=========== FOR ARRAYS
 * let []
 * auto assign var_name to the values in the OG array
 * e.g [var_name, var_name]= main array var_name // these var_names auto assign to each values in the main array
 * 
 * 
 * 
 * 
 * NOTE: it doesn't affect the main object
 *       if you want to skip any value just give space with commas for arrays
 * 
 * 
 * 
 */

//================= FOR OBJECT AND NESTED OBJECETS
let cars = {
    mercedes: "g-wagon",
    bmw: "m8-grandeCoupe",
    lambo: "urus_performante",
    jeep: "trackhawk",
    others: {

        jaguar: "f8",
        ferrari: "Super_Fast",
        McLaren: "765"
    }

};

let { 
    mercedes, bmw, lambo: Lamborghini, jeep, 
     others:{

        jaguar, 
        ferrari, 
        McLaren
    },

} = cars // changed lambo to fullName

console.log( 
    mercedes,bmw,Lamborghini,jeep, 

            jaguar, 
            ferrari, 
            McLaren
); // make sure you use the new_keyName here


//=============== FOR ARRAY AND NESTED ARRAY

let boys = [
    "king_von",
    "64th cleveland",
    "drill rapper",
    28,
    ["muwop", "lil_durk", "quando"]
];

let [
    names, address, occupation, age,[right_hand, brother, best_opp]

] = boys;

console.log(
    names, address, occupation, age,
    right_hand, brother, best_opp

);

//===============   USING OTHER PROPERTIES WITH DESTRUCTURING
let { length } = "andrew-C.J";
console.log(length);