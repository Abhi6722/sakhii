import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sakhii/utils/constants.dart';

class PostController extends GetxController {

  Future<void> createPost(String title, String description, String location, String image) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/community/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': title,
          'description': description,
          'location': location,
          'image': image,
        }),
      );

      if (response.statusCode == 201) {
        // Group created successfully
        // You can perform any actions here after successful creation
      } else {
        // Group creation failed
        // Handle error or display a message to the user
      }
    } catch (e) {
      // Exception occurred during the request
      // Handle the exception or display an error message
    }
  }
}
