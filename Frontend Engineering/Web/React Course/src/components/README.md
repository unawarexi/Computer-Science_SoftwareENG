# React.js Learning Schedule

## Day 2 (Tuesday): JSX

### Understanding JSX

JSX stands for JavaScript XML. It allows you to write HTML elements in JavaScript and place them in the DOM without using `createElement()` or `appendChild()`.
JSX makes it easier to write and add HTML in React.

### Embedding Expressions in JSX

In JSX, you can embed any JavaScript expression by wrapping it in curly braces `{}`. For example, `{2 + 2}` will be evaluated as `4`, and `{user.name}` will output the `name`
property of the `user` object.

### JSX vs HTML

| Feature               | JSX                                             | HTML                                                               |
| --------------------- | ----------------------------------------------- | ------------------------------------------------------------------ |
| Syntax                | JavaScript XML                                  | Standard HTML                                                      |
| Dynamic Content       | Embeds JavaScript expressions within `{}`       | No direct embedding of JavaScript expressions                      |
| Attributes            | camelCase (e.g., `className`, `onClick`)        | lowercase with hyphens (e.g., `class`, `onclick`)                  |
| Conditional Rendering | Uses JavaScript logic for conditional rendering | Uses `if` or conditional classes in CSS or JavaScript manipulation |
| Reactivity            | Automatically updates the DOM                   | Manual DOM updates                                                 |

### Practical Examples with JSX

Here are some examples of JSX usage:

```jsx
const element = <h1>Hello, world!</h1>;

//----------
const user = {
  firstName: "Harper",
  lastName: "Perez",
};
const greeting = <h1>Hello, {formatName(user)}!</h1>;

function formatName(user) {
  return user.firstName + " " + user.lastName;
}
```

# React Fragments

React Fragments let you group a list of children elements without adding extra nodes to the DOM. This can be useful when returning multiple elements from a component's render method.

## Benefits

1. **Avoids Extra DOM Elements**: Fragments help you avoid unnecessary wrapper elements in the DOM, which can make your markup cleaner.
2. **Improves Performance**: By reducing the number of DOM nodes, fragments can improve rendering performance.
3. **Cleaner JSX**: Fragments make your JSX cleaner and more readable by removing the need for additional wrapper elements.

## Usage

### Basic Usage

You can use the `Fragment` component from React to wrap multiple elements.

```jsx
import React, { Fragment } from "react";

const MyComponent = () => {
  return (
    <Fragment>
      <h1>Title</h1>
      <p>This is a paragraph.</p>
    </Fragment>
  );
};

export default MyComponent;
```

- #### Short Syntax

  React also provides a shorter syntax for fragments, which can be used as empty tags `(<> and </>)`.

  ```jsx
  const MyComponent = () => {
    return (
      <>
        {" "}
        // this is fragment
        <h1>Title</h1>
        <p>This is a paragraph.</p>
      </>
    );
  };
  ```

- #### Keyed Fragments
  In some cases, you may need to use fragments with keys, such as when rendering a list of items.

```jsx
const MyListComponent = () => {
  const items = ["Item 1", "Item 2", "Item 3"];

  return (
    <>
      {items.map((item, index) => (
        <React.Fragment key={index}>
          <p>{item}</p>
        </React.Fragment>
      ))}
    </>
  );
};
```
