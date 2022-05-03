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
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          width: 310,
          height: 200,
          decoration: BoxDecoration(
              color: const Color(0xFF120E40),
              borderRadius: BorderRadius.circular(50.0)),
        ),
      ),
      Positioned(
        top: 135.0,
        left: 9.0,
        bottom: 15.0,
        child: Image.asset(
          'images/group9.png',
          width: 50,
          height: 50,
        ),
      ),
      const Positioned(
        top: 50.0,
        left: 140.0,
        child: Text(
          'Balance',
          style: TextStyle(color: Colors.grey, fontSize: 20.0),
        ),
      ),
      Positioned(
        top: 80.0,
        left: 75.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: balance,
        ),
      ),
      Positioned(
        top: 145.0,
        left: 153.0,
        child: Text(
          currency,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.grey, fontSize: 13.0, letterSpacing: 2.0),
        ),
      ),
      Positioned(
        top: 20.0,
        left: 22.0,
        child: CircleAvatar(
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
      ),
    ]);
  }
}
