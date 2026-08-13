// date.js

/*
 * JavaScript Date and Time Object
 * To use the Date object in JavaScript, you need to create an instance of it.
 * There are several methods to do this, each serving different purposes.
 *
 * 1. Create a new Date instance:
 *    Syntax: var_name = new Date();
 *    Example: let currentDate = new Date(); // Initializes to the current date and time
 *
 * Note: JavaScript handles dates using the total elapsed time in milliseconds 
 * (timestamp) since January 1, 1970, known as Unix or Epoch time.
 *
 * 2. Create a Date from milliseconds:
 *    Syntax: var_name = new Date(milliseconds);
 *    Example: let dateFromMillis = new Date(1680387344558); // Specific date from milliseconds
 *    You can search online for the total number of milliseconds for any specific date.
 *
 * 3. Create a Date from a date string:
 *    Syntax: var_name = new Date("YYYY-MM-DDTHH:mm:ss");
 *    Example: let dateFromString = new Date("2024-10-14T14:00:00"); // ISO 8601 format
 *
 * 4. Create a Date using date components:
 *    Syntax: var_name = new Date(year, month, day, hours, minutes, seconds);
 *    Note: Months are zero-indexed, so December is represented as 11.
 *    Example: let specificDate = new Date(1998, 11, 25, 14, 0, 0); // December 25, 1998, at 2:00 PM
 *
 * 5. Use "get" methods to retrieve date and time components:
 *    After creating a Date instance, you can use various methods:
 *    - getTime(): Returns the total number of milliseconds since Epoch.
 *    - getMonth(): Returns the month (0-11).
 *    Example:
 *    console.log(currentDate.getTime()); // Total milliseconds
 *    console.log(currentDate.getMonth()); // Month as a number
 *
 *    You can also use "set" methods to change date and time components.
 *    These methods consider the user's timezone.
 *
 * 6. Format dates with toLocaleString():
 *    To display date components in a human-readable format:
 *    Example:
 *    currentDate.toLocaleString('default', { month: 'long', weekday: 'short' });
 *    This would display the month in long form and the weekday in short form.
 */

let currentDate = new Date(1680387344558); // Initialize with a specific timestamp
console.log(currentDate); // Output: The date represented by the timestamp

let currentDay = new Date(); // Current date and time
console.log(
    currentDay.toLocaleString('default', {
        month: 'long',  // Full month name (e.g., "October")
        weekday: 'short' // Abbreviated weekday name (e.g., "Sun")
    })
); // Output: "October, Sun" or similar, depending on the current date
