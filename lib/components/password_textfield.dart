import 'package:flutter/material.dart';

class PasswordTextFieldWidget extends StatelessWidget {
  final double width;
  final String hintText;
  final bool isPasswordHidden;
  final VoidCallback onTap;
  final Function(String) onChanged;

  const PasswordTextFieldWidget(
      {Key? key,
      required this.width,
      required this.hintText,
      required this.onChanged,
      required this.isPasswordHidden,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.blueGrey)),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.visiblePassword,
        obscureText: isPasswordHidden,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(12.0),
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: InkWell(
              onTap: onTap,
              child: const Icon(
                (Icons.visibility),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}
