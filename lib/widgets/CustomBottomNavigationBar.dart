import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/community_controller.dart';
import 'package:sakhii/screens/community/community_screen.dart';
import 'package:sakhii/screens/fakecall/fakecall_screen.dart';
import 'package:sakhii/screens/helpline_screen.dart';
import 'package:sakhii/screens/home_screen.dart';
import 'package:sakhii/utils/theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomeScreen(),
          transitionDuration: Duration.zero,
        ));
        break;
      case 1:
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              HelpLineScreen(),
          transitionDuration: Duration.zero,
        ));
        break;
      case 2:
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
          const FakeCallScreen(),
          transitionDuration: Duration.zero,
        ));
        break;
      case 3:
        {
          Get.find<CommunityController>().fetchAllCommunities();
          Get.find<CommunityController>().fetchUserCommunities();
          Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
            const CommunityScreen(),
            transitionDuration: Duration.zero,
          ));
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Helpline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Fake Call',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Community',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: myTheme.primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }
}
