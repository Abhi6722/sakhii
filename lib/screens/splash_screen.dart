import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sakhii/screens/home_screen.dart';
import 'package:sakhii/utils/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                "assets/images/logo.png",
                width: 220,
              ),
              const SizedBox(height: 10),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: myTheme.primaryColorLight,
                      color: myTheme.primaryColor,
                    ),
                    const SizedBox(height: 20,),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        children: [
                          const TextSpan(
                            text: "By continuing you agree that you have read and accepted our ",
                          ),
                          TextSpan(
                            text: "T&Cs",
                            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                            // Add your T&Cs link handler here
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Add your T&Cs link handling logic here
                              },
                          ),
                          const TextSpan(
                            text: " and ",
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                            // Add your Privacy Policy link handler here
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Add your Privacy Policy link handling logic here
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }
}
