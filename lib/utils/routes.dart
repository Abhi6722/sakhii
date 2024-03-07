import 'package:flutter/material.dart';
import 'package:sakhii/screens/home_screen.dart';
import 'package:sakhii/screens/login_screen.dart';
import 'package:sakhii/screens/menuscreens/menu_screen.dart';
import 'package:sakhii/screens/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => HomeScreen(),
  '/splash-screen': (BuildContext context) => SplashScreen(),
  '/login': (BuildContext context) => const LoginScreen(),
  '/menu-screen': (BuildContext context) => const MenuScreen(),
};