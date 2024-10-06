/**
 * // FOR LOOPS 
 *  used for repetitive a fixed number of times 
 * syntax 
 *    1 initializing
 *    2 condition
 *    3 and increment 
 * 
 *  for (initializer; [condition], [increment]){      
 *          // code comes in here 
 *         }                            the initializer is activated first
                                                     as long as the condititon is true the code block would run
                                                              the increment/final expression comes last 
 * 
 */


for (let i = 0; i <= 10; i++){
    console.log(i)
};

const characters = ['andrew', 'chukwuweike', 'chindeu', 'justice'];
// let paral = document.querySelector('.p');
let info = `The characters are `; 


const coler = ['orange', 'purple', 'maroon', 'blue', 'green'];
let statement = `is my favourite color `;

for (let m = 0; m < coler.length; m++){
    if (m === 1){
        console.log (`${coler[1]}, ${statement}`)
    }
}


/*=======================================================================================*
 *  // FOR-IN LOOP
     use for enummerable object properties - 
        meaning obj props that can be changed when enumerable is true

  
 */ 

const dreamCar = {
    brand:'lamborghini',
    names: 'huracan',
    speed: '650MPH',
    color: 'white',
    weight: 100,
}                                                                                                                                                               

dreamCar.turbo = 'ghost_cylinder';
dreamCar.engine = 'v12 bi_turbo';    // this is to add extra obj_props
delete dreamCar.weight; // this to remove obj_prop

Object.defineProperty(dreamCar, 'brand', {
    configurable: true,
    enumerable: true,            // this helps you to make obj_prop visible or not
    value: "lamborghini",        
    writable: true,
});


for (cars in dreamCar){
    console.log(`${cars}: ${dreamCar[cars]}`)
};

const salaries = {
    peter: 55000,
    andrew: 300000,
    harvey: 150000
};

for (salary in salaries){
    let cash = `$${salaries[salary]}`;
    console.log(`${salary} earns ${cash} per year`)
};

/*======================================================================* FOR OF LOOP
 * new update from es6
 * use to loop of iterable data structs
 * arrays strings
 * use the break; to exit loop after setting true condition
 * 
 * 
 * NOTE THE DIFFERENCE BTW FOR IN AND FOR OF IS :
 *      1 for in is used for objects
 *      2 for of is used for normal data-structs
 * 
 */

  const beauty = ['purple', 'marron', 'gold', 'orange', 'green'];

  for (let beauties of beauty){
    if (beauties === 'orange'){
        break;

    } else {
        console.log(`${beauties}`);
    }
    
  };




/*==============================================================================* // WHILE LOOP
 * initialize first
 *  while ( condition comes here)
 * increment is outside bottom in the curly braces
 *        E.g
 *             var_name
 *                   while (condition){
 *                     i++
 *             }
 * 
 */

let colours = ['red', 'blue', 'green', 'orange', 'purple'];

let colour = 0;

while (colour < colours.length){
    console.log(`${colours[colour]}`)
    colour++;
};


let xinfo = `the speed of the car is `;
let speed = 100;
let x = 0
while ( x <= speed){
    console.log(`${xinfo} ${x}MPH`)
    x += 10;
};
  




/*==================================================================================================*
 * // DO-WHILE LOOP
 *  it runs at least once
 * the code runs once before the condition is tested
 * 
 */ 

let a = 0

do {
    console.log(`the number is ${a}`);
    a++
} while (a <= 10);

let b = 1;
let c = 10;


do {
    console.log(b)
    b++
    
} while( b<= c);