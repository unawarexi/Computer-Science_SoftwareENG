// COMPARISON OPERATORS 

/*
 1 it returns a boolen value
 2 thyre 3 main types of comparison operators 
     * relational - compares in relation to another
     * abstract - checks only if there the same
     * strict - checks if values are the same and have the same datatypes


    includes;
     >
     <
     <=
     >= 
 */



//logical operators

/**
 *  
 *  there are two types of logical operator
 *      the faslsy and truthy operators = 
 *             falsy = null, undefined, 0, false, empty string
 *             truthy = and, or , not
 * there's a special one called nullish operaator "??" - thiss is a nullish operator
 * 
 * NOTE: the difference btw ?? and || 
 *   is nullish operator shows another alternative value if var is undefined or null 
 *   but or || shows if it's false
 */


/**
 * there is arithemetic operators but thats simple
 */


let course;

console.log(
    course ?? " please select a course" // shows the statement
);


let courseProgress = 0;

console.log(
    courseProgress ?? "start the course"  // shows false
);

 