import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:worthy/Accounts%20Page/Accounts_Page.dart';
import 'package:worthy/Add%20Data%20Screens/add_account.dart';
import 'package:worthy/Add%20Data%20Screens/add_transaction.dart';
import 'package:worthy/Hive/Boxes.dart';
import 'package:worthy/Hive/Transaction_Details.dart';
import 'package:worthy/Hive/accounts.dart';
import 'package:worthy/Hive/planned_payment_info.dart';
import 'package:worthy/Home%20Page/myAppBar.dart';
import 'Home Page/UI.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionDetailsAdapter());
  Hive.registerAdapter(TransactionsAdapter());
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(PlannedPaymentInfoAdapter());
  transactionDetails =
      await Hive.openBox<TransactionDetails>('TransactionDetails');
  accountsBox = await Hive.openBox('accountsBox');
  balanceBox = await Hive.openBox('availableBalance');
  catagories = await Hive.openBox('catagories');
  plannedPaymentInfoBox = await Hive.openBox('plannedPaymentInfoBox');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static Color debitColor = const Color.fromARGB(255, 170, 195, 245);
  static Color creditColor = const Color(0xFF3be7bd);
  static Color addTransactionColor = const Color.fromARGB(255, 255, 241, 38);
  static Color accountColor = const Color.fromRGBO(36, 10, 52, 1.0);
  static Color unselectedColor = Colors.grey,
      selectedColor = const Color.fromARGB(255, 78, 66, 255);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worthy',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff111111),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff111111),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 253, 253),
          primary: Colors.white,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          titleSmall: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
          labelMedium: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            //   color: Colors.white,
          ),
          labelSmall: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
          labelLarge: TextStyle(
            fontSize: 28,
            color: Colors.grey,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 35,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          centerTitle: true,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _App();
}

class _App extends State<App> {
  int _currIndex = 0;
  List<Widget> navigationPages = [
    const UI(),
    const AccountsPage(
      isAccountPage: true,
    ),
    const AccountsPage(
      isAccountPage: false,
    ),
  ];

  List<IconData> unselectedIcons = [
    Icons.home_outlined,
    Icons.wallet_outlined,
    Icons.widgets_outlined,
  ];
  List<IconData> selectedIcons = [
    Icons.home,
    Icons.wallet,
    Icons.widgets,
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // ! AppBar
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: myAppBar(),
        ),
        //! App Body
        body: navigationPages[_currIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return FloatingActionButton(
              onPressed: () {
                if (_currIndex == 0) {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: AddTransaction(
                        accountName: "Account",
                        catagoryName: "Category",
                        date: DateTime.now(),
                        time: TimeOfDay.now(),
                      ),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOutCubic,
                      reverseDuration: const Duration(milliseconds: 200),
                    ),
                  );
                } else if (_currIndex == 1) {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return const AddAccount(
                        isAccount: true,
                      );
                    },
                  );
                } else {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return const AddAccount(
                        isAccount: false,
                      );
                    },
                  );
                }
              },
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                size: 40,
              ),
            );
          },
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _currIndex,
            backgroundColor: const Color(0xFF111111),
            items: [
              BottomNavigationBarItem(
                icon: Icon(_currIndex == 0 ? Icons.home : Icons.home_outlined),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    _currIndex == 1 ? Icons.wallet : Icons.wallet_outlined),
                label: "Accounts",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    _currIndex == 2 ? Icons.widgets : Icons.widgets_outlined),
                label: "Categories",
              )
            ],
            onTap: (index) {
              setState(() {
                _currIndex = index;
              });
            },
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
