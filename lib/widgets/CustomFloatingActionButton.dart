import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/location_controller.dart';
import 'package:sakhii/screens/sos/notifying_screen.dart';
import 'package:sakhii/screens/sos/sos_screen.dart';

class CustomFloatingActionButton extends StatelessWidget {
  CustomFloatingActionButton({super.key});

  final LocationController locationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(locationController.hasSosSent){
          Get.to(()=> const SosScreen());
        } else {
          Get.to(()=>const NotifyingScreen());
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emergency_share,
              size: 40,
              color: Colors.white,
            ),
            Text("SOS", style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
