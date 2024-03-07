import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/friends_controller.dart';
import 'package:sakhii/controllers/user_controller.dart';
import 'package:sakhii/screens/menuscreens/blocklist_screen.dart';
import 'package:sakhii/screens/menuscreens/feedback_screen.dart';
import 'package:sakhii/screens/menuscreens/friends_screen.dart';
import 'package:sakhii/screens/menuscreens/history_screen.dart';
import 'package:sakhii/screens/menuscreens/profile_edit_screen.dart';
import 'package:sakhii/screens/menuscreens/profile_screen.dart';
import 'package:sakhii/utils/theme.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/images/logo_dark.png", height: 60,),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Icon(Icons.close, color: myTheme.primaryColor), // Use your theme color for icon
                        ),
                      ),
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
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const ProfileCard(),
                              Wrap(
                                children: [
                                  MenuCard(title: "History", imageUrl: "assets/icons/history.png", onTap: (){Get.to(()=>const HistoryScreen());},),
                                  MenuCard(title: "Friends", imageUrl: "assets/icons/friends.png", onTap: () async {
                                      await Get.find<FriendsController>().getAllFriends();
                                      await Get.find<FriendsController>().getAllFriendRequests();
                                      await Get.find<FriendsController>().getAllSosUsers();
                                      Get.to(()=>const FriendsScreen());
                                  },),
                                  MenuCard(title: "Block List", imageUrl: "assets/icons/block-list.png", onTap: () async {
                                      await Get.find<FriendsController>().getBlockedUsers();
                                      Get.to(()=>const BlockListScreen());
                                  },),
                                  MenuCard(title: "Feedback", imageUrl: "assets/icons/feedback.png", onTap: (){Get.to(()=>const FeedbackScreen());},),
                                  MenuCard(title: "Legal", imageUrl: "assets/icons/legal.png", onTap: (){},),
                                  MenuCard(title: "Help", imageUrl: "assets/icons/help.png", onTap: (){},),
                                  MenuCard(title: "Settings", imageUrl: "assets/icons/settings.png", onTap: (){},),
                                  MenuCard(title: "Logout", imageUrl: "assets/icons/logout.png", onTap: (){},),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const CircularProgressIndicator();
        } else {
          return GestureDetector(
            onTap: () {
              Get.to(() => ProfileScreen());
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/user-avatar.png'),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.user.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        controller.user.mobile,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.to(() => ProfileEditScreen());
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  const MenuCard({super.key, required this.title, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 110,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imageUrl, height: 40,),
            const SizedBox(height: 20,),
            Text(title,style: TextStyle(fontSize: 15.0,color: myTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}