import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/community_controller.dart';
import 'package:sakhii/screens/community/your_group_tab_screen.dart';
import 'package:sakhii/screens/community/all_group_tab_screen.dart';
import 'package:sakhii/utils/theme.dart';
import 'package:sakhii/widgets/CustomBottomNavigationBar.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Your Groups'),
              Tab(text: 'All Groups'),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 3),
        body: const TabBarView(
          children: [
            YourGroupsTab(),
            AllGroupsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: myTheme.primaryColor,
          onPressed: () {
            _showCreateGroupDialog(context);
          },
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateGroupDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController locationController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Group'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: myTheme.primaryColor),),
            ),
            TextButton(
              onPressed: () {
                Get.find<CommunityController>().createCommunity(
                  nameController.text,
                  descriptionController.text,
                  categoryController.text,
                  locationController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Create', style: TextStyle(color: myTheme.primaryColor),),
            ),
          ],
        );
      },
    );
  }
}
