/*
 * Async-Await in Dart:
 * 
 * Async-await is used to handle asynchronous operations in Dart.
 * When a function is marked with `async`, it returns a Future, and you can use `await`
 * inside that function to wait for asynchronous operations to complete.
 * 
 * - `await` keyword pauses the execution of the function until the awaited Future is resolved.
 * - Use async-await to avoid blocking the main thread while waiting for long-running tasks.
 */

// Function demonstrating async-await to fetch data after a delay
Future<void> fetchData() async {
  // Prints the message before the delay (operation starts)
  print('Fetching data...');

  // Pauses for 2 seconds (simulating an asynchronous task)
  await Future.delayed(const Duration(seconds: 2));

  // Prints the message after the delay (operation completes)
  print('Data fetched.');
}

// Function returning a Future with a delayed result
Future<int> fetchNumber() {
  // Returns a Future that completes with the value 42 after a 2-second delay
  return Future.delayed(const Duration(seconds: 2), () => 42);
}

/*
 * The main function, marked as `async`, because we're using `await`.
 * We must mark `main` async when awaiting inside it.
 */
void main() async {
  // Calling fetchNumber() and awaiting the result, as it's a Future.
  int number = await fetchNumber();

  // Output the number fetched after 2 seconds.
  print(number); // Output: 42 after 2 seconds delay
}
