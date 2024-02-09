import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Info"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Image.asset('assets/SDG12.png'),
                ),
                Expanded(
                  child: Image.asset('assets/SDG13.png'),
                ),
                Expanded(
                  child: Image.asset('assets/SDG15.png'),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.025),
            decoration: BoxDecoration(
              color: const Color(0xFF04724D),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Do you know how much paper is wasted at events? How many brochures printed for events go to waste, whether they are unused or discarded later?",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.024,
                fontFamily: 'Proxima Nova Bold',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Image.asset('assets/trees_calc.png'), // Replace with your image 4
          ),
          Expanded(
            child: Image.asset('assets/logo2.png'), // Replace with your image 5
          ),
        ],
      ),
    );
  }
}
