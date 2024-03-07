import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/screens/menuscreens/menu_screen.dart';
import 'package:sakhii/utils/theme.dart';

import '../controllers/user_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Image.asset("assets/images/logo.png", height: 40,),
      actions: [
        Icon(Icons.notifications_on_outlined, color: myTheme.primaryColor,),
        const SizedBox(width: 20,),
        GestureDetector(
          onTap: (){
            Get.find<UserController>().getLoggedUser();
            Get.to(() => MenuScreen());
          },
            child: Icon(Icons.menu, color: myTheme.primaryColor,),
        ),
        const SizedBox(width: 10,),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
