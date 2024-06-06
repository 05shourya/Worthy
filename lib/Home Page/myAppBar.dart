// ignore_for_file: camel_case_types, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:worthy/riverpod_models.dart';

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

final int _currYear = DateTime.now().year;
final int _currMonth = DateTime.now().month;
List<int> years = List.generate(_currYear - 1949, (index) => _currYear - index);

class myAppBar extends StatefulWidget {
  const myAppBar({super.key});
  @override
  State<StatefulWidget> createState() {
    return _myAppBar();
  }
}

class _myAppBar extends State<myAppBar> {
  @override
  Widget build(BuildContext context) {
    int year = _currYear, month = _currMonth;
    List<Widget> monthWidgets = months.map((month) {
      return Text(
        month,
        style: Theme.of(context).textTheme.titleMedium,
      );
    }).toList();

    List<Widget> yearWidgets = years.map((year) {
      return Text(
        "$year",
        style: Theme.of(context).textTheme.titleMedium,
      );
    }).toList();
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Consumer(
                builder: (context, ref, child) {
                  final timePerid = ref.watch(timePeriodInfo);
                  return TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .9,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 150,
                                          child: CupertinoPicker(
                                            scrollController:
                                                FixedExtentScrollController(
                                              initialItem: month - 1,
                                            ),
                                            itemExtent: 50,
                                            onSelectedItemChanged: (value) {
                                              month = value + 1;
                                              timePerid.updateTime(
                                                  DateTime(year, month));
                                            },
                                            children: monthWidgets,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 150,
                                          child: CupertinoPicker(
                                            scrollController:
                                                FixedExtentScrollController(
                                              initialItem: _currYear - year,
                                            ),
                                            itemExtent: 50,
                                            onSelectedItemChanged: (value) {
                                              year = _currYear - value;
                                              timePerid.updateTime(
                                                  DateTime(year, month));
                                            },
                                            children: yearWidgets,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      DateFormat("MMM yyyy").format(timePerid.timePeriod),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
