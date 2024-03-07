import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/community_controller.dart';
import 'package:sakhii/screens/community/group_screen.dart';
import 'package:sakhii/widgets/GroupCard.dart';

class AllGroupsTab extends StatelessWidget {
  const AllGroupsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    Get.find<CommunityController>().resetFilters();

    return GetBuilder<CommunityController>(
      builder: (controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                controller.filterCommunities(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search by name/location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.allFilteredCommunities.length,
              itemBuilder: (context, index) {
                var community = controller.allFilteredCommunities[index];
                bool isJoined = controller.isUserJoined(community.id);
                return GroupCard(
                  groupName: community.name,
                  numberOfMembers: community.memberIds.length,
                  location: community.location,
                  onPressed: () async {
                    if(!isJoined){
                      await controller.joinCommunity(community.id);
                    }
                    Get.to(() => GroupScreen(community: community,));
                  },
                  isJoined: isJoined,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
