// Bank account class
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 26_bank_account_class.dart

class BankAccount {
  final String owner;
  double _balance = 0;

  BankAccount(this.owner);

  double get balance => _balance;

  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit must be positive');
    _balance += amount;
  }

  void withdraw(double amount) {
    if (amount > _balance) throw StateError('Insufficient funds');
    _balance -= amount;
  }
}

void main() {
  var account = BankAccount('Asha');
  account.deposit(500);
  account.withdraw(120);
  print('${account.owner}: ${account.balance}');

  try {
    account.withdraw(1000);
  } on StateError catch (e) {
    print('Error: ${e.message}');
  }
}
