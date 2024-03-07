import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/friends_controller.dart';
import 'package:sakhii/screens/menuscreens/addfriends_screen.dart';
import 'package:sakhii/utils/theme.dart';
import 'package:sakhii/widgets/FriendCard.dart';
import 'package:sakhii/widgets/PendingRequestCard.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Friends",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'My Friends'),
                  Tab(text: 'Requests'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    MyFriendsTab(),
                    RequestsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: myTheme.primaryColor,
            onPressed: (){
              Get.to(()=>AddFriendScreen());
            },
            child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class MyFriendsTab extends StatelessWidget {
  const MyFriendsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: myTheme.scaffoldBackgroundColor,
      child: GetBuilder<FriendsController>(
        builder: (controller) => ListView.builder(
          itemCount: controller.friends.length,
          itemBuilder: (context, index) {
            final friend = controller.friends[index];
            return FriendCard(
              friend: friend,
            );
          },
        ),
      ),
    );
  }
}


class RequestsTab extends StatelessWidget {
  const RequestsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: myTheme.scaffoldBackgroundColor,
      child: GetBuilder<FriendsController>(
        builder: (controller) => ListView.builder(
          itemCount: controller.pendingRequests.length,
          itemBuilder: (context, index) {
            final pendingRequest = controller.pendingRequests[index];
            return PendingRequestCard(pendingRequest: pendingRequest);
          },
        ),
      ),
    );
  }
}