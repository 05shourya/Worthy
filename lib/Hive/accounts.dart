import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part "accounts.g.dart";

@HiveType(typeId: 10)
class Account {
  @HiveField(0)
  late String accountName;
  @HiveField(1)
  late double amount;
  @HiveField(2)
  late double totalCredit;
  @HiveField(3)
  late double totalDebit;
  @HiveField(4)
  late List<int> rgb;
  @HiveField(5)
  late int version = 1;

  Account({
    required this.accountName,
    required this.amount,
    required this.totalCredit,
    required this.totalDebit,
    required this.rgb,
  });
  Color get color {
    return Color.fromARGB(255, rgb[0], rgb[1], rgb[2]);
  }

  Color get textColor {
    final luminance = color.computeLuminance();
    return luminance > .5 ? Colors.black : Colors.white;
  }
}
