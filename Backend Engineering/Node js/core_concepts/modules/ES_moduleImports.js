// Importing a named export (namedExportFunction)
import { namedExportFunction } from './exports';

// Importing multiple named exports (namedExportConstant and namedExportObject)
import { namedExportConstant, namedExportObject } from './exports';

// Importing a default export (defaultExportFunction)
import defaultExportFunction from './exports'; // no curly braces

// Importing everything as an alias from a module (all named and default exports)
import * as allExports from './exports';

function explainImports() {
  // Using the named export function
  console.log(namedExportFunction());

  // Using the named export constant
  console.log(namedExportConstant);

  // Using the default export function
  console.log(defaultExportFunction());

  // Using the named export object
  console.log(namedExportObject);

  // Accessing all exports using the alias 'allExports'
  console.log(allExports.namedExportFunction());
  console.log(allExports.defaultExportFunction());
  console.log(allExports.namedExportObject);
}

// Calling the explanation function
explainImports();
