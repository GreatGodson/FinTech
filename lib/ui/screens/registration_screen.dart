import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/button_widget.dart';
import 'package:simba_ultimate/components/password_textfield.dart';
import 'package:simba_ultimate/components/textfield_widget.dart';
import 'package:simba_ultimate/services/authentication/authentication.dart';
import 'package:simba_ultimate/services/currency_balance/currency_balance.dart';
import 'package:simba_ultimate/styles/exceptions.dart';
import 'package:simba_ultimate/styles/text_style.dart';
import 'package:simba_ultimate/ui/screens/login_screen.dart';
import 'package:simba_ultimate/ui/screens/verify_mail_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //object of the authentication class
  final Authentication _authentication = Authentication();
  bool _isLoading = false;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  int _nairaBalance = 0;
  int _poundBalance = 0;
  int _dollarBalance = 0;
  bool _isPasswordHidden = true;

  // show and hide password
  void _togglePassword() {
    _isPasswordHidden = !_isPasswordHidden;
    setState(() {});
  }

  dynamic _getCurrencyRates() async {
    // stream balances
    CurrencyBalance currency = CurrencyBalance();
    // store balances in a list
    List balanceData = await currency.getCurrenciesData();
    setState(() {
      double ngnBalance = balanceData[0]["NGN"];
      double gbpBalance = balanceData[0]["GBP"];
      int usdBalance = balanceData[0]["USD"];

      _nairaBalance = ngnBalance.toInt();
      _poundBalance = gbpBalance.toInt();
      _dollarBalance = usdBalance.toInt();
    });
  }

  void _createUser() async {
    setState(() {
      _isLoading = true;
    });
    bool internet = await _authentication.checkInternetConnectivity();
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _email.isNotEmpty &&
        _password.isNotEmpty) {
      // check internet connectivity
      if (internet) {
        // get currency rates
        await _getCurrencyRates();
        final register = await _authentication.registerUser(
            _email,
            _password,
            _firstName,
            _lastName,
            _dollarBalance,
            _poundBalance,
            _nairaBalance);

        if (register != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VerifyMailScreen()));
        } else if (register == null) {
          final exception = _authentication.exception;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(exception!)));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: internetException));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: blankFieldException));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: createAccount,
      ),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldWidget(
                      onChanged: (val) {
                        _firstName = val.trim();
                      },
                      width: size.width / 2.4,
                      hintText: 'First Name',
                    ),
                    TextFieldWidget(
                      width: size.width / 2.4,
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
                  isPasswordHidden: _isPasswordHidden,
                  onChanged: (val) {
                    _password = val.trim();
                  },
                  onTap: _togglePassword,
                  width: double.infinity,
                  hintText: 'password',
                ),
                SizedBox(
                  height: size.height / 20,
                ),
                TextButtonWidget(
                  child:
                      _isLoading ? const CupertinoActivityIndicator() : signUp,
                  onPressed: () {
                    _createUser();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      oldUser,
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: logInNav)
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
