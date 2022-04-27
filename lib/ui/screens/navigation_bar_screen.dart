import 'package:flutter/material.dart';
import 'package:simba_ultimate/ui/screens/conversion_screen.dart';
import 'package:simba_ultimate/ui/screens/home_screen.dart';

import 'send_money_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  final screens = [
    const HomeScreen(),
    // const TransactionScreen(),
    const SendMoney(),
    const ConversionScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        elevation: 0.0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        iconSize: 30.0,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Send',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.rotate_right_outlined), label: 'Convert'),
        ],
      ),
    );
  }
}
