import 'package:hive/hive.dart';
import 'package:worthy/Hive/Transaction_Details.dart';

part "planned_payment_info.g.dart";

@HiveType(typeId: 50)
class PlannedPaymentInfo {
  @HiveField(0)
  late Transactions transaction;
  @HiveField(1)
  late int dailyFreq;
  @HiveField(2)
  late DateTime startDate;
  @HiveField(3)
  late DateTime endDate;
  @HiveField(4)
  late List<bool> weekDays;
  @HiveField(5)
  late int version = 1;

  PlannedPaymentInfo({
    required this.transaction,
    required this.dailyFreq,
    required this.startDate,
    required this.endDate,
    required this.weekDays,
  });
}
