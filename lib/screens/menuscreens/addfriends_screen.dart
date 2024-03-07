import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/friends_controller.dart';
import 'package:sakhii/utils/theme.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  AddFriendScreenState createState() => AddFriendScreenState();
}

class AddFriendScreenState extends State<AddFriendScreen> {
  bool makeSOSContact = false;
  String buttonText = 'Add Friend';
  String countryCode = '+91';
  List<String> countryCodeOptions = ['+1', '+44', '+91', '+61'];
  TextEditingController mobileNumberController = TextEditingController();
  bool isEmpty = true;

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Image.asset(
          "assets/images/logo_dark.png",
          height: 50,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Add Friend",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            Center(
                child:
                    Icon(Icons.group, size: 100, color: myTheme.primaryColor)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: DropdownButton<String>(
                      items: countryCodeOptions.map((String countryCode) {
                        return DropdownMenuItem<String>(
                          value: countryCode,
                          child: Text(countryCode),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            countryCode = value;
                          }
                        });
                      },
                      value: countryCode,
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            isEmpty = value.isEmpty;
                          });
                        },
                        controller: mobileNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: const InputDecoration(
                          hintText: 'Mobile Number',
                          border: InputBorder.none,
                        ),
                        cursorColor: myTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  activeColor: myTheme.primaryColor,
                  value: makeSOSContact,
                  onChanged: (value) {
                    setState(() {
                      makeSOSContact = value ?? false;
                      buttonText =
                          makeSOSContact ? 'Add SOS Contact' : 'Add Friend';
                    });
                  },
                ),
                const SizedBox(width: 5),
                const Text('Make this person my SOS contact'),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: myTheme.primaryColor),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.group,
                        color: myTheme.primaryColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Friend',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                      'You can share your live location with your friends using the track me feature.'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.emergency_share,
                        color: myTheme.primaryColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'SOS Contacts',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                      'You can send sos alerts only to the sos contacts during an emergency'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: isEmpty
                    ? null
                    : () {
                          var mobile = "$countryCode${mobileNumberController.text}";
                          debugPrint(mobile);
                          Get.find<FriendsController>().addFriendByMobile(mobile);
                          Get.back();
                      },
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
