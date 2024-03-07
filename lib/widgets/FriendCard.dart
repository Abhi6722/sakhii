import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/friends_controller.dart';
import 'package:sakhii/controllers/user_controller.dart';
import 'package:sakhii/models/User.dart';
import 'package:sakhii/utils/theme.dart';

class FriendCard extends StatelessWidget {
  final User friend;

  const FriendCard({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendsController = Get.find<FriendsController>();
    final userController = Get.find<UserController>();

    bool isInSosContacts = friendsController.sosUsers.any((user) => user.id == friend.id);
    bool currentUserInFriendSOS = friend.sosUsers.contains(userController.user.id);

    return GestureDetector(
      onTap: () {
        // Navigate to the friend's profile screen
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: ClipOval(
                    child: Image.network(
                      friend.image,
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
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      friend.mobile,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        if (isInSosContacts)
                          Chip(
                            label: const Text(
                              'SOS Contact',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: myTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                        const SizedBox(width: 5,),
                        if (currentUserInFriendSOS)
                          Chip(
                            label: const Text(
                              'Trusts you',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: myTheme.primaryColorLight,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    if (isInSosContacts) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'remove_sos',
                          child: Text('Remove from SOS'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'block',
                          child: Text('Block'),
                        ),
                      ];
                    } else {
                      return [
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'add_sos',
                          child: Text('Add to SOS'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'block',
                          child: Text('Block'),
                        ),
                      ];
                    }
                  },
                  onSelected: (String value) {
                    // Handle menu item selection
                    switch (value) {
                      case 'delete':
                        friendsController.deleteFriend(friend.id);
                        break;
                      case 'remove_sos':
                        friendsController.removeSosUser(friend.id);
                        break;
                      case 'block':
                        friendsController.blockUser(friend.id);
                        break;
                      case 'add_sos':
                        friendsController.addSosUser(friend.id);
                        break;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
