# Next.js Pages & Routing

## Table of Contents

- [Introduction to Pages & Routing](#introduction-to-pages--routing)
- [File-based Routing](#file-based-routing)
- [Dynamic Routes](#dynamic-routes)
- [Nested Routes](#nested-routes)
- [Custom App Configuration (\_app.js)](#custom-app-configuration-_appjs)
- [Custom Document Configuration (\_document.js)](#custom-document-configuration-_documentjs)
- [Custom Error Page (\_error.js)](#custom-error-page-_errorjs)
- [Data Fetching Methods](#data-fetching-methods)
- [Comparison: Data Fetching Methods](#comparison-data-fetching-methods)

## Introduction to Pages & Routing

Next.js provides an intuitive and powerful routing system that is based on the file structure within the `pages/` directory. It allows for automatic and dynamic routing, enabling developers to create complex applications with minimal configuration. Below is a detailed breakdown of key concepts and features within Pages & Routing in Next.js.

## File-based Routing

- **Overview:** Next.js uses a file-based routing system where the file structure inside the `pages/` directory determines the routes of the application.
- **Automatic Routing:** Each `.js` or `.tsx` file inside the `pages/` directory automatically becomes a route in the application.
- **Example:** A file named `about.js` in the `pages/` directory would correspond to the `/about` route in the application.

### Example Structure:

```bash
pages/
├── index.js     # Maps to '/'
├── about.js     # Maps to '/about'
├── contact.js   # Maps to '/contact'
```

## Dynamic Routes

**Overview**: Dynamic routes allow you to create routes with dynamic parameters using bracket syntax in file names `(e.g., [id].js)`.
**Usage**: Useful for pages where the route depends on external data, such as a user profile or a blog post.
**Example**: A file named [id].js in the pages/ directory would match any route like /post/1, /post/2, etc.

### Example Structure:

```bash
pages/
├── post/
│   └── [id].js  # Matches routes like '/post/1', '/post/2'
```

## Nested Routes

**Overview**: Next.js supports nested routes by using subfolders within the pages/ directory. This allows you to create complex URL structures.
**Usage**: Nested routes are useful for creating hierarchically organized content, such as categories and subcategories.
**Example**: A folder named blog with a file post.js would correspond to /blog/post.

### Example Structure:

```bash
pages/
├── blog/
│   ├── index.js  # Maps to '/blog'
│   └── post.js   # Maps to '/blog/post'
```

## Custom App Configuration (\_app.js)

**Overview**: The \_app.js file allows you to override the default App component used by Next.js. It is used to initialize pages and can persist layout between page changes.
**Usage**: Common use cases include adding global styles, maintaining state between pages, or wrapping pages with context providers.

### Example Code:

```javascript
// pages/_app.js
import "../styles/globals.css";

function MyApp({ Component, pageProps }) {
  return <Component {...pageProps} />;
}

export default MyApp;
```
