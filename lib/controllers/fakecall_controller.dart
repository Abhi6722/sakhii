import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FakeCallController extends GetxController {
  var name = "Shweta".obs;
  var number = "+916386248082".obs;
  var selectedTime = 5.obs;
  var selectedImage = "assets/images/user-avatar.png".obs;

  void saveCallerDetails(String name, String number, int time, String? image) {
    debugPrint("Name: $name, Number: $number, Time: $time, Image: $image");
    this.name.value = name;
    this.number.value = number;
    selectedTime.value = time;
    if (image != null) {
      selectedImage.value = image;
    }
    update();
  }
}
