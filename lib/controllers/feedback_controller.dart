import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class FeedbackController extends GetxController {
  final TextEditingController descriptionController = TextEditingController();
  final RxDouble feedbackValue = 0.0.obs;

  Future<void> sendFeedback() async {
    try {
      final String description = descriptionController.text;
      final String status = feedbackValue.value == 0.0
          ? 'Happy'
          : feedbackValue.value == 1.0
          ? 'Unhappy'
          : 'Confused';

      final http.Response response = await http.post(
        Uri.parse('${Constants.apiURL}/user/feedback'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': status,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Feedback sent successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Failed to submit Feedback', "Please try again",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Failed to submit Feedback', "Please try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void setFeedbackValue(double value) {
    feedbackValue.value = value;
    print('Feedback value changed: $value');
  }
}