import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simba_ultimate/constants.dart';

import 'package:flutter/cupertino.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key}) : super(key: key);

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  int? amount;
  final fireStore = FirebaseFirestore.instance;
  static CollectionReference wRef = FirebaseFirestore.instance
      .collection("transactions")
      .doc(uid)
      .collection("balance");
  final bool isLoading = false;
  String currency = 'USD';
  String receiverName = 'David';

  final items = ['USD', 'EUR', 'NGN'];
  final receiver = ['Godson', 'David'];

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              letterSpacing: 2.0,
            ),
          ),
        ),
      );

  androidDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          iconSize: 36,
          isDense: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          elevation: 0,
          isExpanded: true,
          value: currency,
          items: items.map(buildMenuItem).toList(),
          onChanged: (val) => setState(() {
                currency = val as String;
              })),
    );
  }

  receiverDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          iconSize: 36,
          isDense: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          elevation: 0,
          isExpanded: true,
          value: receiverName,
          items: receiver.map(buildMenuItem).toList(),
          onChanged: (val) => setState(() {
                receiverName = val as String;
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text(
          'Transfer',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: const [
                  Text(
                    'Select Currency',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 17.0),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 80.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.black),
                  child: androidDropdown(),
                ),
                TextFieldWidget(
                    onChanged: (val) {
                      try {
                        amount = int.parse(val);
                      } on FormatException {
                        amount = 0;
                      }
                    },
                    width: 290.0,
                    hintText: '0.00'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
              child: Row(
                children: const [
                  Text(
                    'Receiver',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 17.0),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  width: 370.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.black),
                  child: receiverDropDown(),
                ),
              ],
            ),
            const SizedBox(
              height: 45.0,
            ),
            TextButtonWidget(
                child: isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text(
                        'Send',
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: () async {
                  var result = await fireStore
                      .collection('transactions')
                      .add({'balance': amount});

                  await fireStore.runTransaction((transaction) async {
                    CollectionReference accountsRef =
                        fireStore.collection('transactions');
                    DocumentReference acc1Ref = accountsRef.doc('account1');
                    DocumentReference acc2Ref = accountsRef.doc('account2');
                    DocumentSnapshot acc1snap = await transaction.get(acc1Ref);
                    DocumentSnapshot acc2snap = await transaction.get(acc2Ref);

                    // await transaction.update(
                    //     acc2Ref, {'amount': acc2snap.data['balance'] + 200});
                  });

                  // var ggg =
                  //     getAuth().getUser(uid).then((userRecord) => print('ggg'));
                })
          ],
        ),
      ),
    );
  }
}

// body: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// TextFieldWidget(
// width: 200.0,
// hintText: 'amount',
// onChanged: (val) {
// // amount = val;
// try {
// amount = int.parse(val);
// // print(amount);
// } on FormatException {
// amount = 0;
// }
// }),
// TextButtonWidget(
// onPressed: () async {
// // wRef.add(amount!.toJson());
// var result = await fireStore
//     .collection('transactions')
// .add({'balance': amount});
// },
// child: const Text(
// 'done',
// style: TextStyle(color: Colors.white),
// ))
// ],
// ),
