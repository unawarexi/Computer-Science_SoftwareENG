/**
 * A callback is a function passed into another function as an argument.
 * Once the outer function completes its execution, the callback function is executed.
 */

/** 
 * Example of a basic callback function 
 * We define a function 'sayHello' that takes a name and a callback.
 */
function sayHello(name, callback) {
    console.log(`Hello, ${name}!`);
    
    /** 
     * The callback is executed after the main logic. 
     * The 'callback()' is a function that will be executed after the greeting.
     */
    callback();
}

/** 
 * Example of a callback function that gets passed into 'sayHello' 
 */
function displayMessage() {
    console.log("Callback function executed: Welcome to the callback pattern!");
}

/** 
 * Call 'sayHello' and pass the 'displayMessage' function as a callback. 
 * This will first greet the person and then execute the callback.
 */
sayHello("Andrew", displayMessage);

/**
 * Asynchronous callback example with setTimeout().
 * Asynchronous functions don't execute immediately; they take time, and callbacks help manage the response.
 */
function fetchData(callback) {
    console.log("Fetching data...");
    
    /** 
     * Using setTimeout to simulate fetching data from a server. 
     * After 3 seconds, the callback function is called.
     */
    setTimeout(() => {
        console.log("Data fetched successfully.");
        
        /** 
         * The callback is executed after the data is fetched.
         * This could be some logic to process the data.
         */
        callback();
    }, 3000);
}

/** 
 * A callback function that will handle what happens after data is fetched. 
 */
function processData() {
    console.log("Processing the fetched data...");
}

/** 
 * Calling 'fetchData' with 'processData' as the callback. 
 * The 'processData' function will only run after 'fetchData' completes.
 */
fetchData(processData);

/**
 * Callback functions help control the flow of execution, especially in asynchronous operations.
 * They allow one function to be executed only after another one finishes.
 */
