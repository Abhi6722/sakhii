import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/fakecall_controller.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FakeCallController>(
        builder: (controller) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        minRadius: 80,
                        backgroundImage: AssetImage('assets/images/user-avatar.png'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        controller.name.value,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        controller.number.value,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.call_end),
                        color: Colors.red,
                        iconSize: 40,
                      ),
                      IconButton(
                        onPressed: () {
                          // Accept call functionality
                        },
                        icon: Icon(Icons.call),
                        color: Colors.green,
                        iconSize: 40,
                      ),
                      IconButton(
                        onPressed: () {
                          // Speaker or other option functionality
                        },
                        icon: Icon(Icons.volume_up),
                        color: Colors.black,
                        iconSize: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
