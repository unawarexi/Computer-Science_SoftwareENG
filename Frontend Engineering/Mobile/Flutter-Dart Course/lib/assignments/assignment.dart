void userCheck() {
  String userName = "Rejoice";
  int userAge = 15;

  int ageRequired = 18;

  if (userAge >= ageRequired) {
    print("Hi $userName, you're eligible.");
  } else {
    print("Hi $userName, sorry, you're not old enough.");
  }
}

void main() {
  userCheck(); // Call the function to test it
}
