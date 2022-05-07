import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  // final String title;
  final VoidCallback? onPressed;
  final Widget child;

  const TextButtonWidget({
    Key? key,
    // required this.title,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blue,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}
