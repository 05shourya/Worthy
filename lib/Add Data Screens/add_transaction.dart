// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:worthy/Hive/Boxes.dart';
import 'package:worthy/Hive/Transaction_Details.dart';
import 'package:worthy/Hive/accounts.dart';
import 'package:worthy/common_functions.dart';
import 'package:worthy/main.dart';
import 'package:worthy/riverpod_models.dart';

DateTime? date = DateTime.now();
TimeOfDay? time = TimeOfDay.now();
String debitCredit = "Debit";
String catagoryName = "Category";
String accountName = "Account";
Color debitCreditColor = MyApp.debitColor;
Color catagoryColor = const Color.fromARGB(255, 133, 213, 240);
Color accountColor = const Color.fromARGB(255, 68, 238, 238);

class AddTransaction extends StatefulWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final String accountName;
  final String title, note;
  final String catagoryName;
  final DateTime date;
  final TimeOfDay time;
  final double amount;
  Function setStateFunc;
  final String comingFrom;

  //! These variables will be used for deleting transaction after editing
  final String transactionBoxKey;
  final int transactionIndex;

  AddTransaction({
    super.key,
    required this.accountName,
    required this.catagoryName,
    required this.date,
    required this.time,
    this.title = "",
    this.amount = 0,
    this.note = "",
    this.setStateFunc = _defaultFunc,
    this.comingFrom = "main",
    this.transactionBoxKey = "",
    this.transactionIndex = 0,
  });
  static void _defaultFunc() {}

  @override
  State<StatefulWidget> createState() => _AddTransaction();
}

class _AddTransaction extends State<AddTransaction> {
  @override
  void initState() {
    accountName = widget.accountName;
    catagoryName = widget.catagoryName;
    date = widget.date;
    time = widget.time;
    widget.titleController.text = widget.title;
    widget.noteController.text = widget.note;
    if (widget.amount != 0) {
      widget.amountController.text = widget.amount.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildHeader(context),
                const SizedBox(height: 30),
                buildTextField("Title", widget.titleController, 30),
                buildTransactionInfo(),
                const SizedBox(height: 10),
                buildTextField("Note (Optional)", widget.noteController, 25),
                const SizedBox(height: 60),
                AmountInput(fontSize: 60, controller: widget.amountController),
                buildAddButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildBackButton(context),
        const Spacer(),
        TransactionInfoItem(
          showJustBorder: false,
          text: debitCredit,
          icon: Icons.credit_card,
          onTapFunction: () {
            toggleDebitCredit();
          },
          color: debitCreditColor,
          padding: const EdgeInsets.only(right: 10),
        ),
      ],
    );
  }

  Widget buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 2,
            color: const Color.fromARGB(255, 208, 95, 87),
          ),
        ),
        child: const Icon(
          Icons.arrow_back,
          size: 30,
          color: Color.fromARGB(255, 208, 95, 87),
        ),
      ),
    );
  }

  Widget buildTextField(
      String hintText, TextEditingController controller, double fontSize) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: fontSize,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 61, 117, 229),
            width: 2,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 204, 218, 228),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget buildTransactionInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 40, bottom: 40),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [
          buildTransactionInfoItem(
            showJustBorder: catagoryName == "Category" ? true : false,
            text: catagoryName,
            icon: Icons.local_offer,
            onTapFunction: () => showSelectorDialog("category"),
            color: catagoryColor,
          ),
          buildTransactionInfoItem(
            showJustBorder: accountName == "Account" ? true : false,
            text: accountName,
            icon: Icons.wallet,
            onTapFunction: () => showSelectorDialog("account"),
            color: accountColor,
          ),
          //   buildTransactionInfoItem(
          //     showJustBorder: true,
          //     text: "Time",
          //     icon: Icons.access_time_sharp,
          //     onTapFunction: () async {
          //       await showDateTimePicker();
          //     },
          //     color: const Color.fromARGB(255, 252, 250, 238),
          //   ),
          buildDateTimePicker(),
        ],
      ),
    );
  }

  Widget buildDateTimePicker() {
    return InkWell(
      onTap: showDateTimePicker,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 50,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Icon(Icons.access_time),
                ),
                const Text(
                  "Time",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('d MMM hh:mm a').format(date ?? DateTime.now()),
                  style: const TextStyle(
                    fontSize: 20,
                    //   fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTransactionInfoItem({
    required bool showJustBorder,
    required String text,
    required IconData icon,
    required Function onTapFunction,
    required Color color,
  }) {
    return TransactionInfoItem(
      showJustBorder: showJustBorder,
      text: text,
      icon: icon,
      onTapFunction: onTapFunction as void Function(),
      color: color,
    );
  }

  Widget buildAddButton() {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      margin: const EdgeInsets.only(top: 80),
      child: AddButton(
        amount: double.tryParse(widget.amountController.text) ?? 0,
        title: widget.titleController.text.toString(),
        note: widget.noteController.text.toString(),
        setStateFunc: widget.setStateFunc,
        comingFrom: widget.comingFrom,
        transactionBoxKey: widget.transactionBoxKey,
        transactionIndex: widget.transactionIndex,
      ),
    );
  }

  void toggleDebitCredit() {
    if (debitCredit == "Debit") {
      debitCredit = "Credit";
      debitCreditColor = MyApp.creditColor;
    } else {
      debitCredit = "Debit";
      debitCreditColor = MyApp.debitColor;
    }
    setState(() {});
  }

  Future<void> showSelectorDialog(String buttonType) {
    List<String> names = [];
    List<Color> colors = [];

    if (buttonType == "category") {
      for (Account catagory in catagories.values) {
        names.add(catagory.accountName);
        colors.add(catagory.color);
      }
    } else {
      for (Account account in accountsBox.values) {
        names.add(account.accountName);
        colors.add(account.color);
      }
    }

    colors.add(buttonType == "category" ? catagoryColor : accountColor);

    return showDialog(
      context: context,
      builder: (context) => SelectorDialog(
        callSetState: () {
          setState(() {});
        },
        buttonType: buttonType,
        names: names,
        colors: colors,
      ),
    );
  }

  Future<void> showDateTimePicker() async {
    date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      time = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }
  }
}

