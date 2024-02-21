import 'dart:math';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:leaphlet/pages/common/info.dart';
import 'package:leaphlet/util/navigate.dart';

class AdBar extends StatefulWidget {
  final Function() onUpdate;

  const AdBar({Key? key, required this.onUpdate}) : super(key: key);

  @override
  AdBarState createState() => AdBarState();
}

class AdBarState extends State<AdBar> {
  final List<String> messages = [
    // 0
    "Join the eco-friendly movement! Let's cut down on paper waste together to protect our planet. 🌿 ",
    // 1
    "Rethink your approach to information. Embrace digital pamphlets and help create a cleaner, greener future. 🌿 ",
    // 2
    "Did you know that recycling one ton of paper saves 17 trees? Choose digital and make a real impact. 🌳 ",
    // 3
    "Every sheet counts! Opt for digital pamphlets and help reduce the 400 million tons of paper produced globally each year. 🌳 ",
    // 4
    "Did you know that more than 2 tons of paper are wasted at every event? Stop hurting the Earth! 🌍 ",
    // 5
    "Make a difference with every tap. Choose digital over paper for a greener tomorrow. 🌍 ",
    // 6
    "Be the change you want to see in the world. Say no to paper waste and yes to sustainability. 💚 ",
    // 7
    "Save more than just paper. By going digital, you're also saving water, energy, and reducing pollution. 💚 ",
    // 8
    "Small changes lead to big impacts. Switch to digital pamphlets and be a part of the solution. 📱 ",
  ];

  late String randomMessage;

  @override
  void initState() {
    super.initState();
    _generateRandomMessage();
  }

  void _generateRandomMessage() {
    if (messages.isEmpty) {
      setState(() {
        randomMessage = '';
      });
      return;
    }

    final Random random = Random();
    final int randomIndex = random.nextInt(messages.length);
    print(randomIndex); // Print the random index generated
    setState(() {
      randomMessage = messages[randomIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Marquee(
                text: randomMessage,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 20.0,
                velocity: 100.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  moveToPage(context, const InfoPage());
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF766561)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  ),
                ),
                child: const Text("VIEW MORE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
