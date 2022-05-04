import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:simba_ultimate/constants.dart';

class CurrencyBalance {
  List currencyData = [];
  // <Map<String,double>>
  List? getCurrency;
  Future getCurrenciesData() async {
    for (String currency in currencyList) {
      String dataUrl =
          'https://api.apilayer.com/exchangerates_data/convert?to=$currency&from=$startingCurrency&amount=$startingBalance&apikey=$apikey';
      var url = Uri.parse(dataUrl);
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        String jsonFormat = response.body;
        var result = jsonDecode(jsonFormat);
        currencyData.add(result['result']);
      } else {
        print(response.statusCode);
        throw 'Problem with Get balance request';
      }
    }
    getCurrency = [
      {"GBP": currencyData[0], "NGN": currencyData[1], "USD": currencyData[2]}
    ];
    return getCurrency;
  }
}
