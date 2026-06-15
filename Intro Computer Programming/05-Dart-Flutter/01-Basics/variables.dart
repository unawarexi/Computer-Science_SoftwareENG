/*================================= 
 * Types of Variables and Declarations 
 *=================================
 * 1. Declarations
 *    - We have mutable and immutable variables. 
 *    - Mutable variables can be changed, while immutable variables cannot be changed after declaration.
 * 
 * 2. Scopes
 *    - Variables can have two types of scopes: global and local.
 * 
 * 3. Nullable / Non-nullable
 *    - Variables can be either nullable or non-nullable.
 */

// ================== Normal (Explicit Type) Declarations ================== //
String stringVariable = "This is a string declaration";
int integerVariable = 100000;
double doubleNumber = 3.14;

// ======================= Mutable Declarations ======================= //

/*
 * 1. Use the "var" declaration when you want Dart to automatically infer the type.
 *    - Note: You cannot change the type of a "var" once it's assigned.
 * 
 * 2. "dynamic" declaration: Holds different data types during runtime.
 */
var nonMutableVar = "This is mutable";
// nonMutableVar = "The value can't be changed to another datatype"; // Error: value can't be reassigned a new type

dynamic data = "This can be changed during runtime";
// data = 750000;  // It can hold a different data type later

// ======================= Immutable Declarations ======================= //
// "final" can be assigned a value at runtime, while "const" must be assigned at compile-time.
final String constantVariable = "This cannot be changed";
// const String constantVariable ="800000"; // Error: the variable can't be reassigned

// ========================== Type Inference ========================== //
// Dart automatically infers a datatype based on the value passed.
var stringName = "My name is Andrew";
var integerNum = 75000;

// ========================== Variable Scope ========================== //

// -------- Global Scope --------
String globalVar = "This is a global variable";
String printGlobal() {
  // This is accessible from outside the block scope
  return globalVar;
}

// -------- Local Scope --------
void main() {
  // These are local scope variables
  // Explicit type declarations
  String productName = "Mobile Phone";
  int price = 750000;
  int quantity = 4;

  int totalPrice = price * quantity;
  // int stockAvailable = 10;

  print("Product: $productName");
  print("Price: $price");
  print("Quantity: $quantity");
  print("Total Price: $totalPrice");
}

// ====================== Null Variables ====================== //

// -------- Nullable --------
int? birthDate; // This is null initially due to the "?" operator
// birthDate = 40; // Can be reassigned a value later

// -------- Non-nullable --------
String handsome = "Andrew"; // This is automatically non-nullable
// handsome = null; // Error: Cannot assign null to a non-nullable variable
