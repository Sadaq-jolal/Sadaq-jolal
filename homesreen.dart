import 'package:digitalwalletapp/screens/AddTransactionScreen.dart';
import 'package:digitalwalletapp/screens/TransactionHistoryScreen.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Welcome to the Digital Wallet App!')),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Add Transaction'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddTransactionScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Transaction History'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TransactionHistoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}