// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:worthy/Add%20Data%20Screens/add_transaction.dart';
import 'package:worthy/Hive/Boxes.dart';
import 'package:worthy/Hive/Transaction_Details.dart';
import 'package:worthy/main.dart';
import 'package:worthy/riverpod_models.dart';
import 'package:intl/intl.dart';

List<Widget> widgetsList = [];

class DayWiseInfo extends ConsumerWidget {
  const DayWiseInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionInfoModel = ref.watch(transactionInfo);
    final timePeriod = ref.watch(timePeriodInfo);
    final _dayTransactions = transactionInfoModel.getTransactions(
        timePeriod.timePeriod,
        timePeriod.timePeriod.add(const Duration(days: 30)));
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      reverse: true,
      itemBuilder: (context, dayIndex) {
        String key = transactionDetails.keyAt(dayIndex);
        // var dayTransactions = transactionDetails.get(key);
        var dayTransactions = _dayTransactions[dayIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                DateFormat("d MMM yyyy").format(dayTransactions.date),
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
            ),
            // Thin line
            Container(
              width: MediaQuery.of(context).size.width * .9,
              height: 1.0,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
            ),
            // List of transactions
            ListView.builder(
              reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, transactionIndex) {
                var transaction =
                    dayTransactions.transactions[transactionIndex];
                return TransactionItem(
                  transaction: transaction,
                  transactionIndex: transactionIndex,
                  deleteSelf: () {
                    transactionInfoModel.deleteTransaction(
                        transactionDetails, key, transactionIndex);
                  },
                );
              },
              itemCount: dayTransactions.transactions.length,
            ),
          ],
        );
      },
      itemCount: _dayTransactions.length,
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transactions transaction;
  final Function deleteSelf;
  final int transactionIndex;
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.deleteSelf,
    required this.transactionIndex,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        // splashColor: Colors.transparent,
        onTap: () {
          viewTransaction(context, transaction, transactionIndex);
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: transaction.isDebit
                ? MyApp.debitColor.withOpacity(.7)
                : MyApp.creditColor.withOpacity(.7),
            // color: Color.fromARGB(76, 158, 158, 158),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(
              minHeight: 140,
            ),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 15,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          height: 40,
                          constraints: const BoxConstraints(
                            minWidth: 60,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              transaction.catagory,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 18, 20, 37),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 100,
                          ),
                          child: Center(
                            child: Text(
                              transaction.account,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (transaction.title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        transaction.title,
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 10),
                    child: Row(
                      children: [
                        Icon(
                          transaction.isDebit ? Icons.remove : Icons.add,
                          color: Colors.black,
                          size: 25,
                        ),
                        Text(
                          "${transaction.amount.toString()} INR",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15, bottom: 8),
                        child: Text(
                          DateFormat('h:mm a').format(transaction.time),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  viewTransaction(
    context,
    Transactions transaction,
    int transactionIndex,
  ) {
    String title =
        transaction.title.isNotEmpty ? transaction.title : "Untitled";
    String accountName = transaction.account;

    var account = accountsBox.get(accountName);

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat("MMM DD yyyy, hh:mm").format(transaction.time),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width * .7,
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    infoItem(context, account!.accountName, account.color,
                        account.textColor),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      transaction.isDebit ? Icons.remove : Icons.add,
                      size: 30,
                      color: transaction.isDebit
                          ? MyApp.debitColor
                          : MyApp.creditColor,
                    ),
                    Text(
                      "${transaction.amount} INR",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: transaction.isDebit
                              ? MyApp.debitColor
                              : MyApp.creditColor),
                    ),
                  ],
                ),
                if (transaction.note.isNotEmpty) const Spacer(),
                Text(
                  transaction.note,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.grey),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        var date = transaction.time;
                        var dateKey = "${date.day}-${date.month}-${date.year}";
                        var transactions = ref.watch(transactionInfo);
                        return actionButton(
                          context,
                          transaction,
                          "Delete",
                          Colors.red,
                          () {
                            transactions.deleteTransaction(
                                transactionDetails, dateKey, 0);
                            Navigator.pop(context);
                          },
                          Icons.delete,
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        var date = transaction.time;
                        var dateKey = "${date.day}-${date.month}-${date.year}";
                        return actionButton(
                          context,
                          transaction,
                          "Edit",
                          transaction.isDebit
                              ? MyApp.debitColor
                              : MyApp.creditColor,
                          () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: AddTransaction(
                                  accountName: transaction.account,
                                  catagoryName: transaction.catagory,
                                  date: transaction.time,
                                  time:
                                      TimeOfDay.fromDateTime(transaction.time),
                                  amount: transaction.amount,
                                  note: transaction.note,
                                  title: transaction.title,
                                  comingFrom: "Edit",
                                  transactionBoxKey: dateKey,
                                  transactionIndex: transactionIndex,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          Icons.edit,
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget infoItem(context, String info, Color color, Color textColor) {
    return Container(
      width: 110,
      height: 35,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: textColor),
          info,
        ),
      ),
    );
  }

  Widget actionButton(
    context,
    Transactions transaction,
    String buttonText,
    Color borderColor,
    Function onTapFunct,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        splashColor: Colors.green,
        onTap: () {
          onTapFunct();
        },
        child: Container(
          width: MediaQuery.of(context).size.width * .4,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              width: 2,
              color: borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                buttonText,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Colors.white),
              ),
              Icon(
                icon,
                size: 30,
                color: borderColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
