# Basic Routing

Basic routing allows you to navigate between different pages in your application.

// App.js

```jsx
import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import HomePage from "./HomePage";
import AboutPage from "./AboutPage";
import NotFoundPage from "./NotFoundPage";

function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/" component={HomePage} />
        <Route path="/about" component={AboutPage} />
        <Route component={NotFoundPage} />
      </Switch>
    </Router>
  );
}

export default App;
```
