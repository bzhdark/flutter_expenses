import 'package:flutter/material.dart';

import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List userTransactions;
  final Function deleteTransaction;

  TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: userTransactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pas de transactions !'),
                  // SizedBox(height: 50),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    margin: EdgeInsets.only(top: 25),
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return TransactionItem(
                    transaction: userTransactions[index],
                    deleteTransaction: deleteTransaction);
              },
              itemCount: userTransactions.length,
            ),
    );
  }
}
