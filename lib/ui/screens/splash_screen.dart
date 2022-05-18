import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/constants.dart';
import 'package:simba_ultimate/services/authentication/authentication.dart';
import 'package:simba_ultimate/ui/screens/login_screen.dart';
import 'package:simba_ultimate/ui/screens/navigation_bar_screen.dart';

import 'dart:async';

import 'package:simba_ultimate/ui/screens/registration_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //this function creates a 4 seconds delay before returning the login screen
  void screenDelay() {
    var duration = const Duration(seconds: 4);
    Timer(duration, () {
      FirebaseAuth.instance.currentUser == null
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            )
          : signInExistingUser();
    });
  }

  Authentication authentication = Authentication();
  signInExistingUser() {
    setState(() {
      uid = FirebaseAuth.instance.currentUser!.uid;
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const BottomNavBar()));
  }

  stateChanges() {
    final user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('user is signed out');
      } else {
        print('user signed in ${user.email}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screenDelay();
    stateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'SIMBA',
                style: TextStyle(
                  fontSize: 50.0,
                  letterSpacing: 10.0,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
