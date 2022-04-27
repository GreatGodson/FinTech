import 'package:flutter/material.dart';
import 'package:simba_ultimate/ui/screens/home_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'All transactions',
          style: TextStyle(color: Colors.grey, letterSpacing: 1.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () {},
        child: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 26.0,
            child: Icon(Icons.near_me)),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: const [
                TransactionRow(transactionType: 'Sent'),
                TransactionRow(transactionType: 'Received'),
                TransactionRow(transactionType: 'Received'),
                TransactionRow(transactionType: 'Sent'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
