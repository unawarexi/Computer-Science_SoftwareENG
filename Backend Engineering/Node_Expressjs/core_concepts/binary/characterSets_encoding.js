/** 
 * Character Sets and Encoding: 
 * In computing, character encoding is used to represent characters as binary data that machines can process. 
 * A **character set** defines the characters available, while **encoding** specifies how characters are represented as bytes.
 * 
 * Common encodings include:
 * - UTF-8: The most common encoding, representing all Unicode characters in a variable length (1-4 bytes).
 * - ASCII: Represents characters using 7-bit encoding, limited to English characters.
 * - Base64: A method for encoding binary data as ASCII text, useful for data transfer.
 * - Hex: Encodes data as hexadecimal values.
 */

const fs = require('fs');

/** 
 * Encoding Text to Buffer:
 * The 'Buffer' class in Node.js is used to handle raw binary data directly. 
 * Here, we create a buffer using a UTF-8 string (default encoding in Node.js).
 */
const buffer = Buffer.from('Hello, world!', 'utf-8');
console.log(buffer); // Logs binary representation of the string

//////////////////////////////////////////////////////////////

/** 
 * Decoding Buffer to Text:
 * Buffers can be decoded back to text using the 'toString' method and specifying the character encoding.
 * Here, we decode a buffer back into a readable string using UTF-8.
 */
const decodedText = buffer.toString('utf-8');
console.log(decodedText); // Outputs 'Hello, world!'

//////////////////////////////////////////////////////////////

/** 
 * Working with ASCII Encoding:
 * ASCII is a 7-bit encoding standard that can represent English characters and some control characters. 
 * Here, we create a buffer with ASCII encoding and log its content.
 */
const asciiBuffer = Buffer.from('Hello, ASCII!', 'ascii');
console.log(asciiBuffer); // Logs binary representation of ASCII-encoded string
console.log(asciiBuffer.toString('ascii')); // Outputs 'Hello, ASCII!'

//////////////////////////////////////////////////////////////

/** 
 * Base64 Encoding:
 * Base64 encoding is commonly used for encoding binary data (e.g., images, files) into a text format for easy transmission over networks. 
 * Here, we convert a UTF-8 string to Base64 and then decode it back.
 */
const base64Encoded = buffer.toString('base64');
console.log(base64Encoded); // Outputs Base64 encoded string

const base64Decoded = Buffer.from(base64Encoded, 'base64').toString('utf-8');
console.log(base64Decoded); // Outputs 'Hello, world!'

//////////////////////////////////////////////////////////////

/** 
 * Hex Encoding:
 * Hexadecimal (hex) encoding represents data as hexadecimal values (0-9, a-f). 
 * It's often used to represent binary data in a readable way.
 * Here, we encode a string to hex and then decode it back.
 */
const hexEncoded = buffer.toString('hex');
console.log(hexEncoded); // Outputs hex encoded string

const hexDecoded = Buffer.from(hexEncoded, 'hex').toString('utf-8');
console.log(hexDecoded); // Outputs 'Hello, world!'

//////////////////////////////////////////////////////////////

/** 
 * Writing Files with Different Encodings:
 * When writing files, we can specify the encoding format to control how text is stored. 
 * Here, we write a text file using UTF-8 and ASCII encodings.
 */
fs.writeFileSync('utf8-text.txt', 'This is UTF-8 encoded text', 'utf-8');
fs.writeFileSync('ascii-text.txt', 'This is ASCII encoded text', 'ascii');

/** 
 * Reading Files with Specified Encoding:
 * When reading files, we specify the encoding to ensure proper conversion from binary data to text.
 * Here, we read the files in UTF-8 and ASCII formats.
 */
const utf8Text = fs.readFileSync('utf8-text.txt', 'utf-8');
console.log(utf8Text); // Outputs UTF-8 encoded text

const asciiText = fs.readFileSync('ascii-text.txt', 'ascii');
console.log(asciiText); // Outputs ASCII encoded text

//////////////////////////////////////////////////////////////

/** 
 * Checking Character Encoding Support:
 * Node.js supports many encodings such as 'utf-8', 'ascii', 'base64', 'hex', etc. 
 * The 'Buffer.isEncoding()' method can be used to check if a particular encoding is supported.
 */
console.log(Buffer.isEncoding('utf-8')); // true
console.log(Buffer.isEncoding('ascii')); // true
console.log(Buffer.isEncoding('hex'));   // true
console.log(Buffer.isEncoding('binary')); // false, 'binary' is deprecated in favor of 'utf8'
