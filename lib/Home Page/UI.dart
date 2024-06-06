// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worthy/Home%20Page/dayWiseInfo.dart';
import 'package:worthy/Home%20Page/money_info.dart';
import 'package:worthy/riverpod_models.dart';

class UI extends StatefulWidget {
  const UI({super.key});
  @override
  State<StatefulWidget> createState() {
    return _UI();
  }
}

class _UI extends State<UI> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Consumer(
          builder: (context, ref, child) {
            var bal = ref.watch(balanceInfo);
            var availabe = ref.watch(transactionInfo);
            final timePeriod = ref.watch(timePeriodInfo);
            return MoneyInfo(
              isAccount: true,
              credit: bal.credit(
                "",
                timePeriod.timePeriod,
                timePeriod.timePeriod.add(const Duration(days: 31)),
              ),
              debit: bal.debit(
                "",
                timePeriod.timePeriod,
                timePeriod.timePeriod.add(const Duration(days: 31)),
              ),
              availableBalance: availabe.balance,
            );
          },
        ),
        const SizedBox(
          height: 30,
        ),
        const DayWiseInfo(),
      ],
    );
  }
}
