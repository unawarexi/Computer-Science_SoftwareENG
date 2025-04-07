/** 
 * The 'events' module in Node.js is used to create and manage event-driven functionality.
 * It provides the 'EventEmitter' class which allows us to emit events and attach listeners (handlers).
 * 
 * Main methods of EventEmitter:
 * - on(event, listener): Attaches a listener for a specific event.
 * - emit(event, [args]): Emits an event, triggering the listeners attached to it.
 * - once(event, listener): Attaches a listener that is only called the first time the event is emitted.
 * - off(event, listener) or removeListener(event, listener): Removes a listener from an event.
 * - listeners(event): Returns an array of listeners attached to the specified event.
 * - setMaxListeners(n): Sets the maximum number of listeners allowed per event (default is 10).
 */

const EventEmitter = require('events');
const eventEmitter = new EventEmitter();

/** 
 * Basic Event Emitter: 
 * A listener is attached to the 'greet' event using 'on'. When 'emit' is called for 'greet', 
 * the attached listener logs "Hello, world!" to the console.
 */
eventEmitter.on('greet', () => {
  console.log('Hello, world!');
});
eventEmitter.emit('greet');

//////////////////////////////////////////////////////////////

/** 
 * Event with Arguments: 
 * A listener is attached to the 'sayHello' event, which accepts an argument. 
 * When emitting the event, we pass the name 'Alice', and the listener uses it to log a greeting.
 */
eventEmitter.on('sayHello', (name) => {
  console.log(`Hello, ${name}!`);
});
eventEmitter.emit('sayHello', 'Alice');

//////////////////////////////////////////////////////////////

/** 
 * Handling Events Once: 
 * The 'once' method attaches a listener that is triggered only once, no matter how many times the event is emitted.
 * Here, 'intro' will log a message only the first time it is emitted.
 */
eventEmitter.once('intro', () => {
  console.log('This will be logged only once.');
});
eventEmitter.emit('intro'); // Listener is called
eventEmitter.emit('intro'); // Listener is not called again

//////////////////////////////////////////////////////////////

/** 
 * Removing Listeners: 
 * A listener is attached to the 'farewell' event, then removed after being triggered once. 
 * When 'emit' is called a second time, the listener does not respond since it's removed using 'off'.
 */
const farewellListener = () => {
  console.log('Goodbye!');
};
eventEmitter.on('farewell', farewellListener);
eventEmitter.emit('farewell'); // Listener is called
eventEmitter.off('farewell', farewellListener);
eventEmitter.emit('farewell'); // Listener is not called

//////////////////////////////////////////////////////////////

/** 
 * Error Handling: 
 * The 'error' event is special in Node.js—if emitted without a listener, the process will crash. 
 * It's a good practice to always attach an error listener to handle errors safely.
 */
eventEmitter.on('error', (err) => {
  console.error(`An error occurred: ${err.message}`);
});
eventEmitter.emit('error', new Error('Something went wrong'));

//////////////////////////////////////////////////////////////

/** 
 * Getting Event Listeners: 
 * The 'listeners' method returns all listeners attached to an event. 
 * Here, we attach two listeners to 'status' and log the array of listeners attached to it.
 */
eventEmitter.on('status', () => console.log('Status OK'));
eventEmitter.on('status', () => console.log('All systems operational'));
const listeners = eventEmitter.listeners('status');
console.log(listeners);

//////////////////////////////////////////////////////////////

/** 
 * Max Listeners Warning: 
 * By default, Node.js allows up to 10 listeners per event. If more are added, a warning is shown. 
 * We can increase this limit using 'setMaxListeners' to avoid the warning when adding many listeners.
 */
eventEmitter.setMaxListeners(15);
