import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/friends_controller.dart';
import 'package:sakhii/models/User.dart';

class PendingRequestCard extends StatelessWidget {
  final User pendingRequest;

  const PendingRequestCard({Key? key, required this.pendingRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: ClipOval(
            child: Image.network(
              pendingRequest.image,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const CircularProgressIndicator();
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset('assets/images/default_avatar.png');
              },
            ),
          ),
        ),
        title: Text(
          pendingRequest.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          pendingRequest.email,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green,),
              onPressed: () {
                Get.find<FriendsController>().acceptFriendRequest(pendingRequest.id);
              },
            ),
            const SizedBox(width: 8.0), // Add spacing between buttons
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red,),
              onPressed: () {
                Get.find<FriendsController>().rejectFriendRequest(pendingRequest.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
