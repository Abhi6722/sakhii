import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/friends_controller.dart';
import 'package:sakhii/controllers/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakhii/models/User.dart';
import 'package:sakhii/utils/theme.dart';
import 'package:sakhii/widgets/CustomAppBar.dart';
import 'package:sakhii/widgets/CustomBottomNavigationBar.dart';
import 'package:sakhii/widgets/CustomFloatingActionButton.dart';
import 'package:sakhii/widgets/ShareLiveLocation.dart';
import 'package:sakhii/widgets/UserDetailsBottomSheet.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final LocationController locationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GetBuilder<LocationController>(
        builder: (locationController) {
          if (locationController.currentPosition.value != null) {
            return Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 170,
                  child: GoogleMap(
                    scrollGesturesEnabled: true,
                    compassEnabled: true,
                    mapToolbarEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(locationController.latitude.value, locationController.longitude.value),
                      zoom: 17.0,
                    ),
                    myLocationEnabled: true,
                    markers: Set<Marker>.from(locationController.userLocations.keys.map((userId) {
                      final user = locationController.userLocations[userId];
                      User friend = user['friend'];
                      return Marker(
                        markerId: MarkerId(userId),
                        position: LatLng(user['latitude'], user['longitude']),
                        infoWindow: InfoWindow(
                          title: friend.name,
                          onTap: (){
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return UserDetailsBottomSheet(user: friend, longitude: user['longitude'], latitude: user['latitude']);
                              },
                            );
                          }
                        ),
                      );
                    })),
                    // markers: {
                    //   Marker(
                    //     markerId: const MarkerId('Current Location'),
                    //     position: LatLng(locationController.latitude.value, locationController.longitude.value),
                    //   ),
                    // },
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 100),
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
                    child: MaterialButton(
                      onPressed: () async {
                        await Get.find<FriendsController>().getAllFriends();
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const ShareLocationWidget();
                          },
                        );
                      },
                      child: const Text(
                        "Track Me",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                if(locationController.userLocations.isNotEmpty)...[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 100,
                      child: locationController.userLocations.isNotEmpty
                          ? ListView(
                        scrollDirection: Axis.horizontal,
                        children: locationController.userLocations.keys.map((userId) {
                          final user = locationController.userLocations[userId];
                          User friend = user['friend'];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UserDetailsBottomSheet(user: friend,  longitude: user['longitude'], latitude: user['latitude']);
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
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
                                          return CircleAvatar(
                                            radius: 30,
                                            child: Text(friend.name[0]),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(friend.name),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                          : const SizedBox(),
                    ),
                  ),
                ]
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 0,
      ),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }
}