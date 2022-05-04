import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/button_widget.dart';
import 'package:simba_ultimate/components/reusable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:simba_ultimate/components/textfield_widget.dart';
import 'package:simba_ultimate/services/authentication/authentication.dart';
import 'package:simba_ultimate/services/currency_conversion/currency_conversion.dart';
import 'package:simba_ultimate/ui/screens/home_screen.dart';
import 'package:simba_ultimate/ui/screens/navigation_bar_screen.dart';
import 'package:intl/intl.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({Key? key}) : super(key: key);

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  CurrencyConversion currencyConversion = CurrencyConversion();
  Authentication authentication = Authentication();

  bool isLoading = false;
  String initialCurrencyValue = 'USD';
  String finalCurrencyValue = 'GBP';
  int conversionAmount = 0;
  int previewedAmount = 0;

  final initialCurrencyList = ['USD', 'GBP', 'NGN'];
  final finalCurrencyList = ['GBP', 'USD', 'NGN'];
  final currencyFormat = NumberFormat("###,###", "en_US");

  int nairaBalance = 0;
  int poundBalance = 0;
  int dollarBalance = 0;
  String nairaBalanceValue = '₦ 0.00';

  String firstName = '';

  getAllBalances() async {
    nairaBalance = await authentication.getUserNairaBalance();
    poundBalance = await authentication.getUserGBPBalance();
    dollarBalance = await authentication.getUserDollarBalance();
    nairaBalanceValue = currencyFormat.format(nairaBalance);

    setState(() {});
  }

  previewConversion() async {
    previewedAmount = await currencyConversion.getConversionRates(
        initialCurrencyValue,
        finalCurrencyValue,
        conversionAmount,
        poundBalance,
        dollarBalance,
        nairaBalance);
    print(previewedAmount);
    setState(() {});
    return previewedAmount;
  }

  convert() {
    setState(() {
      isLoading = true;
    });
    conversionAmount = previewedAmount;
    print(conversionAmount);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const BottomNavBar()));
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
          value: initialCurrencyValue,
          items: initialCurrencyList.map(buildMenuItem).toList(),
          onChanged: (val) => setState(() {
                initialCurrencyValue = val as String;
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
          value: finalCurrencyValue,
          items: finalCurrencyList.map(buildMenuItem).toList(),
          onChanged: (val) => setState(() {
                finalCurrencyValue = val as String;
                previewConversion();
              })),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBalances();
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
      body: Padding(
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
                      conversionAmount = int.parse(val);
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
                      previewedAmount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 17),
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
                })
          ],
        ),
      ),
    );
  }
}
