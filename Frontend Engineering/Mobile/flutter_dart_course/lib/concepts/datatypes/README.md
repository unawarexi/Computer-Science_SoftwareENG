# Dart & Flutter Data Types

Dart is a statically typed programming language, meaning that each variable must be declared with a data type. In Flutter, Dart is the primary language, and understanding its data types is essential for app development. This document will cover all the key data types in Dart and how they are used in Flutter.

---

## Table of Contents

1. [Primitive Data Types](#primitive-data-types)
   - [Numbers](#numbers)
     - [int](#int)
     - [double](#double)
   - [Strings](#strings)
   - [Booleans](#booleans)
2. [Collections](#collections)
   - [Lists](#lists)
   - [Sets](#sets)
   - [Maps](#maps)
3. [Null Safety](#null-safety)
4. [Custom Data Types](#custom-data-types)
5. [Type Inference](#type-inference)
6. [Type Conversion](#type-conversion)
7. [Constants](#constants)
8. [Summary](#summary)

---

## Primitive Data Types

Dart provides several built-in primitive data types that are used frequently in Flutter applications.

### Numbers

Dart has two primary types for representing numbers:

#### int
- Represents whole numbers, both positive and negative, without decimals.
- **Example**:
```dart
  int age = 25;
  int negative = -10;
```

#### double
- Represents floating-point numbers, i.e., numbers with decimal points.
```dart

double height = 5.9;
double temperature = -40.5;
```

### Strings
Strings in Dart represent a sequence of characters and are enclosed in single (') or double (") quotes.

```dart
String name = "Flutter Developer";
String greeting = 'Hello, World!';
```
**String Interpolation**: In Dart, you can embed variables or expressions inside strings using ${} or $.

```dart
String name = "Bernhard";
String welcomeMessage = "Hello, $name!";
```

### Booleans
Booleans represent true or false values in Dart, declared using the bool keyword.

```dart
bool isLoggedIn = true;
bool hasError = false;
```

## Collections
Dart provides several ways to manage collections of objects.

### Lists
A List is an ordered collection of objects and can contain duplicate elements.

Dart lists are zero-indexed, meaning the first element is at index 0.

```dart
List<int> numbers = [1, 2, 3, 4, 5];
List<String> names = ["John", "Jane", "Doe"];
```
#### List Operations:

- Add an element: numbers.add(6);
- Access an element by index: numbers[0];
- Length of list: numbers.length;

### Sets
A Set is an unordered collection of unique items, meaning it does not allow duplicate values.

Example:

```dart
Set<String> fruits = {'apple', 'banana', 'orange'};
```
#### Set Operations:
- Add an element: fruits.add('mango');
- Check if an item exists: fruits.contains('apple');

### Maps
A Map is a collection of key-value pairs where each key is unique.

```dart
Map<String, int> scores = {'John': 90, 'Jane': 95, 'Doe': 88};
```
#### Map Operations:

- Access a value by key: scores['John'];
- Add a key-value pair: scores['Alex'] = 85;


### Null Safety
Dart ensures null safety by requiring variables to be explicitly declared nullable using the ? syntax.

```dart
int? age = null;  // Nullable int
Non-nullable variables must always have a value assigned and cannot be null:
```

```dart
int age = 25;  // Non-nullable int
Null-aware 

Dart provides several operators for handling nullable values:
?. — null-aware access: myObject?.method();
?? — null-coalescing operator: myVar = myOtherVar ?? 10;
??= — assigns a value only if the variable is null: x ??= 100;
```


## Custom Data Types
In Dart, you can define custom data types using class.

```dart
class User {
  String name;
  int age;

  User(this.name, this.age);
}

User user = User("Alice", 30);
```

## Type Inference
Dart supports type inference with the var keyword, where Dart infers the type based on the value assigned.

Example:
```dart
var age = 25;  // Dart infers `int`
var name = "Flutter";  // Dart infers `String`
```
For dynamic types, where the type can change, you can use dynamic:

Example:
```dart
dynamic variable = "Hello";
variable = 42;  // Now it holds an integer
```
### Type Conversion
Dart provides functions to convert between types:

String to int:

```dart
String ageString = "25";
int age = int.parse(ageString);
```
int to String:

```dart
int age = 25;
String ageString = age.toString();
```
double to int:

```dart
double height = 5.9;
int roundedHeight = height.toInt();
```

### Constants
Dart allows you to define constants using const and final.

const: Represents compile-time constants.

```dart
const pi = 3.14;
final: Represents runtime constants; can only be assigned once.
```

```dart
final currentTime = DateTime.now();
```
## Summary
- Dart's data types are crucial for Flutter app development.
- Primitive types include int, double, String, bool.
- Collections include List, Set, and Map.
- Dart has strong support for null safety with nullable and non-nullable types.
- Custom data types can be defined using classes.
- Use var for inferred types, and dynamic for types that may change.
- Type conversion and constants (const, final) are essential for proper data handling.
