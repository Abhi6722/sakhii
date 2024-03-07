import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/location_controller.dart';
import 'package:sakhii/screens/sos/sos_screen.dart';
import 'package:sakhii/utils/theme.dart';
import 'dart:async';

class NotifyingScreen extends StatefulWidget {
  const NotifyingScreen({Key? key}) : super(key: key);

  @override
  NotifyingScreenState createState() => NotifyingScreenState();
}

class NotifyingScreenState extends State<NotifyingScreen> {
  final LocationController locationController = Get.find();
  int _countdown = 5;
  late Timer _timer;
  double _containerSize = 150.0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
          _containerSize = _containerSize == 150.0 ? 170.0 : 150.0;
        } else {
          _timer.cancel();
          sendSOSMessage();
          Get.off(()=> const SosScreen());
        }
      });
    });
  }

  Future<void> sendSOSMessage () async {
    await locationController.getCurrentLocation();
    final currentPosition = locationController.currentPosition.value;
    if (currentPosition != null) {
      await locationController.sendSosMessage(
        currentPosition.longitude,
        currentPosition.latitude,
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myTheme.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo_dark.png",
                  height: 100,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Notifying your SOS contacts in",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: _containerSize + 20,
                    height: _containerSize + 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        _countdown.toString(),
                        style: TextStyle(
                          color: myTheme.primaryColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 18.0,
                      ), backgroundColor: null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    child: const Text(
                      'Cancel SOS',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // await sendSOSMessage();
                      Get.off(()=>const SosScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 18.0,
                      ), backgroundColor: myTheme.primaryColorDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Skip Countdown',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
