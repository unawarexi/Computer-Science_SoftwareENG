/** 
 * Example 5: Buffer Basics
 * - **Buffers** are temporary storage areas for binary data. Buffers store raw data in memory until it is processed.
 * A Buffer is a raw binary data storage area. 
 * It is useful for handling binary data such as file contents, network packets, etc.
 * Here, we create a buffer from a string and log its contents in both binary and string form.
 */
const buffer = Buffer.from('Hello, Buffer!');
console.log(buffer); // Logs the raw binary data
console.log(buffer.toString()); // Converts the binary data back to a string

//////////////////////////////////////////////////////////////

/** 
 * Example 6: Allocating and Writing to a Buffer
 * Buffers can be allocated manually with a fixed size and can store data using byte offsets.
 * Here, we allocate a buffer of 15 bytes and write "Buffer Example" to it.
 */
const allocatedBuffer = Buffer.alloc(15);
allocatedBuffer.write('Buffer Example');
console.log(allocatedBuffer.toString()); // Outputs 'Buffer Example'

//////////////////////////////////////////////////////////////

/** 
 * Example 7: Reading from a Buffer
 * We can access specific bytes from a buffer using their index, similar to arrays.
 * Here, we create a buffer and access individual bytes at specific positions.
 */
const exampleBuffer = Buffer.from('Node.js Buffer');
console.log(exampleBuffer[0]); // Logs the ASCII code of 'N'
console.log(exampleBuffer.toString('utf-8', 0, 4)); // Logs 'Node' (first 4 bytes)

//////////////////////////////////////////////////////////////

/** 
 * Example 8: Concatenating Buffers
 * The `Buffer.concat()` method can be used to merge multiple buffers into one larger buffer.
 * Here, we concatenate two buffers and log the result.
 */
const buffer1 = Buffer.from('Hello ');
const buffer2 = Buffer.from('World!');
const combinedBuffer = Buffer.concat([buffer1, buffer2]);
console.log(combinedBuffer.toString()); // Outputs 'Hello World!'

//////////////////////////////////////////////////////////////

/** 
 * Example 9: Handling Streams and Buffers Together
 * When using streams to handle file or network data, data is often read in chunks as Buffers. 
 * Here, we read a file using a stream and store the chunks in a buffer array.
 */
let dataBuffers = [];
const readStream = fs.createReadStream('input.txt');
readStream.on('data', (chunk) => {
  dataBuffers.push(chunk); // Store each chunk (Buffer) in the array
});
readStream.on('end', () => {
  const fullBuffer = Buffer.concat(dataBuffers); // Combine all chunks into a single Buffer
  console.log(fullBuffer.toString()); // Convert the combined buffer back to a string
});

//////////////////////////////////////////////////////////////

/** 
 * Example 10: Streaming Large Files Efficiently
 * Streams allow us to handle very large files without loading the entire file into memory.
 * This is especially useful for files like videos or large datasets.
 * Here, we copy a large file using streams to avoid memory issues.
 */
const largeSource = fs.createReadStream('large-file.txt');
const largeDestination = fs.createWriteStream('large-file-copy.txt');
largeSource.pipe(largeDestination); // Efficiently copies the large file in chunks
