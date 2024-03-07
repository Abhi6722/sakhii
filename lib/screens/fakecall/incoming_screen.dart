import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/fakecall_controller.dart';
import 'package:sakhii/screens/fakecall/calling_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class IncomingScreen extends StatefulWidget {
  const IncomingScreen({super.key});

  @override
  IncomingScreenState createState() => IncomingScreenState();
}

class IncomingScreenState extends State<IncomingScreen> {
  late AudioPlayer _audioPlayer = AudioPlayer();

  @override
  initState() {
    super.initState();
    _playRingtone();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  _playRingtone() async {
    try {
      AudioCache.instance = AudioCache(prefix: '');
      _audioPlayer = AudioPlayer();
      await _audioPlayer.play(AssetSource('assets/audio/ringtone.mp3'));
    } catch (e) {
      debugPrint('Error playing ringtone: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FakeCallController>(
        builder: (controller) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                CircleAvatar(
                  minRadius: 80,
                  backgroundImage: AssetImage(controller.selectedImage.value),
                ),
                const SizedBox(height: 20),
                Text(
                  controller.name.value,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  controller.number.value,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Calling...',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PulsatingButton(
                      onPressed: () {
                        _audioPlayer.stop();
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.red,
                      icon: const Icon(Icons.call_end),
                    ),
                    PulsatingButton(
                      onPressed: () {
                        _audioPlayer.stop();
                        Get.to(() => const CallingScreen());
                      },
                      backgroundColor: Colors.green,
                      icon: const Icon(Icons.call),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PulsatingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Widget icon;

  const PulsatingButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  PulsatingButtonState createState() => PulsatingButtonState();
}

class PulsatingButtonState extends State<PulsatingButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(_animationController),
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        backgroundColor: widget.backgroundColor,
        child: widget.icon,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
