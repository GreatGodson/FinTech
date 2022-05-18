import 'package:flutter/material.dart';
import 'package:simba_ultimate/styles/text_style.dart';
import 'package:simba_ultimate/styles/theme.dart';

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
    Size size = MediaQuery.of(context).size;
    return Container(
      width: width,
      height: size.height / 15,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: blueGreyTheme)),
      child: TextField(
        onChanged: onChanged,
        style: KTextFieldTextStyle,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              EdgeInsets.only(left: size.width / 20, top: 14, bottom: 22),
          hintStyle: KHintTextStyle,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: blueTheme,
              ),
              borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}
