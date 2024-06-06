import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'Transaction_Details.g.dart'; // This should match the generated file's name

@HiveType(typeId: 0)
class TransactionDetails {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late List<Transactions> transactions;

  @HiveField(2)
  late int version = 1;

  TransactionDetails({
    required this.date,
    required this.transactions,
  });
}

@HiveType(typeId: 2)
class Transactions {
  @HiveField(0)
  late double amount;
  @HiveField(1)
  late bool isDebit;
  @HiveField(2)
  late String catagory;
  @HiveField(3)
  late String account;
  @HiveField(4)
  late String note;
  @HiveField(5)
  late DateTime time;
  @HiveField(6)
  late String title;

  Transactions({
    required this.amount,
    required this.isDebit,
    required this.catagory,
    required this.account,
    this.note = "",
    required this.time,
    required this.title,
  });
}
