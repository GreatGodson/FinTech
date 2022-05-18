import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simba_ultimate/styles/theme.dart';
import 'ui/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (ctx, child) {
        ScreenUtil.init(ctx);
        return Theme(
          child: child!,
          data: ThemeData(
            scaffoldBackgroundColor: blackTheme,
            appBarTheme: const AppBarTheme(color: blackTheme),
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}
