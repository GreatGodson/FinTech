import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:simba_ultimate/components/textfield_widget.dart';
import 'package:simba_ultimate/services/authentication/authentication.dart';
import 'package:simba_ultimate/services/currency_conversion/currency_conversion.dart';
import 'package:simba_ultimate/ui/screens/navigation_bar_screen.dart';
import 'package:intl/intl.dart';
import 'package:simba_ultimate/constants.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({Key? key}) : super(key: key);

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  CurrencyConversion currencyConversion = CurrencyConversion();
  Authentication authentication = Authentication();

  final auth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection('users');

  bool isLoading = false;
  String debitCurrencyField = 'USD';
  String creditCurrencyField = 'GBP';
  int conversionAmount = 0;
  int convertedAmount = 0;
  int previewConversionValue = 0;
  int nairaBalance = 0;
  int poundBalance = 0;
  int dollarBalance = 0;
  String nairaBalanceValue = '₦ 0.00';
  bool isConversionSuccessful = false;

  final initialCurrencyList = ['USD', 'GBP', 'NGN'];
  final finalCurrencyList = ['GBP', 'USD', 'NGN'];
  final currencyFormat = NumberFormat("###,###", "en_US");

  previewConversion() async {
    if (conversionAmount <= 0 || debitCurrencyField == creditCurrencyField) {
      previewConversionValue = 0;
    } else {
      previewConversionValue = await currencyConversion.getConversionRates(
        debitCurrencyField,
        creditCurrencyField,
        conversionAmount,
      );
      setState(() {});
    }

    return previewConversionValue;
  }

  convert() {
    // setState(() {
    //   isLoading = true;
    // });
    convertedAmount = previewConversionValue;
    updateBalanceData();
    if (isConversionSuccessful) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()));
    }
    // setState(() {
    //   isLoading = false;
    // });
  }

  streamBalances() async {
    User? user = auth.currentUser;
    if (user != null) {
      final userUid = user.uid;
      await for (var snapshot in FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()) {
        dollarBalance = snapshot.data()?['usdBalance'];
        poundBalance = snapshot.data()?['gbpBalance'];
        nairaBalance = snapshot.data()?['ngnBalance'];

        print(dollarBalance);
        print(poundBalance);
        print(nairaBalance);
      }
    }
  }

  updateBalanceData() {
    setState(() {
      isLoading = true;
    });
    User? user = auth.currentUser;
    final userUid = user!.uid;
    if (debitCurrencyField == 'USD' && creditCurrencyField == 'GBP') {
      if (conversionAmount > dollarBalance) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'You do not have enough USD balance to make this conversion')));
      } else {
        setState(() {
          dollarBalance = dollarBalance - conversionAmount;
          poundBalance = poundBalance + convertedAmount;
          isConversionSuccessful = true;
        });
        collection.doc(userUid).update(
          {"usdBalance": dollarBalance, "gbpBalance": poundBalance},
        );
      }
    } else if (debitCurrencyField == 'USD' && creditCurrencyField == 'NGN') {
      if (conversionAmount > dollarBalance) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'You do not have enough USD balance to make this conversion')));
      } else {
        setState(() {
          dollarBalance = dollarBalance - conversionAmount;
          nairaBalance = nairaBalance + convertedAmount;
          isConversionSuccessful = true;
        });
        collection.doc(userUid).update(
          {"usdBalance": dollarBalance, "ngnBalance": nairaBalance},
        );
      }
    } else if (debitCurrencyField == 'GBP' && creditCurrencyField == 'USD') {
      if (conversionAmount > poundBalance) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'You do not have enough GBP balance to make this conversion')));
      } else {
        setState(() {
          poundBalance = poundBalance - conversionAmount;
          dollarBalance = dollarBalance + convertedAmount;
          isConversionSuccessful = true;
        });
        collection.doc(userUid).update(
          {"usdBalance": dollarBalance, "gbpBalance": poundBalance},
        );
      }
    } else if (debitCurrencyField == 'GBP' && creditCurrencyField == 'NGN') {
      if (conversionAmount > poundBalance) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'You do not have enough GBP balance to make this conversion')));
      } else {
        setState(() {
          poundBalance = poundBalance - conversionAmount;
          nairaBalance = nairaBalance + convertedAmount;
          isConversionSuccessful = true;
        });
        collection.doc(userUid).update(
          {"gbpBalance": poundBalance, "ngnBalance": nairaBalance},
        );
      }
    } else if (debitCurrencyField == 'NGN' && creditCurrencyField == 'USD') {
      if (conversionAmount > nairaBalance) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'You do not have enough NGN balance to make this conversion')));
      } else {
        setState(() {
          nairaBalance = nairaBalance - conversionAmount;
          dollarBalance = dollarBalance + convertedAmount;
          isConversionSuccessful = true;
        });
        collection.doc(userUid).update(
          {"usdBalance": dollarBalance, "ngnBalance": nairaBalance},
        );
      }
    } else if (debitCurrencyField == 'NGN' && creditCurrencyField == 'GBP') {
      if (conversionAmount > nairaBalance) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'You do not have enough NGN balance to make this conversion')));
      } else {
        setState(() {
          nairaBalance = nairaBalance - conversionAmount;
          poundBalance = poundBalance + convertedAmount;
          isConversionSuccessful = true;
        });
        collection.doc(userUid).update(
          {"ngnBalance": nairaBalance, "gbpBalance": poundBalance},
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

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

  initialCurrencyDropdown() {
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
          value: debitCurrencyField,
          items: initialCurrencyList.map(buildMenuItem).toList(),
          onChanged: (val) => setState(() {
                debitCurrencyField = val as String;
              })),
    );
  }

  finalCurrencyDropdown() {
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
          value: creditCurrencyField,
          items: finalCurrencyList.map(buildMenuItem).toList(),
          onChanged: (val) => setState(() {
                creditCurrencyField = val as String;
                previewConversion();
              })),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamBalances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text(
          'Convert',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: const [
                    Text(
                      'From',
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2.0,
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
                    child: initialCurrencyDropdown(),
                  ),
                  TextFieldWidget(
                      onChanged: (val) {
                        try {
                          conversionAmount = int.parse(val);
                        } on FormatException {
                          conversionAmount = 0;
                        }
                        previewConversion();
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
                      'To',
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2.0,
                          fontSize: 17.0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 80.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.black),
                    child: finalCurrencyDropdown(),
                  ),
                  Container(
                    width: 290.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.blueGrey)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        previewConversionValue.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                  //const TextFieldWidget(width: 290.0, hintText: '0.00'),
                ],
              ),
              const SizedBox(
                height: 45.0,
              ),
              TextButtonWidget(
                  child: isLoading
                      ? const CupertinoActivityIndicator()
                      : const Text(
                          'Convert',
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: () {
                    convert();
                  }),
            ],
          ),
        ),
      ]),
    );
  }
}
