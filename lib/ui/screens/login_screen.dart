import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/button_widget.dart';
import 'package:simba_ultimate/components/password_textfield.dart';
import 'package:simba_ultimate/components/textfield_widget.dart';
import 'package:simba_ultimate/services/authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:simba_ultimate/ui/screens/navigation_bar_screen.dart';
import 'package:simba_ultimate/ui/screens/verify_mail_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Authentication _authentication = Authentication();
  bool _isLoading = false;
  bool? _isVerified;
  bool _isPasswordHidden = true;

  void _togglePassword() {
    _isPasswordHidden = !_isPasswordHidden;
    setState(() {});
  }

  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    bool internet = await _authentication.checkInternetConnectivity();
    if (_email.isNotEmpty && _password.isNotEmpty) {
      if (internet) {
        final loggingInUser =
            await _authentication.logInUser(_email, _password);
        if (loggingInUser != null) {
          _isVerified = await _authentication.checkIfMailVerified();
          if (_isVerified!) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()));
          } else {
            _authentication.sendVerificationMail();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VerifyMailScreen()));
          }
        } else {
          final exception = _authentication.exception;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('username or password is incorrect')));
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

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double mediaSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldWidget(
                  onChanged: (val) {
                    _email = val;
                  },
                  width: double.infinity,
                  hintText: 'E-mail',
                ),
                const SizedBox(
                  height: 20.0,
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
                const SizedBox(
                  height: 40.0,
                ),
                TextButtonWidget(
                  child: _isLoading
                      ? const CupertinoActivityIndicator()
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: () {
                    _loginUser();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Create an account'))
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
