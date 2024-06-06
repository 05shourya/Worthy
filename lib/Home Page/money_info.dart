// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worthy/common_functions.dart';
import 'package:worthy/main.dart';
import 'package:worthy/riverpod_models.dart';

class MoneyInfo extends StatefulWidget {
  final double credit, debit;
  final double availableBalance;
  final bool isAccount;
  const MoneyInfo({
    super.key,
    required this.credit,
    required this.debit,
    required this.availableBalance,
    required this.isAccount,
  });

  @override
  State<StatefulWidget> createState() {
    return _MoneyInfo();
  }
}

class _MoneyInfo extends State<MoneyInfo> {
  @override
  Widget build(BuildContext context) {
    // Define the values and their corresponding titles and colors
    final List<Map<String, dynamic>> sectionsData = [
      {
        'value': widget.debit,
        'title': 'Debit',
        'color': MyApp.debitColor,
      },
      {
        'value': widget.credit,
        'title': 'Credit',
        'color': MyApp.creditColor,
      },
      if (widget.isAccount)
        {
          'value': widget.availableBalance,
          'title': 'Available',
          'color': Color.fromARGB(255, 59, 167, 255),
        },
    ];

// Sort the sections data by value
    sectionsData.sort((a, b) => a['value'].compareTo(b['value']));

// Assign radii based on sorted order (smallest, middle, largest)
    final List<double> radii = [50, 55, 60]; // Adjust these values as needed
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(transactionInfo);
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 235,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    creditDebit(
                      color: MyApp.debitColor,
                      textColor: Colors.black,
                      amount: widget.debit,
                      icon: Icons.arrow_drop_down,
                    ),
                    creditDebit(
                      color: MyApp.creditColor,
                      amount: widget.credit,
                      textColor: Colors.black,
                      icon: Icons.arrow_drop_up,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (widget.isAccount)
                      Text(
                        "${formatNumber(widget.availableBalance)} INR",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: PieChart(
                        swapAnimationDuration:
                            const Duration(milliseconds: 1000),
                        swapAnimationCurve: Curves.easeInOut,
                        PieChartData(
                          sections: sectionsData.map((data) {
                            // Assign the appropriate radius from the sorted list
                            final int index = sectionsData.indexOf(data);
                            return PieChartSectionData(
                                value: data['value'],
                                title: data['title'],
                                color: data['color'],
                                radius: radii[index],
                                titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ));
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class creditDebit extends StatelessWidget {
  final Color color;
  final Color textColor;
  final double amount;
  final IconData icon;
  final double width;
  final double height;

  const creditDebit({
    super.key,
    required this.color,
    required this.amount,
    required this.textColor,
    required this.icon,
    this.width = 180,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 45,
              color: textColor,
            ),
            Text(
              "${formatNumber(amount)} INR",
              style: TextStyle(
                color: textColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
