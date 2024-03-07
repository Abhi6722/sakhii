import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/models/Community.dart';
import 'package:sakhii/utils/constants.dart';
import 'package:sakhii/utils/token_manager.dart';
import 'package:http/http.dart' as http;

class CommunityController extends GetxController {
  List<Community> allCommunities = [];
  List<Community> userCommunities = [];
  List<Community> allFilteredCommunities = [];
  List<Community> userFilteredCommunities = [];
  bool isLoading = false;

  void filterCommunities(String searchText) {
    if (searchText.isEmpty) {
      allFilteredCommunities = allCommunities;
    } else {
      allFilteredCommunities = allCommunities.where((community) =>
      community.name.toLowerCase().contains(searchText.toLowerCase()) ||
          community.location.toLowerCase().contains(searchText.toLowerCase())).toList();
    }
    update();
  }

  void filterUserCommunities(String searchText) {
    if (searchText.isEmpty) {
      userFilteredCommunities = userCommunities;
    } else {
      userFilteredCommunities = userCommunities.where((community) =>
      community.name.toLowerCase().contains(searchText.toLowerCase()) ||
          community.location.toLowerCase().contains(searchText.toLowerCase())).toList();
    }
    update();
  }

  void resetFilters() {
    allFilteredCommunities = allCommunities;
    userFilteredCommunities = userCommunities;
  }

  Future<void> fetchAllCommunities() async {
    try {
      isLoading = true;
      update();
      var accessToken = await TokenManager.getAccessToken();
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiURL}/community/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> communityData = json.decode(response.body);
        List<Community> communities = communityData
            .map((jsonCommunity) => Community.fromJson(jsonCommunity))
            .toList();
        allCommunities = communities;
        allFilteredCommunities = communities;
        update();
      } else {
        // Handle error response
      }
    } catch (e) {
      debugPrint("$e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchUserCommunities() async {
    try {
      isLoading = true;
      update();
      var accessToken = await TokenManager.getAccessToken();
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiURL}/community/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> communityData = json.decode(response.body);
        List<Community> communities = communityData
            .map((jsonCommunity) => Community.fromJson(jsonCommunity))
            .toList();
        userCommunities = communities;
        userFilteredCommunities = communities;
        update();
      } else {
        // Handle error response
      }
    } catch (e) {
      debugPrint("$e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> createCommunity(String name, String description, String category, String location) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/community/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'description': description,
          'category': category,
          'location': location,
        }),
      );
      print(response.body);

      if (response.statusCode == 201) {
        await fetchUserCommunities();
        await fetchAllCommunities();
        update();
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

  bool isUserJoined(String communityId) {
    return userCommunities.any((community) => community.id == communityId);
  }

  Future<void> joinCommunity(String communityId) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final http.Response response = await http.post(
        Uri.parse('${Constants.apiURL}/community/$communityId/join'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        fetchAllCommunities();
        fetchUserCommunities();
        update();
        // User successfully joined the community
        // You can perform any actions here after successful join
      } else if (response.statusCode == 400) {
        // User has already joined this community
        // Handle the case or display a message to the user
      } else if (response.statusCode == 404) {
        // Community not found
        // Handle the case or display a message to the user
      } else {
        // Handle other error responses
      }
    } catch (e) {
      // Exception occurred during the request
      // Handle the exception or display an error message
    }
  }

  Future<void> leaveCommunity(String communityId) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final http.Response response = await http.post(
        Uri.parse('${Constants.apiURL}/community/$communityId/leave'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        fetchAllCommunities();
        fetchUserCommunities();
        update();
        // User successfully joined the community
        // You can perform any actions here after successful join
      } else if (response.statusCode == 400) {
        // User has already joined this community
        // Handle the case or display a message to the user
      } else if (response.statusCode == 404) {
        // Community not found
        // Handle the case or display a message to the user
      } else {
        // Handle other error responses
      }
    } catch (e) {
      // Exception occurred during the request
      // Handle the exception or display an error message
    }
  }

  Future<void> createPost(String title, String description, String location, String image, String communityId) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/post/$communityId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, String>{
          'title': title,
          'description': description,
          'location': location,
          'image': image,
        }),
      );

      if (response.statusCode == 201) {
        fetchAllCommunities();
        fetchUserCommunities();
        update();
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
