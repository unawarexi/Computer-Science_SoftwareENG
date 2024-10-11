# Node.js Modules

## Table of Contents

- [Introduction to Node.js Modules](#introduction-to-nodejs-modules)
- [Types of Modules in Node.js](#types-of-modules-in-nodejs)
  - [1. Core Modules](#1-core-modules)
  - [2. Local Modules](#2-local-modules)
  - [3. Third-Party Modules](#3-third-party-modules)
- [CommonJS vs ES Modules](#commonjs-vs-es-modules)
  - [CommonJS](#commonjs)
  - [ES Modules](#es-modules)
  - [Differences Between CommonJS and ES Modules](#differences-between-commonjs-and-es-modules)
- [How Node.js Loads Modules](#how-nodejs-loads-modules)
- [The `require()` Function](#the-require-function)
  - [Caching Mechanism](#caching-mechanism)
  - [Resolving Modules](#resolving-modules)
- [The `module.exports` and `exports`](#the-moduleexports-and-exports)
- [Using ES Modules](#using-es-modules)
  - [Setting up ES Modules](#setting-up-es-modules)
- [Third-Party Modules via npm](#third-party-modules-via-npm)
  - [Installing Third-Party Modules](#installing-third-party-modules)
  - [Global vs Local Modules](#global-vs-local-modules)
- [Creating a Custom Node.js Module](#creating-a-custom-nodejs-module)
- [Best Practices for Using Modules](#best-practices-for-using-modules)
- [Conclusion](#conclusion)

## Introduction to Node.js Modules

Modules are the building blocks of Node.js applications. They allow developers to encapsulate functionality in smaller, reusable pieces of code. Node.js modules help maintain a clean codebase by breaking down complex applications into smaller, manageable components.

In Node.js, each file is treated as a module that can export its functionality for use in other parts of the application.

## Types of Modules in Node.js

### 1. Core Modules

Core modules are built into Node.js and can be used without needing to install them. These modules provide essential functionalities such as working with files, handling HTTP requests, and more.

Some common core modules include:

- `fs` (File System) – for interacting with the file system
- `http` – for creating HTTP servers and making HTTP requests
- `path` – for working with file and directory paths
- `os` – for getting information about the operating system
- `events` – for handling events in a publish-subscribe pattern

Example of using a core module:

```javascript
const fs = require("fs");

// Reading a file using the `fs` module
fs.readFile("example.txt", "utf8", (err, data) => {
  if (err) throw err;
  console.log(data);
});
```

## 2. Local Modules

Local modules are custom modules you create to organize and reuse code within your project. You define them in separate JavaScript files and export their functionality using `module.exports`.

Example of a local module:

```javascript
// math.js (local module)
module.exports.add = (a, b) => a + b;
module.exports.subtract = (a, b) => a - b;

// main.js (importing local module)
const math = require("./math");
console.log(math.add(2, 3)); // Output: 5
```

## 3. Third-Party Modules

Third-party modules are external packages developed by the Node.js community and available for installation via npm (Node Package Manager). These modules offer additional functionalities beyond the core modules.

Example: **express (a popular web framework)**:

```javascript
const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Hello, Express!");
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
```

# Using ES Modules in Node.js

In modern JavaScript (ES6+), modules help in organizing code. Node.js supports two types of modules:

- **CommonJS**: The traditional module system used in Node.js (require and module.exports).
- **ES Modules**: The standard module system introduced in ES6 (import and export).

## CommonJS vs ES Modules

Node.js supports two types of module systems: `CommonJS` and `ES Modules`.

- ### CommonJS
- The default module system in Node.js.
- Uses require() to import and module.exports or exports to export.
- Synchronous by design.
  Example:

```javascript
// Using CommonJS syntax
const fs = require("fs");
```

- ## ES Modules
- Introduced in ECMAScript 2015 (ES6).
- Use import and export statements.
- Asynchronous, allowing better performance in some cases.
  Example:

```javascript
// Using ES Modules syntax
import fs from "fs";
```
**Differences Between CommonJS and ES Modules**

| Feature            | CommonJS                      | ES Modules                                |
|--------------------|-------------------------------|-------------------------------------------|
| Syntax             | `require()` / `module.exports` | `import` / `export`                       |
| Execution          | Synchronous                   | Asynchronous                              |
| Module Scope       | Function scope                | Lexical scope                             |
| Default Behavior   | Module exports an object       | Explicit exports required                 |
| File Extension     | `.js` (default)               | `.mjs` or `.js` with `"type": "module"`   |


## How Node.js Loads Modules

Node.js follows these steps when loading a module:

1. Path resolution: It resolves the path of the module (relative or absolute).
2. Loading: It determines if the module is a core module, file, or directory.
3. Compilation: The module is compiled (for JavaScript, JSON, or native modules).
4. Caching: After the module is loaded, Node.js caches it to avoid re-loading it during future imports.

### The `require()` Function

In CommonJS, require() is used to import modules. It can import:

- **Core modules**: Prebuilt modules like fs, http.
- **Local modules**: Files or directories in your project.
- **Third-party modules**: Installed via npm.

## Caching Mechanism

Node.js caches modules after the first `require()` call, meaning subsequent calls to require() will return the cached module rather than reloading it. This improves performance.

Example:

```javascript
const math = require("./math");
const sameMath = require("./math"); // Returns cached version
```

### Resolving Modules

- `Relative paths` (e.g., ./math.js) point to local files.
- `Absolute paths and module names` (e.g., express) refer to core or third-party modules.

## Global vs Local Modules

- Local modules are installed in the current project directory and listed in package.json.
- Global modules are installed system-wide and are accessible from any project.
  To install a global module:

  `Creating a Custom Node.js Module`
  You can create your own modules by exporting functionality from one file and importing it into another.

```bash
npm install -g <module-name>
```

# Best Practices for Using Modules
- **Modularize your code**: Break large files into smaller modules for better organization and reusability.
- **Avoid circular dependencies**: Circular dependencies between modules can lead to unexpected behavior or bugs.
- **Use ES Modules when possible**: ES Modules offer better support for static analysis, tree shaking, and modern JavaScript features.
- **Keep third-party dependencies minimal**: Only install the necessary npm packages to avoid bloating your application.
- **Always use relative paths for local modules**: This avoids ambiguity and potential errors.
