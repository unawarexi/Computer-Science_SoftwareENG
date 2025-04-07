/**
 *  Importing the 'path' module.
 *  This module provides utilities for working with file and directory paths.
 */
const path = require("path");

/**
 *  path.basename()
 *  Retrieves the last portion of a path (i.e., the file or folder name).
 *  Example: Extracting the filename from a given path.
 */
let filePath = "/users/devdreamer/documents/file.txt";
console.log(path.basename(filePath)); // Output: 'file.txt'

/**
 *  path.dirname()
 *  Returns the directory part of a path (i.e., the path without the file name).
 */
console.log(path.dirname(filePath)); // Output: '/users/devdreamer/documents'

/**
 *  path.extname()
 *  Extracts the extension of a file (i.e., the part after the last dot in the filename).
 */
console.log(path.extname(filePath)); // Output: '.txt'

/**
 *  path.join()
 *  Joins multiple path segments into one normalized path string.
 *  This method ensures that slashes are added correctly between path segments.
 */
let joinedPath = path.join("/users", "devdreamer", "projects", "myfile.js");
console.log(joinedPath); // Output: '/users/devdreamer/projects/myfile.js'

/**
 *  path.resolve()
 *  Resolves a sequence of paths into an absolute path.
 *  This can be used to get an absolute path relative to the current directory.
 */
let absolutePath = path.resolve("documents", "projects", "myfile.js");
console.log(absolutePath); // Output depends on the current working directory

/**
 *  path.normalize()
 *  Normalizes a given path by resolving `..` and `.` segments.
 *  This method is helpful to clean up messy or relative paths.
 */
let messyPath = "/users/devdreamer/../projects/./file.txt";
console.log(path.normalize(messyPath)); // Output: '/users/projects/file.txt'

/**
 *  path.isAbsolute()
 *  Determines if a given path is an absolute path.
 *  Absolute paths are those that start from the root `/`.
 */
console.log(path.isAbsolute(filePath)); // Output: true
console.log(path.isAbsolute("documents/file.txt")); // Output: false

/**
 *  path.relative()
 *  Computes the relative path between two paths.
 *  Useful when determining how to get from one directory to another.
 */
let from = "/users/devdreamer/projects";
let to = "/users/devdreamer/documents";
console.log(path.relative(from, to)); // Output: '../documents'

/**
 *  path.parse()
 *  Returns an object containing various parts of a path (root, dir, base, ext, name).
 */
let parsedPath = path.parse(filePath);
console.log(parsedPath);
// Output:
// {
//   root: '/',
//   dir: '/users/devdreamer/documents',
//   base: 'file.txt',
//   ext: '.txt',
//   name: 'file'
// }

/**
 *  path.format()
 *  Constructs a path string from an object returned by path.parse().
 *  Opposite of path.parse().
 */
let formattedPath = path.format(parsedPath);
console.log(formattedPath); // Output: '/users/devdreamer/documents/file.txt'
