import 'package:flutter/material.dart';

Color color = const Color(0xFF120E40);

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
    return Container(
      width: width,
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
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blue,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}

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
        left: 95.0,
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
