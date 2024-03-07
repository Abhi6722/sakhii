import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sakhii/models/User.dart';
import 'dart:convert';

import 'package:sakhii/utils/constants.dart';
import 'package:sakhii/utils/token_manager.dart';

class FriendsController extends GetxController {
  RxList<User> friends = <User>[].obs;
  RxList<User> pendingRequests = <User>[].obs;
  RxList<User> blockedUsers = <User>[].obs;
  RxList<User> sosUsers = <User>[].obs;

  Future<List<String>> getSOSContactsIds() async {
    await getAllSosUsers();
    return sosUsers.map((user) => user.id).toList();
  }

  Future<void> getAllFriends() async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http
          .get(Uri.parse('${Constants.apiURL}/user/friends'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        friends.assignAll(
          responseData.map((user) => User.fromJson(user)).toList(),
        );
      } else {
        debugPrint('Failed to load friends');
      }
    } catch (error) {
      debugPrint('Error fetching friends: $error');
    }
  }

  Future<void> getAllFriendRequests() async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http
          .get(Uri.parse('${Constants.apiURL}/user/friends/pending'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        pendingRequests.assignAll(
          responseData.map((user) => User.fromJson(user)).toList(),
        );
      } else {
        debugPrint('Failed to load friend requests');
      }
    } catch (error) {
      debugPrint('Error fetching friend requests: $error');
    }
  }

  Future<void> acceptFriendRequest(String id) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http
          .post(Uri.parse('${Constants.apiURL}/user/accept/$id'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        debugPrint('Friend request accepted successfully');
        await getAllFriends();
        await getAllFriendRequests();
        Get.snackbar('Success', "Friend accepted rejected successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        update();
      } else {
        debugPrint('Failed to accepted friend request');
        Get.snackbar('Failed', "Failed to accepted friend request",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      debugPrint('Error accepting friend request: $error');
    }
  }

  Future<void> rejectFriendRequest(String id) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http
          .post(Uri.parse('${Constants.apiURL}/user/reject/$id'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        debugPrint('Friend request rejected successfully');
        await getAllFriends();
        await getAllFriendRequests();
        Get.snackbar('Success', "Friend request rejected successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        update();
      } else {
        debugPrint('Failed to reject friend request');
        Get.snackbar('Failed', "Failed to reject friend request",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      debugPrint('Error rejecting friend request: $error');
    }
  }

  Future<void> deleteFriend(String friendId) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.delete(
        Uri.parse('${Constants.apiURL}/user/friends/$friendId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      if (response.statusCode == 200) {
        await getAllFriends();
        update();
        Get.snackbar('Success', "Friend deleted successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Failed to delete Friend', "Please try again later",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        debugPrint('Failed to delete friend: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error deleting friend: $error');
    }
  }

  Future<void> addFriendByMobile(String mobileNumber) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/user/friends/mobile/$mobileNumber'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', "Friend request sent successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Failed to send request', "Please try again later",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        debugPrint('Failed to add friend: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error adding friend: $error');
    }
  }

  Future<void> getBlockedUsers() async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.get(
        Uri.parse('${Constants.apiURL}/user/blocked'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        blockedUsers.assignAll(
          responseData.map((user) => User.fromJson(user)).toList(),
        );
      } else {
        debugPrint('Failed to load blocked users');
      }
    } catch (error) {
      debugPrint('Error fetching blocked users: $error');
    }
  }

  Future<void> blockUser(String id) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/user/block/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        debugPrint('User blocked successfully');
        await getAllFriends();
        update();
        Get.snackbar('Success', 'User blocked successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        debugPrint('Failed to block user');
        Get.snackbar('Failed', 'Failed to block user',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      debugPrint('Error blocking user: $error');
    }
  }

  Future<void> unBlockUser(String id) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/user/unblock/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        debugPrint('User unblocked successfully');
        await getBlockedUsers();
        update();
        Get.snackbar('Success', 'User unblocked successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        debugPrint('Failed to unblock user');
        Get.snackbar('Failed to unblock user', 'Please try again later',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      debugPrint('Error blocking user: $error');
    }
  }

  Future<void> getAllSosUsers() async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.get(Uri.parse('${Constants.apiURL}/user/sos'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        sosUsers.assignAll(
          responseData.map((user) => User.fromJson(user)).toList(),
        );
      } else {
        debugPrint('Failed to load SOS users');
      }
    } catch (error) {
      debugPrint('Error fetching SOS users: $error');
    }
  }

  Future<void> addSosUser(String userId) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/user/sos/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        await getAllFriends();
        await getAllSosUsers();
        update();
        Get.snackbar('Success', "SOS user added successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Failed to add SOS user', "Please try again later",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        debugPrint('Failed to add SOS user: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error adding SOS user: $error');
    }
  }

  Future<void> removeSosUser(String userId) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.delete(
        Uri.parse('${Constants.apiURL}/user/sos/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        await getAllFriends();
        await getAllSosUsers();
        update();
        Get.snackbar('Success', "SOS user removed successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Failed to remove SOS user', "Please try again later",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        debugPrint('Failed to remove SOS user: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error removing SOS user: $error');
    }
  }

  Future<void> sendTrackMeMessage(List<String> friendIds, String time) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/user/trackme'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, dynamic>{
          'friends': friendIds,
          'time': time,
        }),
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', "Location send to your friends",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Failed to share location', "Please try again later",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }
}
