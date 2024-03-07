import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sakhii/models/User.dart';
import 'package:sakhii/utils/constants.dart';
import 'package:sakhii/utils/token_manager.dart';

class UserController extends GetxController {
  late User user;
  bool isLoading = false;

  Future<void> getLoggedUser() async {
    try {
      isLoading = true;
      var accessToken = await TokenManager.getAccessToken();
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiURL}/user/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);
        user = User.fromJson(userData['user']);
        update();
      } else {

      }
    } catch (e) {
      debugPrint("$e");
    }
    finally{
      isLoading = false;
      update();
    }
  }

  Future<void> updateUser(String name, String gender, int age) async {
    try {
      isLoading = true;
      update();
      var accessToken = await TokenManager.getAccessToken();
      final http.Response response = await http.put(
        Uri.parse('${Constants.apiURL}/user/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          'name': name,
          'gender': gender,
          'age': age,
        }),
      );

      if (response.statusCode == 200) {
        await getLoggedUser();
        update();
        Get.snackbar('Success', "Profile updated successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        debugPrint(response.body);
        Get.snackbar('Failed to update user', "Please try again later.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("$e");
    } finally {
      isLoading = false;
      update();
    }
  }
}