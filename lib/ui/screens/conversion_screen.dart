import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/button_widget.dart';
import 'package:simba_ultimate/components/reusable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:simba_ultimate/components/textfield_widget.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({Key? key}) : super(key: key);

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final bool isLoading = false;
  String currency = 'USD';
  String newCurrencyVal = 'USD';

  final initialCurrency = ['USD', 'EUR', 'NGN'];
  final newCurrency = ['USD', 'EUR', 'NGN'];

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
          items: initialCurrency.map(buildMenuItem).toList(),
          onChanged: (val) => setState(() {
                currency = val as String;
              })),
    );
  }

  newCurrencyDropdown() {
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
          value: newCurrencyVal,
          items: newCurrency.map(buildMenuItem).toList(),
          onChanged: (val) => setState(() {
                newCurrencyVal = val as String;
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
                  child: androidDropdown(),
                ),
                TextFieldWidget(
                    onChanged: (val) {
                      String som = val;
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
                  child: newCurrencyDropdown(),
                ),
                Container(
                  width: 290.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.blueGrey)),
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
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
