import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double topPadding = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() => topPadding = 200); // Animate from 0 to 200
    });
    Future.delayed(Duration(seconds: 2), checkLogin);
  }

  void checkLogin() {
    final user = FirebaseAuth.instance.currentUser;
    Get.offNamed(user != null ? AppRoutes.dashboard : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.easeOutBack,
              padding: EdgeInsets.only(top: topPadding),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Expense Tracker",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            CircularProgressIndicator(
              color: Colors.teal,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
