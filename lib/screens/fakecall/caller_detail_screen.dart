import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/fakecall_controller.dart';
import 'package:sakhii/widgets/CustomFloatingActionButton.dart';

class CallerDetailScreen extends StatefulWidget {
  const CallerDetailScreen({Key? key}) : super(key: key);

  @override
  State<CallerDetailScreen> createState() => _CallerDetailScreenState();
}

class _CallerDetailScreenState extends State<CallerDetailScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String? selectedImage;

  @override
  void initState() {
    super.initState();
    FakeCallController fakeCallController = Get.find<FakeCallController>();
    nameController.text = fakeCallController.name.value;
    numberController.text = fakeCallController.number.value;
    selectedTime.value = fakeCallController.selectedTime.value;
  }

  final RxInt selectedTime = 5.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Caller Details",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "Specify time and caller details to schedule a fake call.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 30,
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  // Implement camera functionality
                },
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Set up a fake caller',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: numberController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Pre-set timer: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    value: selectedTime.value,
                    onChanged: (value) {
                      selectedTime.value = value!;
                      setState(() {});
                    },
                    items: [
                      const DropdownMenuItem<int>(
                        value: 1,
                        child: Text('1 sec'),
                      ),
                      const DropdownMenuItem<int>(
                        value: 5,
                        child: Text('5 sec'),
                      ),
                      const DropdownMenuItem<int>(
                        value: 30,
                        child: Text('30 sec'),
                      ),
                      const DropdownMenuItem<int>(
                        value: 60,
                        child: Text('60 sec'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      FakeCallController fakeCallController =
                      Get.find<FakeCallController>();
                      fakeCallController.saveCallerDetails(
                        nameController.text,
                        numberController.text,
                        selectedTime.value,
                        selectedImage,
                      );
                      Get.back();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
