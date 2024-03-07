import 'package:get/get.dart';
import 'package:sakhii/controllers/community_controller.dart';
import 'package:sakhii/controllers/fakecall_controller.dart';
import 'package:sakhii/controllers/friends_controller.dart';
import 'package:sakhii/controllers/location_controller.dart';
import 'package:sakhii/controllers/user_controller.dart';
import 'auth_controller.dart';

class AllBinder extends Bindings{
  @override
  void dependencies(){
    Get.put(AuthController(), permanent: true);
    Get.put(UserController(), permanent: true);
    Get.put(CommunityController(), permanent: true);
    Get.put(FakeCallController(), permanent: true);
    Get.put(LocationController(), permanent: true);
    Get.put(FriendsController(), permanent: true);
  }
}