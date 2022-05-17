import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simba_ultimate/constants.dart';

class Authentication {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  String? exception;
  User? _loggedInUser;

  Future registerUser(email, password, firstName, lastName, usdBalance,
      gbpBalance, ngnBalance) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (newUser.user != null) {
        uid = newUser.user?.uid;
        _store.collection("users").doc(uid).set({
          'uid': uid,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'usdBalance': usdBalance,
          'gbpBalance': gbpBalance,
          'ngnBalance': ngnBalance,
        });
        sendVerificationMail();

        return uid;
      }
    } on FirebaseAuthException catch (e) {
      exception = e.message;
    }
  }

  Future<String?> getCurrentUserEmail() async {
    User? user = _auth.currentUser;
    try {
      if (user != null) {
        _loggedInUser = user;
      }
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
    return _loggedInUser?.email;
  }

  void sendVerificationMail() {
    User? user = _auth.currentUser;
    user?.sendEmailVerification();
  }

  Future<bool> checkIfMailVerified() async {
    bool? isEmailVerified;
    User? user = _auth.currentUser;
    await user?.reload();
    isEmailVerified = user?.emailVerified;
    print(isEmailVerified);
    return isEmailVerified!;
  }

  Future logInUser(email, password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      uid = user.user!.uid;
      return user.user;
    } on FirebaseAuthException catch (e) {
      exception = e.message;
    }
  }

  Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> logOutUser() async {
    await _auth.signOut();
  }

  // getUserDollarBalance() async {
  //   User? user = auth.currentUser;
  //   final userUid = user!.uid;
  //   final data = await collection.doc(userUid).get();
  //   int dollarBalance = data["usdBalance"];
  //   return dollarBalance;
  // }

}
