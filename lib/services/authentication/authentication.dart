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

  // userFirstName() async {
  //   DocumentSnapshot name = await store.collection("users").doc(uid).get();
  //   final firstName = name['firstName'];
  //   print(firstName);
  //   return firstName;
  // }

  // Future<String> getFirstName() async {
  //   DocumentReference documentReference = collection.doc(uid);
  //   String name;
  //   await documentReference.get().then((snapshot) {
  //     name = snapshot.data().toString();
  //   });
  //   return name;
  // }

  getData() async {
    DocumentSnapshot result =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // print(result);
    return result;
  }

  userDetails() async {
    final user = auth.currentUser;
    final userUid = user!.uid;
    final data = await collection.doc(userUid).get();
    String firstName = data["firstName"];
    print(firstName);
    return firstName;
  }
}
