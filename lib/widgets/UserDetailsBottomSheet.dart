// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sakhii/models/User.dart';
import 'package:sakhii/utils/theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailsBottomSheet extends StatelessWidget {
  final User user;
  final double longitude;
  final double latitude;

  const UserDetailsBottomSheet({Key? key, required this.user, required this.longitude, required this.latitude}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Center(
            child: Column(
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Updated at ${_getCurrentDateTime()}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionIcon(Icons.call, 'Call', (){
                String userNumber = user.mobile;
                launch('tel:$userNumber');
              }),
              _buildActionIcon(Icons.message, 'Message', (){
                String userNumber = user.mobile;
                launch('sms:$userNumber');
              }),
              _buildActionIcon(Icons.map, 'Location', (){
                String liveLocation = "https://maps.google.com/?q=$latitude,$longitude";
                launch(liveLocation);
              }),
              _buildActionIcon(Icons.share, 'Share', (){
                String locationUrl = "https://maps.google.com/?q=$latitude,$longitude";
                Share.share('Check out ${user.name}\'s location: $locationUrl', subject: 'User Location');
              }),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton('Direction', Icons.directions, (){
                String liveLocation = "https://maps.google.com/?q=$latitude,$longitude";
                launch(liveLocation);
              }),
              _buildButton('Call Police', Icons.call, () {
                launch('tel:100');
              }),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.black),
            const SizedBox(height: 2,),
            Text(label, style: const TextStyle(fontSize: 12),),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: myTheme.primaryColor,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentDateTime() {
    DateTime now = DateTime.now();
    return "${_getDayName(now.weekday)}, ${_getMonthName(now.month)} ${now.day}, ${now.year} - ${_formatTime(now)}";
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  String _formatTime(DateTime time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(time.hour)}:${twoDigits(time.minute)}:${twoDigits(time.second)} ${time.hour > 11 ? 'PM' : 'AM'}';
  }
}
