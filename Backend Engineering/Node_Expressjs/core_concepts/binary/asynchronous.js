/** 
 * Asynchronous JavaScript:
 * JavaScript is single-threaded, meaning it can only execute one operation at a time. 
 * However, asynchronous programming allows certain tasks (e.g., file I/O, API requests) to run in the background 
 * without blocking the main thread. This keeps the app responsive and improves performance.
 * 
 * Common Asynchronous Patterns:
 * - Callbacks
 * - Promises
 * - async/await (built on Promises)
 */

//////////////////////////////////////////////////////////////

/** 
 * Example 1: Asynchronous Callbacks
 * A callback is a function passed as an argument to another function, which is executed after the asynchronous operation is completed.
 * Here, we use a callback to simulate fetching data with a delay.
 */
function fetchData(callback) {
    setTimeout(() => {
      callback('Data received');
    }, 2000); // Simulates a 2-second delay
  }
  console.log('Start fetching...');
  fetchData((data) => {
    console.log(data); // Logs 'Data received' after 2 seconds
  });
  console.log('Fetching in progress...'); // This logs immediately because setTimeout is non-blocking
  
  //////////////////////////////////////////////////////////////
  
  /** 
   * Example 2: Promises
   * A Promise represents an eventual completion (or failure) of an asynchronous operation. 
   * It allows handling async results without deeply nesting callbacks (avoiding "callback hell").
   * A Promise has three states: pending, fulfilled, or rejected.
   */
  function fetchDataWithPromise() {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve('Promise: Data received');
      }, 2000); // Simulates a 2-second delay
    });
  }
  console.log('Start fetching with Promise...');
  fetchDataWithPromise()
    .then((data) => {
      console.log(data); // Logs 'Promise: Data received' after 2 seconds
    })
    .catch((error) => {
      console.error(error);
    });
  console.log('Fetching with Promise in progress...'); // This logs immediately
  
  //////////////////////////////////////////////////////////////
  
  /** 
   * Example 3: Chaining Promises
   * Promises can be chained to handle multiple asynchronous operations sequentially.
   * Here, we simulate fetching user data, then fetching details of that user.
   */
  function fetchUser() {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve({ id: 1, name: 'Alice' });
      }, 1000);
    });
  }
  
  function fetchUserDetails(userId) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve({ userId, age: 25, city: 'New York' });
      }, 1000);
    });
  }
  
  fetchUser()
    .then((user) => {
      console.log('User fetched:', user);
      return fetchUserDetails(user.id); // Fetch user details after fetching user
    })
    .then((details) => {
      console.log('User details:', details); // Logs user details after 2 seconds
    })
    .catch((error) => {
      console.error(error);
    });
  
  //////////////////////////////////////////////////////////////
  
  /** 
   * Example 4: async/await
   * async/await is syntactic sugar built on Promises that allows us to write asynchronous code in a more synchronous manner.
   * It makes the code more readable and avoids chaining multiple `.then()` blocks.
   */
  async function getData() {
    try {
      console.log('Start async/await fetching...');
      const data = await fetchDataWithPromise(); // Waits for the promise to resolve
      console.log(data); // Logs 'Promise: Data received'
    } catch (error) {
      console.error(error); // Handles errors
    }
  }
  getData();
  console.log('Async/await fetching in progress...'); // This logs immediately
  
  //////////////////////////////////////////////////////////////
  
  /** 
   * Example 5: Handling Multiple Promises with Promise.all
   * Promise.all is used when you want to wait for multiple asynchronous operations to complete.
   * It takes an array of Promises and resolves when all of them resolve, or rejects if any one Promise fails.
   */
  const promise1 = fetchDataWithPromise();
  const promise2 = fetchUserDetails(1);
  
  Promise.all([promise1, promise2])
    .then((results) => {
      console.log('All promises resolved:', results);
    })
    .catch((error) => {
      console.error('One of the promises failed:', error);
    });
  
  //////////////////////////////////////////////////////////////
  
  /** 
   * Example 6: Error Handling with Promises and async/await
   * Errors in asynchronous operations can be handled using `.catch()` for Promises or `try/catch` for async/await.
   * This ensures that we can gracefully handle failures (like failed network requests).
   */
  function fetchWithError() {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        reject('Failed to fetch data'); // Simulate an error
      }, 1000);
    });
  }
  
  // Using Promises
  fetchWithError()
    .then((data) => {
      console.log(data);
    })
    .catch((error) => {
      console.error('Error in Promise:', error); // Logs 'Error in Promise: Failed to fetch data'
    });
  
  // Using async/await
  async function getDataWithErrorHandling() {
    try {
      const data = await fetchWithError();
      console.log(data);
    } catch (error) {
      console.error('Error in async/await:', error); // Logs 'Error in async/await: Failed to fetch data'
    }
  }
  getDataWithErrorHandling();
  
  //////////////////////////////////////////////////////////////
  
  /** 
   * Example 7: setTimeout and setInterval
   * `setTimeout()` and `setInterval()` are built-in JavaScript functions used to schedule asynchronous actions.
   * - `setTimeout()`: Executes a function once after a specified delay.
   * - `setInterval()`: Repeatedly executes a function with a fixed time delay between each call.
   */
  console.log('Start setTimeout...');
  setTimeout(() => {
    console.log('This runs after 1 second');
  }, 1000);
  
  let counter = 0;
  const intervalId = setInterval(() => {
    console.log('Interval running:', ++counter);
    if (counter === 3) {
      clearInterval(intervalId); // Stops the interval after 3 runs
    }
  }, 1000); // Runs every 1 second
  
  //////////////////////////////////////////////////////////////
  
  /** 
   * Example 8: Microtasks and Macrotasks (Event Loop)
   * The Event Loop controls the execution order of asynchronous code in JavaScript.
   * - Macrotasks: Includes setTimeout, setInterval, I/O operations, and UI rendering.
   * - Microtasks: Includes Promises and process.nextTick().
   * Microtasks have higher priority and are executed before macrotasks in the event loop.
   */
  console.log('Start event loop demo...');
  
  // Macrotask (setTimeout)
  setTimeout(() => {
    console.log('Macrotask: setTimeout');
  }, 0);
  
  // Microtask (Promise)
  Promise.resolve().then(() => {
    console.log('Microtask: Promise');
  });
  
  // Synchronous code runs first
  console.log('End of script'); // This logs first, followed by microtask, then macrotask
  