import 'package:flutter/material.dart';

class EventViewPage extends StatefulWidget {
  // const EventViewPage({super.key});
  const EventViewPage({Key? key, required this.eventCode}) : super(key: key);
  final String eventCode;

  @override
  State<EventViewPage> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  final TextStyle myTextStyle = const TextStyle(fontSize: 25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.eventCode),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Booth Number (Organization)",
              style: myTextStyle,
            ),
            Text(
              "Name: example name",
              style: myTextStyle,
            ),
            Text("Contact: example@gmail.com", style: myTextStyle),
            Text(
              "Phone number: (+81) 000-0000-0000",
              style: myTextStyle,
            ),
            Text(
              "PDF",
              style: myTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
