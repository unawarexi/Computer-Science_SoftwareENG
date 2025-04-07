# React API Handling Guide

This guide provides an overview of how to handle API requests in a React application. It includes information on popular libraries and different ways to implement API handling.

## Table of Contents

1. [Introduction](#introduction)
2. [Using Fetch API](#using-fetch-api)
3. [Using Axios](#using-axios)
4. [Using React Query](#using-react-query)
5. [Handling API Errors](#handling-api-errors)
6. [Optimistic Updates](#optimistic-updates)
7. [Conclusion](#conclusion)

## Introduction

Handling API requests is a common task in React applications. There are multiple ways to fetch data and interact with APIs, including using the native

- **Fetch API**,
- **Axios**,
- **and more advanced libraries like `React Query`**.
  This guide covers these methods with examples.

## Using Fetch API

The Fetch API is a built-in JavaScript API for making HTTP requests. It's simple and doesn't require any additional libraries.

### Example

```jsx
import React, { useState, useEffect } from 'react';

function App() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('https://api.example.com/data')
      .then(response => response.json())
      .then(data => {
        setData(data);
        setLoading(false);
      })
      .catch(error => console.error('Error fetching data:', error));
  }, []);
 return (
    // other codes map logic to display  in the browser
 )
}

export default App;
```

## Using Axios

Axios is a popular `HTTP client library` that makes it easier to make API requests and handle responses.

#### Installation

```bash
npm install axios
```

```jsx
import React, { useState, useEffect } from 'react';
import axios from 'axios';

function App() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // using axios
    axios.get('https://api.example.com/data')
      .then(response => {
        setData(response.data);
        setLoading(false);
      })
      .catch(error => console.error('Error fetching data:', error));
  }, []);

 return (
    // other codes to display in browser
 )
}

export default App;
```

## Using React Query

React Query is a powerful library for `data fetching`, `caching`, and `synchronization` in React applications.

#### Installation

```bash
npm install @tanstack/react-query
```

```jsx
import React from 'react';
import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

const fetchData = async () => {
  const { data } = await axios.get('https://api.example.com/data');
  return data;
};

function App() {
  const { data, error, isLoading } = useQuery(['data'], fetchData);

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error fetching data</div>;
  }

  return (
    // mapped data for browser
  );
}

export default App;
```

## Handling API Errors

Handling errors is crucial for a robust application. Both Axios and Fetch API allow you to catch errors and handle them appropriately.

- **fetch = !response(data.ok)**
- **axios = try and catch**

```jsx
// .then is a way of error handling try and catch
// note that "response.ok is only for fetch"

useEffect(() => {
  fetch("https://api.example.com/data")
    // .then(response => {
    //     //---------------- this is for fetch api
    //   if (!response.ok) {
    //     throw new Error('Network response was not ok');
    //   }
    //   return response.json();
    // })

    // -------------------- for axios go straight to this no need for "response.ok
    .then((data) => {
      setData(data);
      setLoading(false);
    })
    .catch((error) => {
      console.error("Fetch error:", error);
      setLoading(false);
    });
}, []);
```
