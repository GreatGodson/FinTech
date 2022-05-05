import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:simba_ultimate/constants.dart';

class Authentication {
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  final collection = FirebaseFirestore.instance.collection('users');
  // final currentUser = FirebaseAuth.instance.currentUser;
  // final loggedInUserUID = FirebaseAuth.instance.currentUser!.uid;

  String? exception;
  User? loggedInUser;

  // Future getLoggedInUserUid() async {
  //   return loggedInUserUID;
  // }

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

  getCurrentUserEmail() async {
    User? user = auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser?.email);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    return loggedInUser?.email;
  }

  sendVerificationMail() {
    User? user = auth.currentUser;
    user?.sendEmailVerification();
  }

  Future<bool> checkIfMailVerified() async {
    bool? isEmailVerified;
    User? user = auth.currentUser;
    await user?.reload();
    isEmailVerified = user?.emailVerified;
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
    User? user = auth.currentUser;
    final userUid = user!.uid;
    final data = await collection.doc(userUid).get();
    String firstName = data["firstName"];
    print(firstName);
    return firstName;
  }

  getUserDollarBalance() async {
    User? user = auth.currentUser;
    final userUid = user!.uid;
    final data = await collection.doc(userUid).get();
    int dollarBalance = data["usdBalance"];
    return dollarBalance;
  }

  getUserGBPBalance() async {
    User? user = auth.currentUser;
    final userUid = user!.uid;
    final data = await collection.doc(userUid).get();
    int gbpBalance = data["gbpBalance"];
    return gbpBalance;
  }

  getUserNairaBalance() async {
    User? user = auth.currentUser;
    final userUid = user!.uid;
    final data = await collection.doc(userUid).get();
    int nairaBalance = data["ngnBalance"];
    // print(userUid);
    return nairaBalance;
  }

  getFirstNameAlternatively() async {
    User? user = auth.currentUser;
    if (user != null) {
      final userUid = user.uid;
      await for (var snapshot in FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .snapshots()) {
        print('name is: ${snapshot.data()?['firstName']}');
        print(userUid);
      }
    }
  }
}
