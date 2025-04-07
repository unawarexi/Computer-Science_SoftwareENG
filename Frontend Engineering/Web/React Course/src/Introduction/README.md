# Intro to react

## Importance of React.js

1. **Component-Based Architecture**:

   - React.js allows you to build encapsulated components that manage their own state and compose them to create complex UIs. This promotes reusability and easier management of your application's structure.

2. **Virtual DOM**:

   - React uses a virtual DOM to optimize updates. When a component's state changes, React updates the virtual DOM, compares it with the real DOM, and only makes the necessary changes. This results in improved performance, especially for large applications.

3. **Declarative UI**:

   - React's declarative approach makes it easy to understand and predict how your application will look and behave. This reduces bugs and makes it easier to debug and maintain your code.

4. **Unidirectional Data Flow**:
   - React's unidirectional data flow (one-way data binding) makes it easier to understand and debug your application. Data flows from parent to child components, ensuring a clear data structure.

## JSX

JSX (JavaScript XML) is a syntax extension for JavaScript that looks similar to HTML. It's used with React to describe what the UI should look like. Each JSX element is a syntactic sugar
for calling `React.createElement()`.

### Key Points about JSX:

- **Syntax**:

  ```jsx
  const element = <h1>Hello, world!</h1>;
  ```

- **Embedding Expressions**:
  You can embed any JavaScript expression within JSX by wrapping it in `curly braces {}`.

```jsx
const name = "Josh Perez";
const element = <h1>Hello, {name}</h1>;
```

- **JSX is an Expression Too**:
  After compilation, JSX expressions become regular JavaScript function calls and evaluate to JavaScript objects.

- **Attributes**:
  You can use quotes to specify string literals as attributes or curly braces to embed a JavaScript expression in an attribute.

```jsx
const element = <img src={user.avatarUrl} />;
```

- **Children**:
  If a tag is empty, you can close it immediately with />, like XML.

```jsx
const element = <img src={user.avatarUrl} />;
```
