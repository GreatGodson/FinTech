import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/services/authentication.dart';
import 'package:simba_ultimate/ui/screens/navigation_bar_screen.dart';

class VerifyMailScreen extends StatefulWidget {
  const VerifyMailScreen({Key? key}) : super(key: key);

  @override
  _VerifyMailScreenState createState() => _VerifyMailScreenState();
}

class _VerifyMailScreenState extends State<VerifyMailScreen> {
  Authentication authentication = Authentication();

  Timer? timer;
  String? user;
  bool isLoading = false;
  bool isVerified = false;

  isUserVerified() async {
    isVerified = await authentication.checkIfMailVerified();
    if (isVerified) {
      timer?.cancel();
      setState(() {});
    }
  }

  currentUser() async {
    setState(() {
      isLoading = true;
    });
    user = await authentication.getCurrentUser();
    setState(() {
      isLoading = false;
    });
    return user;
  }

  @override
  void initState() {
    // TODO: implement initState
    timer = Timer.periodic(const Duration(seconds: 3), (_) => isUserVerified());
    currentUser();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    // isUserVerified().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isVerified
        ? const BottomNavBar()
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading
                    ? const CupertinoActivityIndicator()
                    : Text(
                        'A verification link was sent to: $user, please verify your email address ',
                        style: const TextStyle(color: Colors.white70),
                      ),
              ],
            ),
          );
  }
}
