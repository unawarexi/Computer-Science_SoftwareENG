# React.js Overview

- **Intro**
- **Why learn React?**
- **Prerequisites**
- **Setup React with Vite**
- **Install NPM Dependencies**
- **Project File Overview**
- **Intro to Components**
- **createElement function**
- **Component Props**
- **Evaluating Props**
- **Creating a Component**
- **Type Checking Props**
- **Children Components**
- **Fragments**
- **Styling with CSS & SCSS**
- **Dynamic Rendering Lists/Arrays**
- **Conditional Rendering**
- **Handling Events**
- **Input Field onChange Event**
- **Form onSubmit Event**
- **Registering Window Events**
- **State**
- **useState Hook**
- **Binding State to Input Fields**
- **State with Arrays**
- **Updating Element in State Array**
- **Delete Element from State Array**
- **Add Elements to State Array**
- **useEffect Hook**
- **useEffect Dependency Array**
- **Fetching Data Example**
- **AbortController**
- **useEffect Cleanup Function**
- **POST Request Example**
- **Creating Custom Hooks**
- **React Context**
- **Creating a Context**
- **Using Context Provider**
- **Consuming Context**
- **Using State with Context**
- **Updating Values in Context**
- **Custom Data Fetching Hook**
- **Intro to React Router**
- **createBrowserRouter**
- **Setting up Routes**
- **Nested/Child Routes**
- **Outlet**
- **Link Component**
- **useNavigate Hook**
- **Navigating Programmatically**
- **Passing State to Route**
- **Intro to Unit Testing with Vitest**
- **Setting up Vitest & React Testing Library**
- **Configuring vite.config.js for testing**
- **Create setupTests.js file**
- **Writing our First Test**
- **Rendering Component Under Test**
- **Snapshot Testing**
- **Using Screen to Query Elements**
- **getByText query**
- **Understanding getBy vs queryBy queries**
- **findBy queries**
- **findByText example**
- **More examples of Testing**
- **Using getByRole to query Buttons**
- **Firing User Events**
- **Simulating Click Event**
- **Querying for Input Elements**
- **getByLabelText example**
- **Testing Multiple Elements of Same Instances**
- **Data Test IDs**
- **getByTestId example**
- **using within() to search elements inside an HTML Element**
- **Simulating type event**
- **Other queries**
- **Testing Component with Context API**
- **Using Mock Service Worker to Mock API Requests**

## What is React.js?

React.js is a popular open-source JavaScript library used for building `user interfaces`, particularly single-page applications where data changes dynamically over time.
It allows developers to create large web applications that can change data, without reloading the page. React is maintained by Facebook and a community of individual developers and companies.

## History and Background

React was created by Jordan Walke, a software engineer at Facebook. It was first deployed on Facebook's news feed in 2011 and later on Instagram in 2012.
React was open-sourced at JSConf US in May 2013. The library's innovative use of a virtual DOM and a component-based architecture has significantly influenced the web development landscape.

## Key Features and Benefits

- **Virtual DOM**: React uses a virtual DOM to optimize updates and rendering, improving performance.
- **Component-Based**: Build encapsulated components that manage their own state, then compose them to make complex UIs.
- **Declarative**: React makes it painless to create interactive UIs. Design simple views for each state in your application, and React will efficiently update and render the right components when your data changes.
- **Learn Once, Write Anywhere**: You can develop new features in React without rewriting existing code. React can also render on the server using Node and power mobile apps using React Native.

## Installation and Setup

To start working with React, you need to have `Node.js and npm (Node Package Manager)` installed on your system. Here’s a step-by-step guide:

- ### Step 1: Install Node.js and npm

Download and install Node.js from the [official Node.js website](https://nodejs.org/). npm is included with Node.js, so it will be installed automatically.

- ### Step 2: Install Create React App or use VITE

Create React App or vite@latest is a tool that sets up a new React project with a default template, making it easy to get started.

Open your terminal and run the following command to install Create React App globally:

```sh
npm install -g create-react-app
```

- ### Step 3: Create a New React Project

Run the following command in your terminal to create a new React project:

```sh

npx create-react-app my-first-react-app
or
npm create vite@latest my-first-react-app --template react

Replace `my-first-react-app` with your desired project name.
```

- ### Step 4: Navigate to Your Project Directory

Change to your project directory with:

```sh
cd my-first-react-app
```

- ### Step 5: Start the Development Server

Run the following command to start the development server:

```sh
npm start or npm run dev
```
