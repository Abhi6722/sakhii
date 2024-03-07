import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/community_controller.dart';
import 'package:sakhii/models/Community.dart';
import 'package:sakhii/utils/theme.dart';

class GroupScreen extends StatelessWidget {
  final Community community;

  const GroupScreen({Key? key, required this.community}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(community.name),
        actions: [
          MaterialButton(
            onPressed: () async {
              await Get.find<CommunityController>()
                  .leaveCommunity(community.id);
              Get.back();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(10),
                color: myTheme.primaryColorDark,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Leave Group",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ), // Rounded corners
              color: myTheme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(13),
            child: Column(
              children: [
                Text(
                  'About Group: ${community.description}',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Location: ${community.location}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Members: ${community.memberIds.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: community.posts.isEmpty
                ? const Center(
                    child: Text(
                      'No posts available',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: community.posts.length,
                    itemBuilder: (context, index) {
                      final post = community.posts[index];
                      return PostCard(
                        title: post.title,
                        location: post.location,
                        subtitle: post.description,
                        likes: post.likes,
                        comments: 4,
                        imageUrl: post.image,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showPostDialog(context, community.id);
              },
              child: const Text('Create Post'),
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String title;
  final String location;
  final String subtitle;
  final int likes;
  final int comments;
  final String imageUrl;

  const PostCard({
    Key? key,
    required this.title,
    required this.location,
    required this.subtitle,
    required this.likes,
    required this.comments,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                'U',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            subtitle: Text(
              location,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            trailing: const Icon(Icons.more_horiz),
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return SizedBox();
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 28,
                  color: Colors.black87,
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.chat_bubble_outline,
                  size: 28,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '$likes likes',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$comments comments',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Create Post
void _showPostDialog(BuildContext context, String communityId) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Create Post'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(titleController, 'Title'),
              const SizedBox(height: 8),
              _buildDescriptionField(descriptionController, 'Description'),
              const SizedBox(height: 8),
              _buildTextField(locationController, 'Location'),
              const SizedBox(height: 8),
              // _buildTypeDropdown(typeController),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: imageController,
                      decoration: const InputDecoration(
                        hintText: 'Image URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     // Implement image upload functionality
                  //   },
                  //   icon: const Icon(Icons.upload_file),
                  // ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String title = titleController.text;
              String description = descriptionController.text;
              String location = locationController.text;
              String type = typeController.text;
              String image = imageController.text;
              await Get.find<CommunityController>().createPost(title,description,location, image, communityId);
              Navigator.pop(context);
            },
            child: const Text('Post'),
          ),
        ],
      );
    },
  );
}

Widget _buildTextField(TextEditingController controller, String hintText) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}

Widget _buildDescriptionField(
    TextEditingController controller, String hintText) {
  return TextField(
    controller: controller,
    maxLines: 5,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}

Widget _buildTypeDropdown(TextEditingController controller) {
  return DropdownButtonFormField<String>(
    value: controller.text,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    items: <String>['Text', 'Image', 'Video', 'Link', 'Other']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value.toLowerCase(), // Ensure each value is unique
        child: Text(value),
      );
    }).toList(),
    onChanged: (String? newValue) {
      controller.text = newValue!;
    },
  );
}



