import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testdemo/persistence/login_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:testdemo/widgets/custom_image_view.dart';

import 'core/utils/image_constant.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    setState(() {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: const LoginScreen()));
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CustomImageView(
                radius: BorderRadius.circular(130),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.03),
                imagePath: ImageConstant.imglogo,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
            const Text("Wilson Wings")
          ],
        ),
      ),
    );
  }
}
