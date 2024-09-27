void userCheck([String userName = "Rejoice", int userAge = 12]) {
  int ageRequired = 18;

  if (userAge >= ageRequired) {
    print("Hi $userName, you're eligible.");
  } else {
    print("Hi $userName, sorry, you're not old enough.");
  }
}

void main() {
  userCheck();
  userCheck("John", 20);
}
