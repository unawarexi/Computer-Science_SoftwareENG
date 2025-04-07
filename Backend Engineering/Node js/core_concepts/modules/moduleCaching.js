/** 
 * moduleCaching.js
 * 
 * This module demonstrates a basic caching mechanism for function results 
 * using an object to store previously computed values. This is useful for 
 * optimizing performance in scenarios where a function might be called 
 * multiple times with the same arguments.
 */

// Create an object to hold cached results
const cache = {};

/**
 * A function to compute the square of a number.
 * It checks if the result is already cached; 
 * if so, it returns the cached value.
 * Otherwise, it computes the square, caches it, 
 * and then returns the computed value.
 *
 * @param {number} num - The number to square.
 * @returns {number} - The square of the number.
 */
function square(num) {
    // Check if the result is in the cache
    if (cache[num]) {
        console.log('Fetching from cache:', num);
        return cache[num]; // Return cached value if exists
    }

    // Compute the square and store it in the cache
    console.log('Computing square for:', num);
    const result = num * num;
    cache[num] = result; // Cache the computed result
    return result; // Return the computed result
}

// Example usage:
console.log(square(5)); // Computes and caches the result
console.log(square(5)); // Fetches from cache
console.log(square(10)); // Computes and caches a new result
console.log(square(10)); // Fetches from cache

module.exports = { square }; // Export the square function for use in other modules
