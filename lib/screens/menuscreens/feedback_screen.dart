import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sakhii/utils/constants.dart';
import 'package:sakhii/utils/token_manager.dart';
import '../../utils/theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  FeedbackScreenState createState() => FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController descriptionController = TextEditingController();
  double _feedbackValue = 0;
  Widget _buildFeedbackImage(double feedbackValue) {
    if (feedbackValue == 0) {
      return Image.asset('assets/icons/happy.png');
    } else if (feedbackValue == 1) {
      return Image.asset('assets/icons/unhappy.png');
    } else {
      return Image.asset('assets/icons/confused.png');
    }
  }

  Future<void> sendFeedback() async {
    print("submit called");
    try {
      final String description = descriptionController.text;
      final String status = _feedbackValue == 0
          ? 'Happy'
          : _feedbackValue == 1
          ? 'Unhappy'
          : 'Confused';
      var accessToken = await TokenManager.getAccessToken();
      print(accessToken);
      final http.Response response = await http.post(
        Uri.parse('${Constants.apiURL}/user/feedback'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myTheme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              color: myTheme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Feedback",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  width: double.infinity,
                  color: myTheme.scaffoldBackgroundColor,
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            "How do you feel using our app?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(child: _buildFeedbackImage(_feedbackValue)),
                        const SizedBox(height: 30),
                        Slider(
                          activeColor: myTheme.primaryColor,
                          value: _feedbackValue,
                          min: 0,
                          max: 2,
                          divisions: 2,
                          label: _feedbackValue == 0
                              ? 'Happy'
                              : _feedbackValue == 1
                                  ? 'Unhappy'
                                  : 'Confused',
                          onChanged: (newValue) {
                            setState(() {
                              _feedbackValue = newValue;
                            });
                          },
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Happy'),
                            Text('Unhappy'),
                            Text('Confused'),
                          ],
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          "Tell us more",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: descriptionController,
                          maxLines: 5,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myTheme.primaryColor),
                            ),
                          ),
                          cursorColor: myTheme.primaryColor,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              sendFeedback();
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
