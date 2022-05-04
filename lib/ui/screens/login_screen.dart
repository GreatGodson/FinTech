import 'package:flutter/material.dart';
import 'package:simba_ultimate/components/button_widget.dart';
import 'package:simba_ultimate/components/password_textfield.dart';
import 'package:simba_ultimate/components/reusable_widget.dart';
import 'package:simba_ultimate/components/textfield_widget.dart';
import 'package:simba_ultimate/services/authentication/authentication.dart';

import 'package:flutter/cupertino.dart';
import 'package:simba_ultimate/ui/screens/doc.dart';
import 'package:simba_ultimate/ui/screens/navigation_bar_screen.dart';
import 'package:simba_ultimate/ui/screens/verify_mail_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Authentication authentication = Authentication();
  bool isLoading = false;
  bool? isVerified;
  bool isPasswordHidden = true;

  togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    setState(() {});
  }

  login() async {
    setState(() {
      isLoading = true;
    });
    bool internet = await authentication.checkInternetConnectivity();

    if (email.isNotEmpty && password.isNotEmpty) {
      if (internet) {
        authentication.getFirstNameAlternatively();
        final loggingInUser = await authentication.logInUser(email, password);
        if (loggingInUser != null) {
          isVerified = await authentication.checkIfMailVerified();
          if (isVerified!) {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => GetDocs()));
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()));
          } else {
            authentication.sendVerificationMail();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VerifyMailScreen()));
          }
        } else {
          final exception = authentication.exception;
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
      isLoading = false;
    });
  }

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldWidget(
              onChanged: (val) {
                email = val;
              },
              width: 350,
              hintText: 'E-mail',
            ),
            const SizedBox(
              height: 20.0,
            ),
            PasswordTextFieldWidget(
              isPasswordHidden: isPasswordHidden,
              onChanged: (val) {
                password = val.trim();
              },
              onTap: togglePassword,
              width: 350,
              hintText: 'password',
            ),
            const SizedBox(
              height: 40.0,
            ),
            TextButtonWidget(
              child: isLoading
                  ? const CupertinoActivityIndicator()
                  : const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: () {
                login();
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
    );
  }
}
