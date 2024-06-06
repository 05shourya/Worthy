import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:worthy/Accounts%20Page/view_account.dart';
import 'package:worthy/Hive/Boxes.dart';
import 'package:worthy/Hive/accounts.dart';
import 'package:worthy/riverpod_models.dart';

class AccountsPage extends StatefulWidget {
  final bool isAccountPage;
  const AccountsPage({super.key, required this.isAccountPage});
  @override
  State<StatefulWidget> createState() => _AccountsPage();
}

class _AccountsPage extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        ref.watch(accountsInfo);
        ref.watch(transactionInfo);
        return ListView.builder(
          itemBuilder: (context, index) {
            if (widget.isAccountPage) {
              Account? account = accountsBox.getAt(index);
              if (account == null) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: AccountCatagoryItem(
                  account: account,
                  isAccount: true,
                ),
              );
            } else {
              Account? catagory = catagories.getAt(index);
              if (catagory == null) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: AccountCatagoryItem(
                  account: catagory,
                  isAccount: false,
                ),
              );
            }
          },
          itemCount:
              widget.isAccountPage ? accountsBox.length : catagories.length,
        );
      },
    );
  }
}

class AccountCatagoryItem extends StatelessWidget {
  final Account account;
  final bool isAccount;

  const AccountCatagoryItem(
      {super.key, required this.account, required this.isAccount});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isAccount) {
          Navigator.push(
            context,
            PageTransition(
              child: ViewAccount(
                account: account,
                isAccount: true,
              ),
              type: PageTransitionType.fade,
            ),
          );
        } else {
          Navigator.push(
            context,
            PageTransition(
              child: ViewAccount(
                account: account,
                isAccount: false,
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: ListTile(
        leading: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: account.color,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        title: Text(
          account.accountName,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        subtitle: isAccount
            ? Text(
                "${account.amount} INR",
                style: Theme.of(context).textTheme.labelSmall,
              )
            : null,
      ),
    );
  }
}
