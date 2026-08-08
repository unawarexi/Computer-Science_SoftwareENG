class BankSystem {
  // Private variables
  String _accountHolder;
  double balance;
  String _accountNumber;

  BankSystem(String accountHolder, String accountNumber, double initialBalance)
      : _accountHolder = accountHolder,
        _accountNumber = accountNumber,
        balance = initialBalance; // Initialize balance directly

  void deposit(double amount) {
    if (_accountHolder == "andrew") {
      balance += amount;
      print("Deposit successful. Current balance: \$${balance}");
    } else {
      print("Account not found or registered.");
    }
  }

  void withdraw(double amount) {
    if (balance >= amount) {
      balance -= amount;
      print("Withdrawal successful. Current balance: \$${balance}");
    } else {
      print("Insufficient balance or account not found.");
    }
  }

  void checkBalance() {
    print("Account Holder: $_accountHolder");
    print("Account Number: $_accountNumber");
    print("Current Balance: \$${balance}");
  }
}

void main() {
  // Create a new account for Andrew
  BankSystem andrewAccount = BankSystem("andrew", "2847847872", 5000.0);

  andrewAccount.checkBalance();
  andrewAccount.deposit(1000);
  andrewAccount.withdraw(10000);
  andrewAccount.checkBalance();
}
