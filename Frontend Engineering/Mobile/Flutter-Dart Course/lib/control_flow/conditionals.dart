/**
 * Conditional Control Flow in Dart
 * Dart offers various control flow mechanisms to handle decisions:
 * - if-else statements
 * - ternary (conditional) operators
 * - null-aware operators
 * - switch statements
 */

// Function demonstrating if-else-if-else control flow
void ifElseControlFlow(int score) {
  // if-else-if-else: Evaluates conditions sequentially
  if (score > 90) {
    print('Excellent!');
  } else if (score > 75) {
    print('Great!');
  } else {
    print('Good effort!'); // Executes for score <= 75
  }
}

// Function demonstrating the ternary operator
void ternaryOperator(int score) {
  // Ternary operator: Short form of if-else
  String result = score > 90 ? 'Excellent' : 'Good effort';
  print(
      "Ternary Operator Result: $result"); // Outputs 'Good effort' if score <= 90
}

// Function demonstrating the null-aware operator
void nullAwareOperator() {
  // The null-aware operator (??) checks for null values
  String? name; // Nullable String (can be null)
  String greeting = name ?? 'Guest'; // Uses 'Guest' if name is null
  print("Greeting: $greeting"); // Outputs: Guest
}

// Function demonstrating switch statements
void switchStatement(String grade) {
  // Switch statement: Useful for comparing discrete values
  switch (grade) {
    case 'A':
      print('Excellent!');
      break;
    case 'B':
      print('Good');
      break;
    case 'C':
      print('Fair');
      break;
    default:
      print('Invalid grade');
  }
}

// Main function where all control flow demonstrations are called
void main() {
  // Example usage of if-else control flow
  int score = 75;
  ifElseControlFlow(score); // Outputs: Good effort!

  // Example usage of the ternary operator
  ternaryOperator(score); // Outputs: Good effort

  // Example usage of the null-aware operator
  nullAwareOperator(); // Outputs: Guest

  // Example usage of switch statements
  String grade = 'B';
  switchStatement(grade); // Outputs: Good
}
