import 'package:flutter/material.dart';
import 'package:test/pages/organizer/create_new_event.dart';
import 'package:test/pages/organizer/check_existing_events.dart';
import 'package:test/pages/organizer/inquiry.dart';

class OrganizerHomePage extends StatefulWidget {
  const OrganizerHomePage({super.key});

  @override
  State<OrganizerHomePage> createState() => _OrganizerHomePageState();
}

class _OrganizerHomePageState extends State<OrganizerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Home (Organizer)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => moveToPage(context, const CreateNewEventPage()),
              child: const Text("Create New Event"),
            ),
            OutlinedButton(
              onPressed: () => moveToPage(context, const CheckExistingEventsPage()),
              child: const Text("Check Existing Events"),
            ),
            OutlinedButton(
              onPressed: () => moveToPage(context, const InquiryPage()),
              child: const Text("Inquiry"),
            ),
          ],
        ),
      ),
    );
  }
}

void moveToPage(BuildContext context, StatefulWidget targetPage) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
}