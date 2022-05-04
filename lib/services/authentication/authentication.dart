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
  final currentUser = FirebaseAuth.instance.currentUser;
  final loggedInUserUID = FirebaseAuth.instance.currentUser!.uid;

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

  getCurrentUserEmail() async {
    try {
      if (currentUser != null) {
        loggedInUser = currentUser;
        // print(loggedInUser?.email);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    return loggedInUser?.email;
  }

  sendVerificationMail() {
    currentUser?.sendEmailVerification();
  }

  Future<bool> checkIfMailVerified() async {
    bool? isEmailVerified;
    await currentUser?.reload();
    isEmailVerified = currentUser?.emailVerified;
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
    final data = await collection.doc(loggedInUserUID).get();
    String firstName = data["firstName"];
    print(firstName);
    return firstName;
  }

  getUserDollarBalance() async {
    final data = await collection.doc(loggedInUserUID).get();
    int dollarBalance = data["usdBalance"];
    return dollarBalance;
  }

  getUserGBPBalance() async {
    final data = await collection.doc(loggedInUserUID).get();
    int gbpBalance = data["gbpBalance"];
    return gbpBalance;
  }

  getUserNairaBalance() async {
    final data = await collection.doc(loggedInUserUID).get();
    int nairaBalance = data["ngnBalance"];

    return nairaBalance;
  }

  getFirstNameAlternatively() async {
    await for (var snapshot in FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUserUID)
        .snapshots()) {
      print('name is: ${snapshot.data()?['firstName']}');
      print(loggedInUserUID);
    }
  }
}
