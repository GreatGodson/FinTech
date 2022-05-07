import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final double width;
  final String hintText;
  final Function(String) onChanged;
  const TextFieldWidget(
      {Key? key,
      required this.width,
      required this.hintText,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      // height: height / 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.blueGrey)),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(12.0),
          hintStyle: const TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}
