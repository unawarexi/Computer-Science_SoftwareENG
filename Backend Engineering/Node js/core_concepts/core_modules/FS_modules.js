/** 
 * The 'fs' (File System) module:
 * The 'fs' module in Node.js allows us to work with the file system. 
 * It provides methods for reading, writing, updating, and deleting files.
 * 
 * There are both **synchronous** and **asynchronous** methods:
 * - Synchronous methods block the execution of subsequent code until the file operation completes.
 * - Asynchronous methods run in the background and use callbacks or Promises to handle the result.
 */

const fs = require('fs');

//////////////////////////////////////////////////////////////

/** 
 * Example 1: Reading Files Asynchronously
 * `fs.readFile()` reads the content of a file asynchronously.
 * It takes a callback that handles the error (if any) and the file data after it's read.
 */
fs.readFile('example.txt', 'utf-8', (err, data) => {
  if (err) {
    console.error('Error reading file:', err);
    return;
  }
  console.log('File content:', data); // Outputs the content of the file
});

//////////////////////////////////////////////////////////////

/** 
 * Example 2: Reading Files Synchronously
 * `fs.readFileSync()` reads a file synchronously. It blocks the execution until the file is read.
 * Here, we read the file and store the content in a variable.
 */
try {
  const data = fs.readFileSync('example.txt', 'utf-8');
  console.log('Sync file content:', data); // Outputs the file content
} catch (err) {
  console.error('Error reading file:', err);
}

//////////////////////////////////////////////////////////////

/** 
 * Example 3: Writing to a File Asynchronously
 * `fs.writeFile()` writes data to a file asynchronously. 
 * If the file doesn't exist, it creates it; if it does, it overwrites the existing content.
 */
const content = 'This is some new content!';
fs.writeFile('new-file.txt', content, (err) => {
  if (err) {
    console.error('Error writing to file:', err);
    return;
  }
  console.log('File written successfully');
});

//////////////////////////////////////////////////////////////

/** 
 * Example 4: Writing to a File Synchronously
 * `fs.writeFileSync()` writes data to a file synchronously, blocking further execution until the file is written.
 */
try {
  fs.writeFileSync('new-file-sync.txt', 'Synchronous content writing');
  console.log('File written synchronously');
} catch (err) {
  console.error('Error writing to file:', err);
}

//////////////////////////////////////////////////////////////

/** 
 * Example 5: Appending Data to a File
 * `fs.appendFile()` appends data to a file asynchronously. 
 * If the file doesn't exist, it creates a new file.
 */
fs.appendFile('log.txt', 'This is appended content\n', (err) => {
  if (err) {
    console.error('Error appending to file:', err);
    return;
  }
  console.log('Content appended to file');
});

//////////////////////////////////////////////////////////////

/** 
 * Example 6: Deleting a File
 * `fs.unlink()` removes (deletes) a file asynchronously.
 */
fs.unlink('unwanted-file.txt', (err) => {
  if (err) {
    console.error('Error deleting file:', err);
    return;
  }
  console.log('File deleted successfully');
});

//////////////////////////////////////////////////////////////

/** 
 * Example 7: Renaming a File
 * `fs.rename()` renames or moves a file asynchronously.
 */
fs.rename('old-name.txt', 'new-name.txt', (err) => {
  if (err) {
    console.error('Error renaming file:', err);
    return;
  }
  console.log('File renamed successfully');
});

//////////////////////////////////////////////////////////////

/** 
 * Example 8: Creating a Directory
 * `fs.mkdir()` creates a new directory asynchronously. 
 * The `{ recursive: true }` option allows creating nested directories if they don't exist.
 */
fs.mkdir('new-directory', { recursive: true }, (err) => {
  if (err) {
    console.error('Error creating directory:', err);
    return;
  }
  console.log('Directory created');
});

//////////////////////////////////////////////////////////////

/** 
 * Example 9: Removing a Directory
 * `fs.rmdir()` removes a directory asynchronously. 
 * If the directory contains files, it throws an error unless `{ recursive: true }` is used.
 */
fs.rmdir('old-directory', { recursive: true }, (err) => {
  if (err) {
    console.error('Error removing directory:', err);
    return;
  }
  console.log('Directory removed');
});

//////////////////////////////////////////////////////////////

/** 
 * Example 10: Watching Files for Changes
 * `fs.watch()` watches a file or directory for changes. It triggers an event whenever a file is modified, renamed, or deleted.
 */
fs.watch('example.txt', (eventType, filename) => {
  console.log(`Event type: ${eventType}`);
  console.log(`File affected: ${filename}`);
});

//////////////////////////////////////////////////////////////

/** 
 * Example 11: Checking if a File or Directory Exists
 * `fs.existsSync()` checks whether a file or directory exists. 
 * This method is synchronous and returns a boolean.
 */
const fileExists = fs.existsSync('example.txt');
console.log('File exists:', fileExists); // Outputs true or false

//////////////////////////////////////////////////////////////

/** 
 * Example 12: Reading a Directory
 * `fs.readdir()` reads the contents of a directory asynchronously. 
 * It returns an array of file and directory names within the directory.
 */
fs.readdir('new-directory', (err, files) => {
  if (err) {
    console.error('Error reading directory:', err);
    return;
  }
  console.log('Directory contents:', files); // Outputs an array of file and directory names
});

//////////////////////////////////////////////////////////////

/** 
 * Example 13: Getting File Information (stats)
 * `fs.stat()` retrieves information about a file or directory asynchronously.
 * It returns an object containing details such as size, creation time, and whether it's a file or directory.
 */
fs.stat('example.txt', (err, stats) => {
  if (err) {
    console.error('Error getting file stats:', err);
    return;
  }
  console.log('File stats:', stats);
  console.log('Is file:', stats.isFile());
  console.log('Is directory:', stats.isDirectory());
});

//////////////////////////////////////////////////////////////

/** 
 * Example 14: Copying Files
 * `fs.copyFile()` copies a file from one location to another asynchronously.
 */
fs.copyFile('source.txt', 'destination.txt', (err) => {
  if (err) {
    console.error('Error copying file:', err);
    return;
  }
  console.log('File copied successfully');
});
