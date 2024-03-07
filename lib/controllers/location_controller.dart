import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sakhii/controllers/friends_controller.dart';
import 'package:sakhii/models/User.dart';
import 'package:sakhii/utils/constants.dart';
import 'package:sakhii/utils/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;

class LocationController extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  RxDouble longitude = 0.0.obs;
  RxDouble latitude = 0.0.obs;
  final Duration updateInterval = const Duration(seconds: 5);
  late User user;
  late io.Socket socketServer;
  Map<String, dynamic> userLocations = {};
  final FriendsController friendsController = Get.put(FriendsController());
  bool hasSosSent = false;
  bool isOtpVerified = false;

  @override
  void onInit() {
    super.onInit();
    getLoggedUser();
    getCurrentLocation();
    startLocationUpdates();
  }

  Future<void> getLoggedUser() async {
    try {
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
        connectToServer();
        update();
      } else {

      }
    } catch (e) {
      debugPrint("$e");
    }
    finally{
      update();
    }
  }

  void connectToServer() {
    socketServer = io.io(Constants.socketURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'userId': user.id},
    });
    socketServer.connect();
    socketServer.on('live_location_update', (data) {
      debugPrint('Received location update: $data');
       updateLocationData(data);
       fetchFriendDetails(data['userId']);
       update();
    });
  }

  void fetchFriendDetails(String userId) async {
    bool containsUser = friendsController.friends.any((friend) => friend.id == userId);
    if (containsUser) {
      User friend = friendsController.friends.firstWhere((friend) => friend.id == userId);
      userLocations[userId] = {'latitude': latitude.value, 'longitude': longitude.value, 'friend': friend};
      update();
    }
  }

  void updateLocationData(Map<String, dynamic> data) {
    String userId = data['userId'];
    double latitude = data['latitude'];
    double longitude = data['longitude'];
    userLocations[userId] = {'latitude': latitude, 'longitude': longitude};
    update();
  }

  int timeToSeconds(String timeString) {
    switch (timeString) {
      case '1 Hour':
        return 3600;
      case '8 Hour':
        return 8 * 3600;
      case '1 day':
        return 24 * 3600;
      default:
        return -1;
    }
  }

  void sendTrackMeRequest(List<String> friendIds, String timeInSeconds) {
    try {
      int time = timeToSeconds(timeInSeconds);

      // Emit the initial track_me event with user ID, friend IDs, and time
      socketServer.emit('track_me', {
        'userId': user.id,
        'friendIds': friendIds,
        'time': time,
        'latitude': latitude.value,
        'longitude': longitude.value,
      });

      // Start sending live location updates every 7 seconds
      Timer.periodic(const Duration(seconds: 7), (timer) {
        // Check if the time has elapsed
        if (time <= 0) {
          timer.cancel(); // Stop the timer if time has elapsed
        } else {
          socketServer.emit('track_me', {
            'userId': user.id,
            'friendIds': friendIds,
            'time': time,
            'latitude': latitude.value,
            'longitude': longitude.value,
          });
          time -= 7; // Decrement the time by 7 seconds
        }
      });
    } catch (error) {
      print('Error sending track_me request: $error');
    }
  }

  void sendSosRequest(List<String> friendIds, String timeInSeconds) {
    try {
      int time = timeToSeconds(timeInSeconds);
      if (isOtpVerified) {
        debugPrint('OTP is not verified. Aborting SOS request.');
        return;
      }
      socketServer.emit('track_me', {
        'userId': user.id,
        'friendIds': friendIds,
        'time': time,
        'latitude': latitude.value,
        'longitude': longitude.value,
      });
      Timer.periodic(const Duration(seconds: 7), (timer) {
        if (time <= 0) {
          timer.cancel();
        } else {
          socketServer.emit('track_me', {
            'userId': user.id,
            'friendIds': friendIds,
            'time': time,
            'latitude': latitude.value,
            'longitude': longitude.value,
          });
          time -= 7;
        }
      });
    } catch (error) {
      debugPrint('Error sending track_me request: $error');
    }
  }

  void startLocationUpdates() {
    Timer.periodic(updateInterval, (timer) async {
      await getCurrentLocation();
    });
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permission denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permission denied forever.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition.value = position;
      longitude.value = position.longitude;
      latitude.value = position.latitude;
      update();
      debugPrint("Longitude: ${position.longitude}, Latitude: ${position.latitude}");
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  Future<void> sendSosMessage(double longitude, double latitude) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/user/sendsos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, dynamic>{
          'longitude': longitude,
          'latitude': latitude,
        }),
      );
      if (response.statusCode == 200) {
        hasSosSent = true;
        isOtpVerified = false;
        update();
        Get.snackbar('Success', 'SOS message sent successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Failed to send SOS message', 'Please try again',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Error sending SOS message: $e');
    } finally {
      debugPrint("Getting SOS Contacts");
      List<String> sosContactIds = await Get.find<FriendsController>().getSOSContactsIds();
      print(sosContactIds);
      sendSosRequest(sosContactIds, '1 day');
    }
  }

  Future<bool> verifySafeOtp(String otp) async {
    try {
      var accessToken = await TokenManager.getAccessToken();
      final response = await http.post(
        Uri.parse('${Constants.apiURL}/user/verifysafeotp'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, dynamic>{
          'safeOtp': otp
        }),
      );
      if (response.statusCode == 200) {
        isOtpVerified = true;
        hasSosSent = false;
        update();
        return true;
      } else {
        Get.snackbar('Failed to verify otp', 'Please enter correct otp',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return false;
      }
    } catch (e) {
      debugPrint('Error sending SOS message: $e');
      return false;
    }
  }
}
