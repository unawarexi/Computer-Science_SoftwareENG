void main() {
  /**
 * Dart provides several types of loops for different use cases:
 * 1. for loop: Used when the number of iterations is known.
 * 2. for-in loop: Used to iterate over collections like lists.
 * 3. while loop: Continues to execute as long as the condition remains true.
 * 4. do-while loop: Executes at least once, and then checks the condition.
 */

// for loop
  for (int i = 0; i < 5; i++) {
    print(i); // Outputs 0 to 4
  }

/**
 * for-in loop: Iterates over collection datatypes like List, Set, etc.
 * Commonly used to traverse through elements of a collection.
 */
  List<String> fruits = ['Apple', 'Banana', 'Orange'];

  for (var fruit in fruits) {
    print(fruit); // Outputs Apple, Banana, Orange
  }

/**
 * while loop: Executes as long as the condition is true.
 * Often used when the number of iterations is unknown.
 */
  int i = 0;
  while (i < 5) {
    print(i); // Outputs 0 to 4
    i++;
  }

/**
 * do-while loop: Similar to the while loop but guarantees
 * the code inside the loop runs at least once.
 */
  i = 0; // Resetting the counter
  do {
    print(i); // Outputs 0 to 4
    i++;
  } while (i < 5);
}
