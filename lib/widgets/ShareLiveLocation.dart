import 'package:flutter/material.dart';
import 'package:sakhii/controllers/location_controller.dart';
import 'package:sakhii/models/User.dart';
import 'package:sakhii/utils/theme.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/friends_controller.dart';

class ShareLocationWidget extends StatefulWidget {
  const ShareLocationWidget({Key? key}) : super(key: key);

  @override
  ShareLocationWidgetState createState() => ShareLocationWidgetState();
}

class ShareLocationWidgetState extends State<ShareLocationWidget> {
  String _selectedDuration = '1 Hour';
  List<String> selectedFriendIds = [];
  final FriendsController friendsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Select friends & share your live location',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap to select',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'All Contacts',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          GetBuilder<FriendsController>(
            builder: (controller) => Wrap(
              children: controller.friends.map((friend) {
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  child: FriendAvatar(
                    friend: friend,
                    selectedFriendIds: selectedFriendIds,
                    onSelectionChanged: (ids) {
                      setState(() {
                        selectedFriendIds = ids;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Spacer(),
          const Text(
            'Live location duration',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                activeColor: myTheme.primaryColor,
                value: '1 Day',
                groupValue: _selectedDuration,
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value.toString();
                  });
                },
              ),
              const Text('1 Day'),
              Radio(
                activeColor: myTheme.primaryColor,
                value: '1 Hour',
                groupValue: _selectedDuration,
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value.toString();
                  });
                },
              ),
              const Text('1 Hour'),
              Radio(
                activeColor: myTheme.primaryColor,
                value: '8 Hour',
                groupValue: _selectedDuration,
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value.toString();
                  });
                },
              ),
              const Text('8 Hour'),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              Get.find<LocationController>().sendTrackMeRequest(selectedFriendIds, _selectedDuration);
              Get.find<FriendsController>().sendTrackMeMessage(selectedFriendIds, _selectedDuration);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Continue'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FriendAvatar extends StatefulWidget {
  final User friend;
  final List<String> selectedFriendIds;
  final Function(List<String>) onSelectionChanged;

  const FriendAvatar({
    Key? key,
    required this.friend,
    required this.selectedFriendIds,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  FriendAvatarState createState() => FriendAvatarState();
}

class FriendAvatarState extends State<FriendAvatar> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.selectedFriendIds.contains(widget.friend.id);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          if (_isSelected) {
            widget.selectedFriendIds.add(widget.friend.id);
          } else {
            widget.selectedFriendIds.remove(widget.friend.id);
          }
          widget.onSelectionChanged(widget.selectedFriendIds);
        });
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: Image.network(
                    widget.friend.image,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return CircleAvatar(
                        radius: 30,
                        child: Text(widget.friend.name[0]),
                      );
                    },
                  ),
                ),
              ),
              if (_isSelected)
                CircleAvatar(
                  radius: 12,
                  backgroundColor: myTheme.primaryColor,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5,),
          Text(widget.friend.name),
        ],
      ),
    );
  }
}
