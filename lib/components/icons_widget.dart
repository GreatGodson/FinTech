import 'package:flutter/material.dart';

class TransactionIcons extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const TransactionIcons(
      {Key? key,
      required this.color,
      required this.title,
      required this.onTap,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: color,
            radius: 30.0,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
