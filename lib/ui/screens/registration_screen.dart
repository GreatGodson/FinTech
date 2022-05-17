import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/button_widget.dart';
import 'package:simba_ultimate/components/password_textfield.dart';
import 'package:simba_ultimate/components/textfield_widget.dart';
import 'package:simba_ultimate/services/authentication/authentication.dart';
import 'package:simba_ultimate/services/currency_balance/currency_balance.dart';
import 'package:simba_ultimate/ui/screens/login_screen.dart';
import 'package:simba_ultimate/ui/screens/verify_mail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  bool _isLoading = false;
  Authentication authentication = Authentication();

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  int nairaBalance = 0;
  int poundBalance = 0;
  int dollarBalance = 0;
  bool isPasswordHidden = true;

  togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    setState(() {});
  }

  _getCurrencyRates() async {
    // _isLoading = true;
    CurrencyBalance currency = CurrencyBalance();
    List gottenData = await currency.getCurrenciesData();
    setState(() {
      double ngnBalance = gottenData[0]["NGN"];
      double gbpBalance = gottenData[0]["GBP"];
      int usdBalance = gottenData[0]["USD"];

      nairaBalance = ngnBalance.toInt();
      poundBalance = gbpBalance.toInt();
      dollarBalance = usdBalance.toInt();
    });

    // _isLoading = false;
  }

  Future createUser() async {
    setState(() {
      _isLoading = true;
    });
    bool internet = await authentication.checkInternetConnectivity();
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _email.isNotEmpty &&
        _password.isNotEmpty) {
      if (internet) {
        await _getCurrencyRates();
        final register = await authentication.registerUser(_email, _password,
            _firstName, _lastName, dollarBalance, poundBalance, nairaBalance);

        if (register != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VerifyMailScreen()));
        } else if (register == null) {
          final exception = authentication.exception;

          print('exception is $exception');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(exception!)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Check internet connection')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Create an account'),
      ),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldWidget(
                      onChanged: (val) {
                        _firstName = val.trim();
                      },
                      width: width / 2.4,
                      hintText: 'First Name',
                    ),
                    TextFieldWidget(
                      width: width / 2.4,
                      hintText: 'Last Name',
                      onChanged: (val) {
                        _lastName = val.trim();
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextFieldWidget(
                  onChanged: (val) {
                    _email = val.trim();
                  },
                  width: double.infinity,
                  hintText: 'E-mail',
                ),
                const SizedBox(
                  height: 30.0,
                ),
                PasswordTextFieldWidget(
                  isPasswordHidden: isPasswordHidden,
                  onChanged: (val) {
                    _password = val.trim();
                  },
                  onTap: togglePassword,
                  width: double.infinity,
                  hintText: 'password',
                ),
                SizedBox(
                  height: height / 20,
                ),
                TextButtonWidget(
                  child: _isLoading
                      ? const CupertinoActivityIndicator()
                      : const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: () {
                    createUser();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text('Log in'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
