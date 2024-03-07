import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/utils/routes.dart';
import 'package:sakhii/utils/theme.dart';
import 'controllers/bindings.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Handling a foreground message: ${message.messageId}");
    // Handle the incoming message according to your app logic
  });
  // Set up notification tap handler
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("User tapped on a notification: ${message.messageId}");
    // Handle the notification tap according to your app logic
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: myTheme,
      title: "Sakhii",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: routes,
      initialBinding: AllBinder(),
    );
  }
}