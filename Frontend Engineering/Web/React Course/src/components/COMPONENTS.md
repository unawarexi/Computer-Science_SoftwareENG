# Day 3 (Wednesday): Components and Props

## What are Components?

Components are the building blocks of a React application. They are JavaScript `functions or classes` that optionally accept inputs `(called "props")` and return React elements that describe what should appear on the screen.

## Types of Components: Functional and Class Components

- **Functional Components**: These are simple JavaScript functions that take props as an argument and return React elements.
- **Class Components**: These are ES6 classes that extend from React.Component and have a render method that returns React elements.

## Creating and Using Components

- Creating a Functional Component:

```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```

- Creating a Class Component:

```jsx
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}
```

## Props: Passing Data to Components

Props are used to pass data from `parent to child components`. They are `read-only` and should not be modified by the component receiving them.

Example of passing props:

```jsx
function App() {
  return <Welcome name="Sara" />;
}

function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```
