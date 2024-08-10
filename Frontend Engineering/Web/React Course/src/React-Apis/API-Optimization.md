## Optimistic Updates

Optimistic updates can make your application feel faster by updating the UI before the server confirms the change.

Example with React Query

```jsx
import React from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import axios from "axios";

const updateData = async (newData) => {
  const { data } = await axios.put("https://api.example.com/data", newData);
  return data;
};

function App() {
  const queryClient = useQueryClient();
  const mutation = useMutation(updateData, {
    onMutate: async (newData) => {
      await queryClient.cancelQueries(["data"]);
      const previousData = queryClient.getQueryData(["data"]);
      queryClient.setQueryData(["data"], (old) => [...old, newData]);
      return { previousData };
    },

    onError: (error, newData, context) => {
      queryClient.setQueryData(["data"], context.previousData);
    },

    onSettled: () => {
      queryClient.invalidateQueries(["data"]);
    },
  });

  const handleUpdate = () => {
    mutation.mutate({ id: 1, name: "Updated Name" });
  };

  return (
    <div>
      <button onClick={handleUpdate}>Update Data</button>
    </div>
  );
}

export default App;
```
