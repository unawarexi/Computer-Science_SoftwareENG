# Understanding `_folder` (Private Folders) in Next.js

## Introduction

In Next.js, the use of folders and files starting with an underscore (`_`) has become a common practice among developers to denote private, utility, or non-routing components and modules. This convention helps maintain a clean project structure, improves code organization, and makes the intent of the codebase clearer.

While Next.js itself doesn't enforce any specific behavior for folders starting with `_`, using this convention can lead to more maintainable and understandable projects, especially in larger applications.

## Table of Contents

1. [What are `_folder` Private Folders?](#what-are-_folder-private-folders)
2. [Common Use Cases](#common-use-cases)
3. [Benefits of Using `_folder` Folders](#benefits-of-using-_folder-folders)
4. [How to Implement `_folder` Folders](#how-to-implement-_folder-folders)
5. [Best Practices](#best-practices)
6. [Conclusion](#conclusion)

## What are `_folder` Private Folders?

In the context of Next.js, `_folder` refers to directories or files that start with an underscore (`_`). These are typically used to:

- Indicate that the content within these folders is not meant to be directly exposed as `routes or API endpoints`.
- Separate internal components, utilities, hooks, or configuration files from the main application logic.
- Provide a semantic structure to differentiate between what is part of the routing layer and what is purely functional or structural.

### Does Next.js Treat `_folder` Differently?

It's important to note that Next.js does not inherently treat `_folder` differently from other folders. There is no special functionality or restriction applied to folders or files beginning with an underscore. This is purely a convention adopted by developers to signal that the contents are "private" or "internal" to the application.

## Common Use Cases

### 1. **Private Components and Modules**

Developers often use `_folder` to organize components or modules that are not intended to be used directly as pages. For example:

- **`_components/`**: A directory containing reusable React components that are not directly associated with a route.

```bash
/pages/
index.js
about.js
/\_components/
Header.js
Footer.js
Sidebar.js
```

### 2. **Shared Utilities and Helpers**

Utilities and helper functions that are shared across different parts of the application but are not directly tied to the routing logic can be placed in a `_utils` or `_helpers` folder.

- **`_utils/`**: Contains utility functions that may be used throughout the app.

```bash
/_utils/
formatDate.js
calculateTotal.js
```

### 3. **Custom Hooks**

Custom React hooks that encapsulate shared logic can be organized in a `_hooks` folder.

- **`_hooks/`**: Contains custom hooks that manage shared state or handle common functionality.

```bash
/_hooks/
useAuth.js
useFetch.js
```

### 4. **Configuration and Constants**

Configuration files, constants, and other similar non-routing resources can be stored in `_config` or `_constants`.

- **`_config/`**: Holds configuration files that are used to manage application settings.

```bash
/_config/
apiConfig.js
themeConfig.js
```

### 5. **Non-Route Specific Layouts**

Layouts that are meant to be applied across multiple routes but not directly associated with a specific page can be stored in a `_layouts` folder.

- **`_layouts/`**: Contains layout components.

```bash
/_layouts/
MainLayout.js
AdminLayout.js
```

## Benefits of Using `_folder` Folders

### 1. **Improved Code Organization**

Using `_folder` folders helps keep the project organized by clearly distinguishing between routing components (pages) and non-routing components (utilities, hooks, etc.). This organization is especially beneficial as the project scales.

### 2. **Enhanced Readability**

Developers working on the project can easily understand the structure and purpose of different parts of the codebase. `_folder` conventions communicate that the folder's contents are internal or utility-based.

### 3. **Avoid Route Conflicts**

By conventionally placing non-page components in folders with a leading underscore, developers can avoid conflicts with Next.js routing. This makes it clear which components are intended to be routes and which are not.

### 4. **Easier Maintenance**

Having a clear structure with private folders makes it easier to maintain and refactor code. Developers can quickly locate where internal logic or reusable components are stored without sifting through routing logic.

## How to Implement `_folder` Folders

Implementing `_folder` folders in Next.js is straightforward. You simply create folders or files with a leading underscore (`_`) and place your internal components, hooks, or utilities inside them.

### Example Project Structure

```bash
my-next-app/
|-- pages/
|   |-- index.js
|   |-- about.js
|-- _components/
|   |-- Header.js
|   |-- Footer.js
|-- _utils/
|   |-- formatDate.js
|-- _hooks/
|   |-- useAuth.js
|-- _config/
|   |-- apiConfig.js
```

## Importing from `_folder Folders`

To use the contents of a \_folder in your Next.js components, simply import them as you would with any other module.

```javascript
import Header from "../_components/Header";
import { formatDate } from "../_utils/formatDate";
import useAuth from "../_hooks/useAuth";
```

### Best Practices

- **Consistent Naming**: Use a consistent naming convention for \_folder folders across your project. This consistency makes the codebase easier to navigate and understand.
- **Limit Scope**: Avoid overusing the \_ prefix. Only use it for components and utilities that are genuinely internal or private to the application. Overusing it can make the codebase cluttered.
- **Documentation**: Document the purpose of your \_folder directories, especially in large projects, to help other developers understand the structure and intent.
- **Structure Updates**: Regularly review your project structure to ensure that the use of \_folder remains logical and beneficial. As the project grows, refactoring might be needed.

# NOTE -

use `"%5F"` to include and underscore in you url segments, this is the url encoded form of the "\_"
