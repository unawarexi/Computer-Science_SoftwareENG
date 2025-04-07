/**
 * Type Conversion in Dart with Collection Types and Null Safety
 * Dart supports type conversions for both primitive types and collections.
 * 
 * - Primitive types: String, int, double, bool
 * - Collection types: List, Set, Map
 * 
 * Null safety:
 * - Dart's null safety feature ensures that variables are non-null by default.
 * - Use `?` to allow null values and `!` to assert that a value is non-null.
 */

// ------- Primitive Type Conversions ------- //

// String to int
void stringToInt() {
  String ageString = "25";
  int age = int.parse(ageString); // Parsing string to int
  print("String to int: $age"); // Outputs: 25
}

// int to String
void intToString() {
  int age = 25;
  String ageString = age.toString(); // Converting int to string
  print("Int to String: $ageString"); // Outputs: "25"
}

// double to int
void doubleToInt() {
  double height = 5.9;
  int roundedHeight = height.toInt(); // Rounds down double to int
  print("Double to int: $roundedHeight"); // Outputs: 5
}

// ------- Collection Type Conversions ------- //

// List to Set (removes duplicates)
void listToSet() {
  List<int> numbers = [1, 2, 3, 1, 2]; // List with duplicates
  Set<int> uniqueNumbers = numbers.toSet(); // Converting list to set
  print("List to Set: $uniqueNumbers"); // Outputs: {1, 2, 3}
}

// Set to List
void setToList() {
  Set<String> fruitSet = {'Apple', 'Banana', 'Orange'};
  List<String> fruitList = fruitSet.toList(); // Converting set to list
  print("Set to List: $fruitList"); // Outputs: [Apple, Banana, Orange]
}

// Map to List (convert map keys and values to separate lists)
void mapToList() {
  Map<String, int> scores = {'Alice': 90, 'Bob': 85};
  List<String> names = scores.keys.toList(); // Extracting keys (names)
  List<int> marks = scores.values.toList(); // Extracting values (scores)
  print("Map keys to List: $names"); // Outputs: [Alice, Bob]
  print("Map values to List: $marks"); // Outputs: [90, 85]
}

// ------- Null Safety in Dart ------- //

/**
 * Dart supports null safety to avoid null pointer exceptions.
 * - Variables are non-nullable by default.
 * - To allow null values, use `?`.
 * - Use the `??` operator to provide a fallback for null values.
 */

// Null-aware operator and null safety
void nullSafetyExample() {
  String? name; // Nullable string
  String greeting = name ?? 'Guest'; // If 'name' is null, use 'Guest'
  print("Greeting: $greeting"); // Outputs: Guest
}

// ------- Custom Data Type (Class) ------- //

class User {
  String name;
  int age;

  // Constructor with 'this' keyword to access class properties
  User(this.name, this.age);
}

// Function to demonstrate creating and using custom data types
void createUser() {
  User user = User("Alice", 30); // Creating an instance of User class
  print("User created: Name - ${user.name}, Age - ${user.age}");
  // Outputs: "User created: Name - Alice, Age - 30"
}

// ------- Main Function ------- //

void main() {
  // Primitive type conversions
  stringToInt();
  intToString();
  doubleToInt();

  // Collection type conversions
  listToSet();
  setToList();
  mapToList();

  // Null safety example
  nullSafetyExample();

  // Creating and working with a custom data type
  createUser();
}
