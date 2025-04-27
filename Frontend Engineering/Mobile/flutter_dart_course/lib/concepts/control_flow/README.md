# Dart & Flutter Control Flows

Control flow statements are fundamental in Dart, just like in any programming language. They allow the execution of code to be conditionally altered, repeated, or branched based on certain conditions or inputs. This document covers all the key control flow concepts used in Dart and Flutter applications.

---

## Table of Contents

1. [Conditional Statements](#conditional-statements)
   - [if and else](#if-and-else)
   - [else if](#else-if)
   - [Conditional Expressions](#conditional-expressions)
2. [Switch Statements](#switch-statements)
3. [Loops](#loops)
   - [for Loop](#for-loop)
   - [for-in Loop](#for-in-loop)
   - [while Loop](#while-loop)
   - [do-while Loop](#do-while-loop)
4. [Exception Handling](#exception-handling)
   - [try-catch](#try-catch)
   - [finally](#finally)
5. [Break and Continue](#break-and-continue)
6. [Asynchronous Control Flows](#asynchronous-control-flows)
   - [async and await](#async-and-await)
   - [Future](#future)
7. [Summary](#summary)

---

## Conditional Statements

Conditional statements are used to perform different actions based on different conditions.

### if, else-if and else

- `if` is the primary conditional statement used in Dart. If the condition evaluates to true, the code block inside the `if` will be executed. Otherwise, the code inside `else` is executed.


- `else if`
else if allows you to check multiple conditions in sequence. The first condition that evaluates to true gets executed.



- **Example**:
  ```dart
  int score = 80;
  
  if (score > 90) {
    print('Excellent!');
  } else {
    print('Good effort!');
  }
  ```

## Conditional Expressions
**Ternary Operator**: A shorthand for if-else that returns a value based on a condition.
**Null-aware Operator**: Used to provide a fallback when dealing with nullable values.


## Switch Statements
Switch statements are used for executing one out of many code blocks based on the value of an expression. Switch statements work best with discrete values like enums or integers.

## Loops
Loops are used to repeat a block of code multiple times.

- **for Loop**
The for loop runs a code block a specific number of times.

- **for-in Loop**
Used to iterate over items in a collection (like a List or Set).

- **while Loop**
A while loop runs as long as a specified condition is true.

- **do-while Loop**
Similar to the while loop, but it guarantees that the code block will execute at least once because the condition is evaluated after the loop.


## Break and Continue

- **break**
The break statement is used to exit a loop or switch statement prematurely.

```dart
for (int i = 0; i < 5; i++) {
  if (i == 3) {
    break;  // Loop terminates when i equals 3
  }
  print(i);
}
```

- **continue**
The continue statement skips the current iteration of a loop and proceeds with the next iteration.

```dart
for (int i = 0; i < 5; i++) {
  if (i == 3) {
    continue;  // Skips printing when i equals 3
  }
  print(i);
}
```