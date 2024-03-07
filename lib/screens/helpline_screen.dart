import 'package:flutter/material.dart';
import 'package:sakhii/models/HelplineData.dart';
import 'package:sakhii/widgets/CustomAppBar.dart';
import 'package:sakhii/widgets/CustomBottomNavigationBar.dart';
import 'package:sakhii/widgets/CustomFloatingActionButton.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpLineScreen extends StatelessWidget {
  HelpLineScreen({super.key});

  final List<HelplineData> helplineData = [
    HelplineData(
      imageUrl: 'assets/images/helpline/national-helpline.png',
      phoneNumber: '112',
      description: 'National Helpline',
      color: Colors.green,
    ),
    HelplineData(
      imageUrl: 'assets/images/helpline/ambulance.png',
      phoneNumber: '108',
      description: 'Ambulance',
      color: Colors.blue,
    ),
    HelplineData(
      imageUrl: 'assets/images/helpline/pregnancy-medic.png',
      phoneNumber: '102',
      description: 'Pregnancy Medic',
      color: Colors.pink,
    ),
    HelplineData(
      imageUrl: 'assets/images/helpline/fire-service.png',
      phoneNumber: '101',
      description: 'Fire Service',
      color: Colors.orangeAccent,
    ),
    HelplineData(
      imageUrl: 'assets/images/helpline/police.png',
      phoneNumber: '100',
      description: 'Police',
      color: Colors.purpleAccent,
    ),
    HelplineData(
      imageUrl: 'assets/images/helpline/women-helpline.png',
      phoneNumber: '1091',
      description: 'Women Helpline',
      color: Colors.orangeAccent,
    ),
    HelplineData(
      imageUrl: 'assets/images/helpline/child-helpline.png',
      phoneNumber: '1098',
      description: 'Child Helpline',
      color: Colors.indigo,
    ),
    HelplineData(
      imageUrl: 'assets/images/helpline/road-accident.png',
      phoneNumber: '1073',
      description: 'Road Accident',
      color: Colors.redAccent,
    ),
    HelplineData(
      imageUrl: 'assets/images/helpline/railway-protection.png',
      phoneNumber: '183',
      description: 'Railway Protection',
      color: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: helplineData.map((data) {
              return CustomCallCard(
                imageUrl: data.imageUrl,
                phoneNumber: data.phoneNumber,
                description: data.description,
                color: data.color,
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }
}

class CustomCallCard extends StatelessWidget {
  final String imageUrl;
  final String phoneNumber;
  final String description;
  final Color color;

  const CustomCallCard({
    required this.imageUrl,
    required this.phoneNumber,
    required this.description,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    imageUrl,
                    height: 50,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phoneNumber,
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  final Uri phoneUri = Uri(
                      scheme: "tel",
                      path: phoneNumber
                  );
                  launchUrl(phoneUri);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.call),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}