class AmountInput extends StatelessWidget {
  const AmountInput(
      {super.key, required this.fontSize, required this.controller});
  final double fontSize;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: false),
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
      ),
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        hintText: "0",
        contentPadding: EdgeInsets.zero,
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        border: InputBorder.none,
      ),
    );
  }
}

class TransactionInfoItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTapFunction;
  final Color color;
  late EdgeInsets padding;
  final bool showJustBorder;

  TransactionInfoItem({
    super.key,
    required this.text,
    required this.icon,
    required this.onTapFunction,
    required this.color,
    this.padding = const EdgeInsets.only(left: 5, right: 5, bottom: 15),
    required this.showJustBorder,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: () {
          onTapFunction();
        },
        borderRadius: BorderRadius.circular(40),
        child: Ink(
          decoration: BoxDecoration(
            color: !showJustBorder ? color.withOpacity(.9) : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: showJustBorder
                ? Border.all(
                    color: color,
                    width: 2,
                  )
                : null,
          ),
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 140,
              minHeight: 50,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Icon(
                  icon,
                  size: 25,
                  color: isLightColor(color) ? Colors.black : Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: showJustBorder ? color : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectorDialog extends StatelessWidget {
  final List<String> names;
  final List<Color> colors;
  final String buttonType;
  final Function callSetState;
  const SelectorDialog({
    super.key,
    required this.names,
    required this.colors,
    required this.buttonType,
    required this.callSetState,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        constraints: const BoxConstraints(
          minHeight: 200,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 20),
                  child: Text(
                    buttonType == "category" ? "Categories: " : "Accounts: ",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
              Wrap(
                children: List.generate(
                  names.length,
                  (index) => InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      if (buttonType == "category") {
                        catagoryName = names[index];
                        catagoryColor = colors[index];
                      } else {
                        accountName = names[index];
                        accountColor = colors[index];
                      }
                      callSetState();
                      Navigator.pop(context);
                    },
                    child: Ink(
                      child: IntrinsicWidth(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          //   height: 40,
                          decoration: BoxDecoration(
                              // color: colors[index],
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: colors[index],
                                width: 3,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            child: Center(
                              child: Text(
                                names[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: colors[index],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final double amount;
  final String title;
  final String note;
  final Function setStateFunc;
  final String comingFrom;
  final String transactionBoxKey;
  final int transactionIndex;
  const AddButton(
      {super.key,
      required this.amount,
      required this.title,
      this.note = "",
      required this.setStateFunc,
      required this.comingFrom,
      required this.transactionBoxKey,
      required this.transactionIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      var transaction = ref.watch(transactionInfo);
      return TextButton(
        onPressed: () {
          if (!balanceBox.containsKey('balance')) {
            balanceBox.put('balance', 0);
          }
          var balance = accountName != "Account"
              ? accountsBox.get(accountName)!.amount
              : 0;
          if (accountName == "Account") {
            showErrorDialog(context, "No Account Selected",
                "Please Select an Account to continue");
          } else if (debitCredit == "Debit" &&
              amount > balance &&
              comingFrom != "plannedPaymentsScreen") {
            showErrorDialog(context, "Insufficient Balance",
                "You do not have enough balance in the account for this debit.");
          } else if (amount > 0) {
            if (comingFrom == "Edit") {
              transaction.deleteTransaction(
                  transactionDetails, transactionBoxKey, transactionIndex);
            }

            transaction.addTransaction(
              transactionDetails,
              Transactions(
                amount: amount,
                isDebit: debitCredit == "Debit" ? true : false,
                catagory: catagoryName != "Category" ? catagoryName : "Others",
                account: accountName,
                time: DateTime(date!.year, date!.month, date!.day, time!.hour,
                    time!.minute),
                title: title,
                note: note,
              ),
            );
            Navigator.pop(context);
            setStateFunc();
          }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          backgroundColor: MyApp.addTransactionColor,
          elevation: 0,
        ),
        child: Text(
          'Add Transaction',
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.black),
        ),
      );
    }));
  }
}

void showErrorDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
