import 'package:hive/hive.dart';
import 'package:worthy/Hive/Transaction_Details.dart';
import 'package:worthy/Hive/accounts.dart';
import 'package:worthy/Hive/planned_payment_info.dart';
// import 'package:worthy/Hive/planned_payments.dart';

late Box<TransactionDetails> transactionDetails;
late Box<Account> accountsBox;
late Box<double> balanceBox;
late Box<Account> catagories;
late Box<PlannedPaymentInfo> plannedPaymentInfoBox;
