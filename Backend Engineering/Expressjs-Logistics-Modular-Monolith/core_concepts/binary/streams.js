/** 
 * Streams and Buffers in Node.js:
 * - **Streams** are used to handle data that is read or written sequentially (in chunks) rather than all at once. 
 *   Streams allow efficient handling of large files or continuous data.
 * 
 * Types of Streams:
 * - **Readable Streams**: Streams you can read data from (e.g., reading from a file or network).
 * - **Writable Streams**: Streams you can write data to (e.g., writing to a file or HTTP response).
 * - **Duplex Streams**: Streams that are both readable and writable (e.g., TCP sockets).
 * - **Transform Streams**: A type of Duplex stream that modifies or transforms data while reading/writing.
 */

const fs = require('fs');
const { Transform } = require('stream');

//////////////////////////////////////////////////////////////

/** 
 * Example 1: Reading Data with a Readable Stream
 * Using `fs.createReadStream`, we can read large files in chunks rather than loading the entire file into memory.
 * The 'data' event is emitted whenever a new chunk of data is available.
 */
const readableStream = fs.createReadStream('input.txt', { encoding: 'utf-8' });
readableStream.on('data', (chunk) => {
  console.log('Received chunk:', chunk);
});

//////////////////////////////////////////////////////////////

/** 
 * Example 2: Writing Data with a Writable Stream
 * Using `fs.createWriteStream`, we can write data in chunks to a file.
 * The `write()` method is used to send chunks of data to the writable stream.
 */
const writableStream = fs.createWriteStream('output.txt');
writableStream.write('Writing data to file...\n');
writableStream.write('More data...\n');
writableStream.end(); // Ends the stream, signaling no more data will be written

//////////////////////////////////////////////////////////////

/** 
 * Example 3: Piping Streams
 * The `pipe()` method allows us to connect a readable stream directly to a writable stream. 
 * This is very efficient for handling data like file copying or HTTP responses.
 */
const sourceStream = fs.createReadStream('input.txt');
const destinationStream = fs.createWriteStream('copied-output.txt');
sourceStream.pipe(destinationStream); // Reads from 'input.txt' and writes directly to 'copied-output.txt'

//////////////////////////////////////////////////////////////

/** 
 * Example 4: Transform Stream
 * A Transform stream is both readable and writable and allows us to modify data as it passes through.
 * Here, we create a transform stream that converts input text to uppercase.
 */
const transformStream = new Transform({
  transform(chunk, encoding, callback) {
    const upperChunk = chunk.toString().toUpperCase();
    callback(null, upperChunk); // Pass the transformed chunk to the next stream
  }
});

// Pipe a readable stream through the transform stream and then to a writable stream
fs.createReadStream('input.txt')
  .pipe(transformStream)
  .pipe(fs.createWriteStream('uppercase-output.txt'));


