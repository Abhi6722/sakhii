import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/fakecall_controller.dart';
import 'package:sakhii/screens/fakecall/caller_detail_screen.dart';
import 'package:sakhii/screens/fakecall/incoming_screen.dart';
import 'package:sakhii/widgets/CustomAppBar.dart';
import 'package:sakhii/widgets/CustomBottomNavigationBar.dart';
import 'package:sakhii/widgets/CustomFloatingActionButton.dart';

class FakeCallScreen extends StatelessWidget {
  const FakeCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 2,),
      floatingActionButton: CustomFloatingActionButton(),
      body: GetBuilder<FakeCallController>(
        builder: (controller) => Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Text("Fake Call", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  Text("Place a fake call and pretend you are talking to someone", style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    CallerDetails(
                      name: controller.name.value,
                      number: controller.number.value,
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text("Note: Stay on the app screen to recieve a fake call."),
                        const SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: (){
                            // Get.to(()=>IncomingScreen());
                            print(controller.selectedTime.value);
                            Future.delayed(Duration(seconds: controller.selectedTime.value), () {
                              Get.to(() => IncomingScreen());
                            });
                            // _showFakeCallDialog(context);
                          },
                          child: Text("Get a call"),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CallerDetails extends StatelessWidget {
  final String name;
  final String number;
  const CallerDetails({super.key, required this.name, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Caller Details"),
              GestureDetector(
                onTap: (){
                  Get.to(()=> CallerDetailScreen());
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.edit),
                    ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              CircleAvatar(
                minRadius: 40.0,
                backgroundImage: AssetImage('assets/images/user-avatar.png'),
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 25),),
                  SizedBox(height: 5,),
                  Text(number, style: TextStyle(fontSize: 15, color: Colors.grey[600]),),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}