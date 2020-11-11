import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import 'models/transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes dépenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
              button:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: "t1",
        title: "New shoes",
        amount: 69.99,
        date: DateTime.now().subtract(Duration(days: 1))),
    Transaction(
        id: "t2", title: "Les courses", amount: 29.99, date: DateTime.now()),
    Transaction(
        id: "t3", title: "Les courses", amount: 29.99, date: DateTime.now()),
    Transaction(
        id: "t4", title: "Les courses", amount: 29.99, date: DateTime.now()),
    Transaction(
        id: "t5", title: "Les courses", amount: 29.99, date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime date) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: date,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mq, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show chart', style: Theme.of(context).textTheme.title),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: (mq.size.height -
                      appBar.preferredSize.height -
                      mq.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mq, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height:
            (mq.size.height - appBar.preferredSize.height - mq.padding.top) *
                0.25,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  Widget _buildIosAppBar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text("Mes dépenses"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: Icon(CupertinoIcons.add),
          )
        ],
      ),
    );
  }

  Widget _buildAndroidAppbar(BuildContext context) {
    return AppBar(
      title: Text('Mes dépenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isLandscape = mq.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? _buildIosAppBar(context)
        : _buildAndroidAppbar(context);

    final txListWidget = Container(
      height: (mq.size.height - appBar.preferredSize.height - mq.padding.top) *
          0.75,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(mq, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mq, appBar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? null
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: Icon(Icons.add),
                  ),
          );
  }
}
