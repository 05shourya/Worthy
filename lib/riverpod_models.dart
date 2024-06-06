import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:worthy/Hive/Boxes.dart';
import 'package:worthy/Hive/Transaction_Details.dart';
import 'package:worthy/Hive/accounts.dart';

final transactionInfo = ChangeNotifierProvider<TransactionInfoModel>((ref) {
  return TransactionInfoModel();
});

final accountsInfo = ChangeNotifierProvider((ref) => AccountsInfoModel());
final balanceInfo = ChangeNotifierProvider((ref) => BalanceInfo());
final timePeriodInfo = ChangeNotifierProvider((ref) => TimePeriodNotifier());

List<TransactionDetails> _getTransactions(
    DateTime startDate, DateTime endDate) {
  List<TransactionDetails> listOfTransactions = [];
  DateTime currDate = startDate;
  String dateKey;
  while (currDate.isBefore(endDate) || currDate.isAtSameMomentAs(endDate)) {
    dateKey = "${currDate.day}-${currDate.month}-${currDate.year}";
    final transaction = transactionDetails.get(dateKey);
    if (transaction != null) {
      listOfTransactions.add(transaction);
    }
    currDate = currDate.add(const Duration(days: 1));
  }
  listOfTransactions.sort((a, b) => a.date.compareTo(b.date));
  return listOfTransactions;
}

class TimePeriodNotifier extends ChangeNotifier {
  DateTime _timePeriod = DateTime.now();
  DateTime get timePeriod => _timePeriod;

  void updateTime(DateTime updatedTime) {
    _timePeriod = updatedTime;
    notifyListeners();
  }
}

class TransactionInfoModel extends ChangeNotifier {
//   double availableBalance = balanceBox.get('balance') ?? 0;
  double get balance {
    return balanceBox.get('balance') ?? 0;
  }

  void addTransaction(Box<TransactionDetails> box, Transactions transaction) {
    var date = transaction.time;
    var dateKey = "${date.day}-${date.month}-${date.year}";
    var dayTransactions = box.get(dateKey);
    AccountsInfoModel acc = AccountsInfoModel();

    updateBalance(transaction.amount, transaction.isDebit);
    acc.updateAccountBalance(transaction.account, transaction.amount,
        transaction.isDebit, accountsBox);
    acc.updateAccountBalance(transaction.catagory, transaction.amount,
        transaction.isDebit, catagories);

    dayTransactions ??= TransactionDetails(
        date: DateTime(
          date.year,
          date.month,
          date.day,
        ),
        transactions: []);
    dayTransactions.transactions.add(transaction);
    box.put(dateKey, dayTransactions);

    // availableBalance = balanceBox.get('balance') ?? 0;
    notifyListeners();
  }

  void clearAllTransactions() {
    transactionDetails.clear();
    notifyListeners();
  }

  void deleteTransaction(
    Box<TransactionDetails> box,
    String key,
    int transactionIndex,
  ) {
    var dayTransactions = box.get(key);
    var transactions = dayTransactions!.transactions;
    DateTime date = dayTransactions.date;
    var transaction = transactions[transactionIndex];
    AccountsInfoModel acc = AccountsInfoModel();
    updateBalance(transaction.amount, !transaction.isDebit);
    acc.updateAccountBalance(transaction.account, transaction.amount,
        !transaction.isDebit, accountsBox);
    acc.updateAccountBalance(transaction.catagory, transaction.amount,
        !transaction.isDebit, catagories);
    transactions.removeAt(transactionIndex);

    // balanceBox.put('balance', currBalance - transactionAmount);

    box.put(
      key,
      TransactionDetails(date: date, transactions: transactions),
    );
    if (transactions.isEmpty) {
      box.delete(key);
    }
    notifyListeners();
  }

  List<TransactionDetails> getTransactions(
      DateTime startDate, DateTime endDate) {
    return _getTransactions(startDate, endDate);
  }
}

class AccountsInfoModel extends ChangeNotifier {
  void addAccount(Account account) {
    accountsBox.put(account.accountName, account);
    updateBalance(account.amount, false);
    notifyListeners();
  }

  void addCatagory(Account catagory) {
    catagories.put(catagory.accountName, catagory);
    notifyListeners();
  }

  void deleteCategory(Account category) {
    var box = transactionDetails;
    for (var key in box.keys) {
      var val = box.get(key);

      for (int i = val!.transactions.length - 1; i >= 0; i--) {
        var elem = val.transactions[i];
        if (elem.catagory == category.accountName) {
          val.transactions[i].catagory = "Others";
        }
      }
    }
    catagories.delete(category.accountName);
    notifyListeners();
  }

  void deleteAccount(Account account) {
    var box = transactionDetails;
    for (var key in box.keys) {
      var val =
          box.get(key); // Retrieve the value associated with the current key

      for (int i = val!.transactions.length - 1; i >= 0; i--) {
        var elem = val.transactions[i];
        if (elem.account == account.accountName) {
          val.transactions.removeAt(i);
        }
      }
      if (val.transactions.isEmpty) {
        box.delete(key);
      }
    }

    var balance = balanceBox.get('balance');
    if (balance != null) {
      balance -= account.amount;
      balanceBox.put('balance', balance);
    } else {
      balanceBox.put('balance', 0);
    }

    accountsBox.delete(account.accountName);
    notifyListeners();
  }

  void updateAccountBalance(
      String accountName, double amount, bool isDebit, Box<Account> box) {
    Account? account = box.get(accountName);
    if (account != null) {
      if (isDebit) {
        account.totalDebit += amount;
        account.amount -= amount;
      } else {
        account.totalCredit += amount;
        account.amount += amount;
      }
      box.put(
        accountName,
        account,
      );
    }
    notifyListeners();
  }

  void deleteAllAccounts() {
    accountsBox.clear();
    notifyListeners();
  }
}

void updateBalance(double amount, bool isDebit) {
  // ignore: prefer_typing_uninitialized_variables
  var balance;
  if (!balanceBox.containsKey("balance")) {
    balanceBox.put("balance", 0);
  }
  if (isDebit) {
    balance = balanceBox.get('balance');
    if (balance != null && balance > amount) {
      balance = balance - amount;
    }
  } else {
    balance = balanceBox.get('balance');
    balance = balance != null ? balance + amount : null;
  }
  balanceBox.put('balance', balance);
}

class BalanceInfo extends ChangeNotifier {
  double credit(
    String account,
    DateTime startDate,
    DateTime endDate,
  ) {
    List<TransactionDetails> transactions =
        _getTransactions(startDate, endDate);
    double x = 0;
    for (var elem in transactions) {
      for (var val in elem.transactions) {
        if (!val.isDebit && (val.account == account || account == "")) {
          x += val.amount;
        }
      }
    }
    return x;
  }

  double debit(
    String account,
    DateTime startDate,
    DateTime endDate,
  ) {
    List<TransactionDetails> transactions =
        _getTransactions(startDate, endDate);
    double x = 0;

    for (var elem in transactions) {
      for (var val in elem.transactions) {
        if (val.isDebit && (val.account == account || account == "")) {
          x += val.amount;
        }
      }
    }
    return x;
  }
}
