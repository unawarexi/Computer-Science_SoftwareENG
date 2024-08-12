# React Context API

## Overview

The Context API in React provides a way to pass data through the component tree without having to pass props down manually at every level.
It is particularly useful when you need to share state or data across many components without resorting to `"prop drilling."`

## Key Concepts

### 1. **Context Creation**

- To create a Context, use the `React.createContext` function. This returns a Context object that contains two main components: `Provider` and `Consumer`.

```javascript
const MyContext = React.createContext(defaultValue);
```

defaultValue is optional. It is used when a component does not have a matching Provider in the component tree.
