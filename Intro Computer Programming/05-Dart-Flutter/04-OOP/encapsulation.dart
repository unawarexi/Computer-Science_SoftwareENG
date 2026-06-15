// Encapsulation Example
class BankAccount {
  // ignore: unused_field (acct num)
  String _accountNumber; // Private field
  double _balance; // Private field

  BankAccount(this._accountNumber, this._balance);

  // Public method to get balance
  double getBalance() {
    return _balance;
  }

  // Private method to set balance
  void _setBalance(double amount) {
    _balance = amount;
  }
}

// Function to demonstrate Encapsulation
void demonstrateEncapsulation() {
  BankAccount account = BankAccount("123456", 1000.0);
  print("Balance: ${account.getBalance()}");
}

void main() {
  demonstrateEncapsulation();
}
