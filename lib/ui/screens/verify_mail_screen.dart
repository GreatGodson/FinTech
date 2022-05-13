import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/services/authentication/authentication.dart';
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
    user = await authentication.getCurrentUserEmail();
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
            appBar: AppBar(
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              elevation: 0.0,
              title: const Text(
                'Welcome',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Column(
              children: [
                isLoading
                    ? const CupertinoActivityIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(
                            bottom: 30, left: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Please verify your email address',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          'A verification link was sent to $user. Kindly verify your mail.',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Didn\'t get a verification link?',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'send link',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
