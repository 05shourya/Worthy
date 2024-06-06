import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:worthy/Hive/Boxes.dart';
import 'package:worthy/Hive/accounts.dart';
import 'package:worthy/Home%20Page/dayWiseInfo.dart';
import 'package:worthy/Home%20Page/money_info.dart';
import 'package:worthy/buttons.dart';
import 'package:worthy/riverpod_models.dart';

class ViewAccount extends StatefulWidget {
  const ViewAccount({Key? key, required this.account, required this.isAccount})
      : super(key: key);
  final Account account;
  final bool isAccount;

  @override
  State<StatefulWidget> createState() {
    return _ViewAccountState();
  }
}

class _ViewAccountState extends State<ViewAccount> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                height: 450,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Handle back button press
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: Text(
                            widget.account.accountName,
                            style: Theme.of(context).textTheme.titleLarge!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            var acc = ref.watch(accountsInfo);
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              child: IconButton(
                                // splashColor: Colors.red,
                                color: Colors.red,
                                icon: const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("You Sure?"),
                                        content: Text(widget.isAccount
                                            ? "Deleting this account will also remove all associated transactions."
                                            : "Deleting this category will move all its transactions to 'Others' category"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (widget.isAccount) {
                                                acc.deleteAccount(widget
                                                    .account); // Call the deleteAccount function
                                              } else {
                                                acc.deleteCategory(
                                                    widget.account);
                                              }
                                              Navigator.pop(
                                                  context); // Close the dialog
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Consumer(builder: (context, ref, child) {
                      var bal = ref.watch(balanceInfo);
                      var timePeriod = ref.watch(timePeriodInfo);
                      return MoneyInfo(
                        // credit: bal.credit(
                        //   widget.account.accountName,
                        //   timePeriod.timePeriod,
                        //   timePeriod.timePeriod.add(const Duration(days: 30)),
                        // ),
                        credit: widget.account.totalCredit,
                        debit: bal.debit(
                          widget.account.accountName,
                          timePeriod.timePeriod,
                          timePeriod.timePeriod.add(const Duration(days: 30)),
                        ),
                        availableBalance: widget.account.amount,
                        isAccount: widget.isAccount,
                      );
                    }),
                    AddTransactionButton(
                      width: MediaQuery.of(context).size.width * .8,
                      margin: 15,
                      accountName: widget.isAccount
                          ? widget.account.accountName
                          : "Account",
                      catagoryName: !widget.isAccount
                          ? widget.account.accountName
                          : "Category",
                      setStateFunc: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              ListOfTransactions(
                accountName: widget.account.accountName,
                isAccount: widget.isAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfTransactions extends ConsumerWidget {
  final String accountName;
  final bool isAccount;
  const ListOfTransactions(
      {Key? key, required this.accountName, required this.isAccount})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionInfoModel = ref.watch(transactionInfo);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      reverse: false,
      itemBuilder: (context, dayIndex) {
        var key = transactionDetails.keyAt(dayIndex);
        var dayTransactions = transactionDetails.get(key);
        if (dayTransactions != null) {
          // Filter transactions for the specified accountName
          var accountTransactions =
              dayTransactions.transactions.where((transaction) {
            return (isAccount)
                ? transaction.account == accountName
                : transaction.catagory == accountName;
          }).toList();
          //   print(isAccount);

          // Only build the UI if there are transactions for the specified accountName
          if (accountTransactions.isNotEmpty) {
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
                // List of transactions for the specified accountName
                ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, transactionIndex) {
                    var transaction = accountTransactions[transactionIndex];
                    return TransactionItem(
                      transactionIndex: transactionIndex,
                      transaction: transaction,
                      deleteSelf: () {
                        transactionInfoModel.deleteTransaction(
                            transactionDetails, key, transactionIndex);
                      },
                    );
                  },
                  itemCount: accountTransactions.length,
                ),
              ],
            );
          }
        }
        // Return an empty container if no transactions or no transactions for the specified accountName
        return Container();
      },
      itemCount: transactionDetails.length,
    );
  }
}
