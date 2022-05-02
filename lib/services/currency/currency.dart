import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apikey = "7sQsXGa2qMCpoWgRCRK7tqVmgOk378AA";

const startingBalance = 500;
const startingCurrency = 'USD';
const List<String> currencyList = [
  'GBP',
  'NGN',
  'USD',
];

List currencyData = [];
List? getCurrency;

class Currency {
  // amount in dollars

  getData() async {
    for (String currency in currencyList) {
      String dataUrl =
          'https://api.apilayer.com/exchangerates_data/convert?to=$currency&from=$startingCurrency&amount=$startingBalance&apikey=$apikey';
      var url = Uri.parse(dataUrl);
      http.Response response = await http.get(url);
      String jsonFormat = response.body;
      var result = jsonDecode(jsonFormat);
      currencyData.add(result['result']);

      print(result);
    }
    getCurrency = [
      {"GBP": currencyData[0], "NGN": currencyData[1], "USD": currencyData[2]}
    ];
    print(currencyData);
    print(getCurrency);
    print(getCurrency?[0]["GBP"]);
  }
}
