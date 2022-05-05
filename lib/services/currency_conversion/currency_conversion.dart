import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:simba_ultimate/services/authentication/authentication.dart';

class CurrencyConversion {
  int? gbpConversion;
  int? dollarConversion;
  int? nairaConversion;
  final auth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection('users');

  Authentication authentication = Authentication();

  Future getConversionRates(String initialCurrency, String finalCurrency,
      int amount, int gbpBalance, int usdBalance, int ngnBalance) async {
    int convertedAmount;
    String dataUrl =
        'https://api.apilayer.com/exchangerates_data/convert?to=$finalCurrency&from=$initialCurrency&amount=$amount&apikey=$apikey';
    var url = Uri.parse(dataUrl);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String jsonFormat = response.body;
      var result = jsonDecode(jsonFormat);
      var rate = result['result'];
      convertedAmount = rate.toInt();
      if (initialCurrency == 'GBP' && finalCurrency == 'USD') {
        if (amount > gbpBalance) {
          print(
              "You do do not have enough GBP balance to complete this transaction ");
        } else {
          dollarConversion = convertedAmount + usdBalance;
          usdBalance = dollarConversion!;
          gbpBalance = gbpBalance - convertedAmount;

          print('new usd balance is: $usdBalance');
          print('new gbp balance is: $gbpBalance');
        }
      } else if (initialCurrency == 'USD' && finalCurrency == 'GBP') {
        if (amount > usdBalance) {
          print(
              'you do not have enough USD balance to complete this transaction');
        } else {
          gbpConversion = convertedAmount + gbpBalance;
          gbpBalance = gbpConversion!;
          usdBalance = usdBalance - convertedAmount;

          print('new gbp balance is: $gbpBalance');
          print(' new usd balane is: $usdBalance');
        }
      } else if (initialCurrency == 'GBP' && finalCurrency == 'NGN') {
        if (amount > gbpBalance) {
          print(
              'you do not have enough GBP balance to complete this transaction');
        } else {
          nairaConversion = convertedAmount + ngnBalance;
          ngnBalance = nairaConversion!;
          gbpBalance = gbpBalance - convertedAmount;
          print("new naira balance is : $ngnBalance");
          print('new gbp balance is : $gbpBalance');
        }
      } else if (initialCurrency == 'NGN' && finalCurrency == 'GBP') {
        if (amount > ngnBalance) {
          print(
              'you do not have enough NGN balance to complete this transaction');
        } else {
          gbpConversion = convertedAmount + gbpBalance;
          gbpBalance = gbpConversion!;
          ngnBalance = ngnBalance - convertedAmount;
          print('new gbp balance is: $gbpBalance');
          print('new ngn balance : $ngnBalance ');
        }
      } else if (initialCurrency == 'USD' && finalCurrency == 'NGN') {
        if (amount > usdBalance) {
          print(
              'you do not have enough USD balance to complete this transaction');
        } else {
          nairaConversion = convertedAmount + ngnBalance;
          ngnBalance = nairaConversion!;
          usdBalance = usdBalance - convertedAmount;
          print('new naira balance is: $ngnBalance');
          print('new usd balance is : $usdBalance');
        }
      } else if (initialCurrency == 'NGN' && finalCurrency == 'USD') {
        if (amount > ngnBalance) {
          print(
              'you do not have enough NGN balance to complete this transaction');
        } else {
          dollarConversion = convertedAmount + usdBalance;
          usdBalance = dollarConversion!;
          ngnBalance = ngnBalance - convertedAmount;
          print('new usd balance: $usdBalance');
          print('new naira balance: $ngnBalance');
        }
      }
    } else {
      print(response.statusCode);
      throw 'Problem with Get conversion request';
    }
    return convertedAmount;
  }

  updateBalanceData(String updatedBalanceFieldName, updatedBalance,
      debitedBalanceFieldName, debitedBalance) {
    User? user = auth.currentUser;
    final userUid = user!.uid;
    collection.doc(userUid).update(
      {
        updatedBalanceFieldName: updatedBalance,
        debitedBalanceFieldName: debitedBalance
      },
    );
  }
}
