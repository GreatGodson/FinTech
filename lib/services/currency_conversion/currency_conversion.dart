import 'package:flutter/material.dart';
import 'package:simba_ultimate/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConversion {
  int? gbpConversion;
  int? dollarConversion;
  int? nairaConversion;

  int? gbpBalance;
  int? usdBalance;
  int? ngnBalance;
  Future getConversionRates(
      String initialCurrency, String finalCurrency, int amount) async {
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
        if (amount > gbpBalance!) {
          print(
              "You do do not have enough GBP balance to complete this transaction ");
        } else {
          dollarConversion = convertedAmount;
        }
      } else if (initialCurrency == 'USD' && finalCurrency == 'GBP') {
        if (amount > usdBalance!) {
          print(
              'you do not have enough USD balance to complete this transaction');
        } else {
          gbpConversion = convertedAmount;
        }
      } else if (initialCurrency == 'GBP' && finalCurrency == 'NGN') {
        if (amount > gbpBalance!) {
          print(
              'you do not have enough GBP balance to complete this transaction');
        } else {
          nairaConversion = convertedAmount;
        }
      } else if (initialCurrency == 'NGN' && finalCurrency == 'GBP') {
        if (amount > ngnBalance!) {
          print(
              'you do not have enough NGN balance to complete this transaction');
        } else {
          gbpConversion = convertedAmount;
        }
      } else if (initialCurrency == 'USD' && finalCurrency == 'NGN') {
        if (amount > usdBalance!) {
          print(
              'you do not have enough USD balance to complete this transaction');
        } else {
          nairaConversion = convertedAmount;
        }
      } else if (initialCurrency == 'NGN' && finalCurrency == 'USD') {
        if (amount > ngnBalance!) {
          print(
              'you do not have enough NGN balance to complete this transaction');
        } else {
          dollarConversion = convertedAmount;
        }
      }
    } else {
      print(response.statusCode);
      throw 'Problem with Get conversion request';
    }
    return convertedAmount;
  }
}
