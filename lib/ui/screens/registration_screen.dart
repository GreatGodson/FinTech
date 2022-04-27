import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/reusable_widget.dart';
import 'package:simba_ultimate/services/authentication.dart';
import 'package:simba_ultimate/ui/screens/login_screen.dart';
import 'package:simba_ultimate/ui/screens/verify_mail_screen.dart';
import 'navigation_bar_screen.dart';
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

  bool isPasswordHidden = true;

  togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    setState(() {});
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
        final register = await authentication.registerUser(
            _email, _password, _firstName, _lastName);
        if (register != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VerifyMailScreen()));
        } else {
          final exception = authentication.exception;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Create an account'),
      ),
      body: Padding(
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
                  width: 170,
                  hintText: 'First Name',
                ),
                TextFieldWidget(
                  width: 170,
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
              width: 350,
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
              width: 350,
              hintText: 'password',
            ),
            const SizedBox(
              height: 40.0,
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
    );
  }
}
