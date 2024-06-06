import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worthy/Add%20Data%20Screens/add_transaction.dart';
import 'package:worthy/Hive/Boxes.dart';
import 'package:worthy/Hive/accounts.dart';
import 'package:worthy/riverpod_models.dart';

List<Color> colors = [
  const Color.fromRGBO(238, 247, 248, 1.0),
  const Color.fromRGBO(242, 243, 151, 1.0),
  const Color.fromRGBO(234, 232, 241, 1.0),
  const Color.fromRGBO(229, 164, 139, 1.0),
  const Color.fromRGBO(227, 189, 105, 1.0),
  const Color.fromRGBO(207, 111, 159, 1.0),
  const Color.fromRGBO(189, 127, 179, 1.0),
  const Color.fromRGBO(161, 134, 153, 1.0),
  const Color.fromRGBO(153, 141, 159, 1.0),
  const Color.fromRGBO(153, 97, 63, 1.0),
  const Color.fromRGBO(143, 71, 144, 1.0),
  const Color.fromRGBO(128, 150, 204, 1.0),
  const Color.fromRGBO(120, 74, 135, 1.0),
  const Color.fromRGBO(71, 158, 244, 1.0),
  const Color.fromRGBO(53, 150, 182, 1.0),
  const Color.fromRGBO(43, 91, 142, 1.0),
  const Color.fromRGBO(33, 144, 180, 1.0),
  const Color.fromRGBO(19, 142, 105, 1.0),
  const Color.fromRGBO(36, 10, 52, 1.0),
];

Color borderColor = colors[0];
bool isWrongName = false;

class AddAccount extends StatefulWidget {
  final bool isAccount;
  const AddAccount({super.key, required this.isAccount});

  @override
  State<StatefulWidget> createState() => _AddAccount();
}

class _AddAccount extends State<AddAccount> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.isAccount);
    accountNameController.addListener(onAccountNameChange);
  }

  void onAccountNameChange() {
    if (accountsBox.containsKey(accountNameController.text.toString()) ||
        catagories.containsKey(accountNameController.text.toString())) {
      isWrongName = true;
    } else {
      isWrongName = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isAccount
          ? MediaQuery.of(context).size.height * .8
          : MediaQuery.of(context).size.height * .6,
      padding: const EdgeInsets.only(
        top: 20,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.isAccount ? "New Account" : "New Catagory",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: TextField(
              controller: accountNameController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              autofocus: true,
              //   textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: widget.isAccount ? "Account name" : "Catagory Name",
                errorText: isWrongName
                    ? "Acount or Catagory with this name already present"
                    : (accountNameController.text == "Account"
                        ? "This name is reserved"
                        : null),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
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
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width,
            // width: 100,
            height: 70,
            // color: Colors.blue,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      borderColor = colors[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: borderColor == colors[index]
                            ? borderColor
                            : Colors.transparent,
                        width: 5,
                      ),
                    ),
                    width: 70,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                );
              },
              itemCount: colors.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const Spacer(),
          //   SizedBox(
          //     height: 200,
          //   ),
          if (widget.isAccount)
            const Text(
              "Enter Initial Amount",
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (widget.isAccount)
            const SizedBox(
              height: 20,
            ),
          if (widget.isAccount)
            AmountInput(fontSize: 60, controller: amountController),
          if (widget.isAccount) const Spacer(),
          //   SizedBox(
          //     height: 100,
          //   ),
          const Spacer(),
          const Spacer(),
          Consumer(
            builder: (context, ref, child) {
              var account = ref.watch(accountsInfo);
              return AddAccountButton(
                addWhat: widget.isAccount ? "Add Account" : "Add Catagory",
                addAccountFunc: () {
                  //   account.deleteAllAccounts();
                  if (accountNameController.text != "" &&
                      !accountsBox
                          .containsKey(accountNameController.text.toString()) &&
                      accountNameController != "Account") {
                    if (widget.isAccount) {
                      account.addAccount(
                        Account(
                          accountName: accountNameController.text.toString(),
                          amount: double.tryParse(amountController.text) ?? 0,
                          totalCredit: 0,
                          totalDebit: 0,
                          rgb: [
                            borderColor.red,
                            borderColor.green,
                            borderColor.blue
                          ],
                        ),
                      );
                    } else {
                      account.addCatagory(
                        Account(
                          accountName: accountNameController.text.toString(),
                          amount: 0,
                          totalCredit: 0,
                          totalDebit: 0,
                          rgb: [
                            borderColor.red,
                            borderColor.green,
                            borderColor.blue
                          ],
                        ),
                      );
                    }
                    Navigator.pop(context);
                  }
                  print(balanceBox.get("balance"));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class AddAccountButton extends StatelessWidget {
  final Function addAccountFunc;
  final String addWhat;
  const AddAccountButton(
      {super.key, required this.addAccountFunc, required this.addWhat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addAccountFunc();
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        height: 50,
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 1, 255, 120),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            addWhat,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
