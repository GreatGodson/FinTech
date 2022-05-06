import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    } else {
      print('status code is: ${response.statusCode}');
      throw 'Problem with Get conversion request';
    }
    return convertedAmount;
  }
}
