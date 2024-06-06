// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class plannedPayments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _plannedPayments();
  }
}

class _plannedPayments extends State<plannedPayments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: 80,
      //   color: Colors.blue,
      child: const Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          plannedPaymentItem(
            color: Color.fromARGB(255, 230, 90, 80),
            amount: "Due INR 1000",
            width: 140,
          ),
          plannedPaymentItem(
            color: Color.fromARGB(255, 212, 255, 81),
            amount: "Upcoming INR 2000",
            width: 180,
          )
        ],
      ),
    );
  }
}

class plannedPaymentItem extends StatelessWidget {
  final Color color;
  final String amount;
  final double width;

  const plannedPaymentItem(
      {super.key,
      required this.color,
      required this.amount,
      required this.width});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(55),
        onTap: () {},
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(55),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: 45,
            child: Center(
              child: Text(
                amount,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
