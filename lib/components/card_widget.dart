import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final String imageName;
  final String currency;
  final Widget balance;
  const ReusableCard(
      {Key? key,
      required this.imageName,
      required this.currency,
      required this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: width / 1.25,
        // height: height / 2,
        decoration: BoxDecoration(
            color: const Color(0xFF120E40),
            borderRadius: BorderRadius.circular(50.0)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Container(
                      height: 90,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'images/$imageName',
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Balance',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
              balance,
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      'images/group9.png',
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(
                      width: width / 3.8,
                    ),
                    Text(
                      currency,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                          letterSpacing: 2.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
