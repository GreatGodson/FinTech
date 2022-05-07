import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/card_widget.dart';
import 'package:simba_ultimate/components/icons_widget.dart';
import 'package:simba_ultimate/services/authentication/authentication.dart';
import 'package:simba_ultimate/ui/screens/conversion_screen.dart';
import 'package:simba_ultimate/ui/screens/profile_screen.dart';
import 'package:simba_ultimate/ui/screens/send_money_screen.dart';
import 'package:simba_ultimate/ui/screens/transaction_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Authentication authentication = Authentication();
  bool isLoading = false;
  String firstName = '';
  String? loggedInUserUid;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    authentication.getCurrentUserEmail;
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Row(
              children: const [
                Text(
                  'Welcome',
                  style: TextStyle(color: Colors.grey, fontSize: 17.0),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text('');
                              }
                              final nameData = snapshot.data!.data();
                              final firstName = nameData?['firstName'];
                              return Text(
                                firstName,
                                style: const TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.blueGrey,
                                ),
                              );
                            }),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20.0,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10.0),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              width: 400,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ReusableCard(
                    imageName: 'usa3.jpeg',
                    currency: 'USD',
                    balance:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text('0.00');
                              }
                              final balanceData = snapshot.data!.data();
                              final usdBalanceData = balanceData?['usdBalance'];
                              return Text(
                                '﹩${usdBalanceData.toString()}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 35),
                              );
                            }),
                  ),
                  ReusableCard(
                    imageName: 'uk_flag.jpeg',
                    currency: 'GBP',
                    balance:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text('0.00');
                              }
                              final balanceData = snapshot.data!.data();
                              final gbpBalanceData = balanceData?['gbpBalance'];
                              return Text(
                                '£ ${gbpBalanceData.toString()}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 35),
                              );
                            }),
                  ),
                  ReusableCard(
                    imageName: 'nigeria.png',
                    currency: 'NGN',
                    balance:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text('0.00');
                              }
                              final balanceData = snapshot.data!.data();
                              final nairaBalanceData =
                                  balanceData?['ngnBalance'];
                              final currencyFormat =
                                  NumberFormat("###,###", "en_US");
                              final ngnBalanceData =
                                  currencyFormat.format(nairaBalanceData);

                              return Text(
                                '₦ $ngnBalanceData',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 35),
                              );
                            }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TransactionIcons(
                      color: Colors.pinkAccent,
                      title: 'Send',
                      icon: Icons.send,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SendMoney()),
                        );
                      }),
                  TransactionIcons(
                    color: Colors.orangeAccent,
                    title: 'Convert',
                    icon: Icons.download_outlined,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ConversionScreen()));
                    },
                  ),
                  TransactionIcons(
                    color: Colors.purpleAccent,
                    title: 'Transactions',
                    icon: Icons.transit_enterexit_outlined,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TransactionScreen()));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height / 3,
              child: ListView(
                children: const [
                  TransactionRow(
                    transactionType: 'Sent',
                  ),
                  TransactionRow(transactionType: 'Received'),
                  TransactionRow(transactionType: 'Sent'),
                  TransactionRow(transactionType: 'Sent'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionRow extends StatelessWidget {
  final String transactionType;
  const TransactionRow({Key? key, required this.transactionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      width: 400.0,
      height: 70.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xFF141414)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.black),
                    child: const Icon(
                      Icons.mark_chat_read,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    transactionType,
                    style: const TextStyle(color: Colors.green, fontSize: 18.0),
                  ),
                  //SizedBox(width: MediaQuery.of(context).size.width * 0.42),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      '\$1,000',
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                child: Row(
                  children: const [
                    Text(
                      '12th, Feb. 2022',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                          letterSpacing: 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
