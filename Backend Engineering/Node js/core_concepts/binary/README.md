# Binary In Node js 
- **Character encoding** is how text characters are converted into binary data that machines understand.
- **UTF-8** is the default encoding in Node.js, supporting all Unicode characters.
- **ASCII** encodes basic English characters but is limited compared to UTF-8.
- **Base64 and Hex** are encoding schemes used to represent binary data as readable text, useful for file transfers and debugging.
- **Buffer** is a core module in Node.js used to handle binary data directly, and it can be encoded/decoded using different encoding formats.


# streams and buffers
- **Streams in Node.js** allow handling data piece by piece (in chunks) instead of loading everything into memory at once.
- **Readable Streams** let you read data (e.g., from a file), and Writable Streams let you write data (e.g., to a file).
- **Piping** connects a readable stream to a writable stream, transferring data directly.
- **Transform Streams** let you modify data as it passes through.
- **Buffers** are used to store raw binary data, and they’re commonly used when handling file I/O or network operations in Node.js.


# Asynchronous Javascript
- **Asynchronous JavaScript** allows code to run in the background while the main thread remains responsive.
- **Callbacks** are the traditional way of handling async code but can lead to deeply nested code (callback hell).
- **Promises** provide a cleaner, more manageable way to handle async operations, avoiding nested callbacks.
- **async/await** is a syntactic sugar built on Promises that allows writing async code in a more synchronous-looking style.
- **setTimeout and setInterval** schedule asynchronous code to run after a delay or repeatedly.
- **Microtasks `(Promises)`** have higher priority than Macrotasks (setTimeout) in the event loop.