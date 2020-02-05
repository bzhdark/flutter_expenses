import 'package:flutter/material.dart';
import "package:intl/intl.dart";

class TransactionList extends StatelessWidget {
  final List userTransactions;
  final Function deleteTransaction;

  TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: userTransactions.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pas de transactions !'),
                // SizedBox(height: 50),
                Container(
                  height: 200,
                  margin: EdgeInsets.only(top: 25),
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    // contentPadding: EdgeInsets.all(7),
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text("\$${userTransactions[index].amount}"),
                        ),
                      ),
                    ),
                    title: Text(
                      userTransactions[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(userTransactions[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () =>
                          deleteTransaction(userTransactions[index].id),
                    ),
                  ),
                );
              },
              itemCount: userTransactions.length,
            ),
    );
  }
}
