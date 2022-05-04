import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:simba_ultimate/constants.dart';

class Authentication {
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  final collection = FirebaseFirestore.instance.collection('users');
  String? exception;
  User? loggedInUser;

  registerUser(email, password, firstName, lastName, usdBalance, gbpBalance,
      ngnBalance) async {
    try {
      final newUser = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (newUser.user != null) {
        uid = newUser.user?.uid;
        store.collection("users").doc(uid).set({
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

  getCurrentUser() async {
    final user = auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser?.email);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    print(loggedInUser?.displayName);
    return loggedInUser?.email;
  }

  sendVerificationMail() {
    auth.currentUser?.sendEmailVerification();
  }

  Future<bool> checkIfMailVerified() async {
    bool? isEmailVerified;
    await auth.currentUser?.reload();
    isEmailVerified = auth.currentUser?.emailVerified;
    print(isEmailVerified);
    return isEmailVerified!;
  }

  logInUser(email, password) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return user.user;
    } on FirebaseAuthException catch (e) {
      exception = e.message;
    }
  }

  logOutUser() async {
    await auth.signOut();
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

  getUserFirstName() async {
    final user = auth.currentUser;
    final userUid = user!.uid;
    final data = await collection.doc(userUid).get();
    String firstName = data["firstName"];
    print(firstName);
    return firstName;
  }

  getUserDollarBalance() async {
    final user = auth.currentUser;
    final userUid = user!.uid;
    final data = await collection.doc(userUid).get();
    int dollarBalance = data["usdBalance"];
    return dollarBalance;
  }

  getUserGBPBalance() async {
    final user = auth.currentUser;
    final userUid = user!.uid;
    final data = await collection.doc(userUid).get();
    int gbpBalance = data["gbpBalance"];
    return gbpBalance;
  }

  getUserNairaBalance() async {
    final user = auth.currentUser;
    final userUid = user!.uid;
    final data = await collection.doc(userUid).get();
    int nairaBalance = data["ngnBalance"];
    return nairaBalance;
  }

  // getFirstNameAlternatively() async {
  //   final user = auth.currentUser;
  //   final userUid = user!.uid;
  //   var snapshot = collection.doc(userUid).snapshots();
  // }
}
