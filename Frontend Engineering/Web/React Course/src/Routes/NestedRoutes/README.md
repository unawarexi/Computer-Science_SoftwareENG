## Nested Routing

Nested routing allows you to have routes within other routes, useful for complex page layouts.

```jsx
// App.js
import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Dashboard from "./Dashboard";
import UserProfile from "./UserProfile";
import Settings from "./Settings";

function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/dashboard" component={Dashboard} />
        <Route path="/dashboard/profile" component={UserProfile} />
        <Route path="/dashboard/settings" component={Settings} />
      </Switch>
    </Router>
  );
}

export default App;
```
