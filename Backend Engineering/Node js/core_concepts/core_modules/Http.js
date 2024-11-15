/** 
 *  Importing the 'http' module.
 *  This module provides the ability to create HTTP servers and make HTTP requests.
 * 
 * ========================== Summary of Methods Used:
 * 
 * http.createServer(): Used to create an HTTP server that can respond to requests.
 * server.listen(): Starts the server and listens for requests.
 * req.method and req.url: Accesses the HTTP method and requested URL.
 * res.writeHead(): Sets HTTP headers and status codes for the response.
 * res.end(): Ends the response and sends it to the client.
 * http.get(): Simplified method for making HTTP GET requests.
 * http.request(): General method for making HTTP requests, including POST.
 * req.write(): Sends request body data in an HTTP POST request.
 * req.end(): Ends the request, signaling completion of the request.
 */
const http = require('http');

/**
 *  http.createServer()
 *  Creates an HTTP server instance.
 *  Takes a callback function with 'req' (request) and 'res' (response) objects.
 *  This server will listen for incoming HTTP requests and handle them.
 */
const server = http.createServer((req, res) => {
    // Setting the response HTTP header with status and content type
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    
    /** 
     *  req.method
     *  Captures the HTTP method used in the request (GET, POST, etc.).
     */
    console.log(`Request method: ${req.method}`);
    
    /**
     *  req.url
     *  Returns the requested URL path.
     */
    console.log(`Requested URL: ${req.url}`);
    
    // Writing a response and ending it
    res.end('Hello, World!\n');
});

/**
 *  server.listen()
 *  Starts the server and listens for connections on the specified port.
 *  Here we listen on port 3000, and log a message when the server starts.
 */
server.listen(3000, () => {
    console.log('Server running at http://localhost:3000/');
});

/**
 *  Making an HTTP GET request using http.get().
 *  This method is for making simple GET requests.
 */
http.get('http://www.google.com', (res) => {
    /** 
     *  res.statusCode
     *  Captures the status code of the response.
     */
    console.log(`Status Code: ${res.statusCode}`);
    
    /**
     *  res.headers
     *  Contains the response headers returned by the server.
     */
    console.log('Headers:', res.headers);

    /**
     *  res.on('data', callback)
     *  Listens to the data chunks sent by the server.
     *  The 'data' event is emitted for every chunk of data received.
     */
    res.on('data', (chunk) => {
        console.log(`Response chunk: ${chunk}`);
    });

    /**
     *  res.on('end', callback)
     *  Listens for the 'end' event, which signals that the response has finished.
     */
    res.on('end', () => {
        console.log('No more data in response.');
    });
}).on('error', (err) => {
    /**
     *  Error handling for the request.
     *  Captures any errors encountered during the request.
     */
    console.error(`Request error: ${err.message}`);
});

/**
 *  Making an HTTP POST request using http.request().
 *  This is more flexible than http.get() and can be used for different request methods.
 */
const postData = JSON.stringify({
    name: 'John Doe',
    job: 'Developer'
});

/**
 *  Defining the request options.
 *  This includes the hostname, port, path, method, and headers.
 */
const options = {
    hostname: 'jsonplaceholder.typicode.com',
    port: 80,
    path: '/posts',
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData)
    }
};

/**
 *  Creating an HTTP request using http.request().
 *  The request can be configured with options and the request body.
 */
const req = http.request(options, (res) => {
    console.log(`Status Code: ${res.statusCode}`);
    console.log('Headers:', res.headers);

    res.on('data', (chunk) => {
        console.log(`Response chunk: ${chunk}`);
    });

    res.on('end', () => {
        console.log('Response ended.');
    });
});

/**
 *  Writing data to the request body.
 *  The data is sent to the server as the request body.
 */
req.write(postData);

/**
 *  Ending the request.
 *  This signals the end of the request, ensuring that all data is sent.
 */
req.end();

/**
 *  Handling errors for the POST request.
 *  This catches any errors that might occur during the request.
 */
req.on('error', (err) => {
    console.error(`Request error: ${err.message}`);
});
