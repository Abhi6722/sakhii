import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/user_controller.dart';
import 'package:sakhii/screens/menuscreens/profile_screen.dart';
import 'package:sakhii/utils/theme.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final UserController userController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    nameController.text = userController.user.name;
    genderController.text = userController.user.gender;
    ageController.text = userController.user.age.toString();
    selectedGender = userController.user.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: myTheme.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              color: myTheme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  width: double.infinity,
                  color: myTheme.scaffoldBackgroundColor,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/images/user-avatar.png'),
                            ),
                          ),
                          _buildTextField("Name", nameController),
                          _buildDropdownField("Gender", genderController),
                          _buildTextField("Age", ageController),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _saveDetails,
                              child: const Text('Save'),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        cursorColor: myTheme.primaryColor,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: myTheme.primaryColor),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myTheme.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: ['Male', 'Female', 'Other'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
        },
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: myTheme.primaryColor),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myTheme.primaryColor),
          ),
        ),
      ),
    );
  }

  void _saveDetails() async {
    if (nameController.text.isEmpty || ageController.text.isEmpty || selectedGender == null) {
      Get.snackbar('Failed to update user', "Please fill in all the details.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    await userController.updateUser(nameController.text, selectedGender!, int.parse(ageController.text));
    Get.off(
      ProfileScreen(),
      transition: Transition.fadeIn,
      duration: Duration.zero,
    );
  }
}
