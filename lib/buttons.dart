import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:worthy/Add%20Data%20Screens/add_transaction.dart';
import 'package:worthy/main.dart';

class AddTransactionButton extends StatelessWidget {
  final double? width;
  final double height;
  final double margin;
  final String accountName, catagoryName;
  final Function setStateFunc;

  const AddTransactionButton({
    super.key,
    this.width,
    this.height = 65,
    this.margin = 8,
    this.accountName = "Account",
    this.catagoryName = "Category",
    required this.setStateFunc,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: AddTransaction(
                accountName: accountName,
                catagoryName: catagoryName,
                date: DateTime.now(),
                time: TimeOfDay.now(),
                setStateFunc: setStateFunc,
              ),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutCubic,
              reverseDuration: const Duration(milliseconds: 200),
            ),
          );
        },
        child: Ink(
          width: width ?? MediaQuery.of(context).size.width * .8,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            color: MyApp.addTransactionColor,
          ),
          child: Center(
            child: Text(
              "Add Transaction",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
