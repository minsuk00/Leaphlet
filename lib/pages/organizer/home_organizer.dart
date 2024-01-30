import 'package:flutter/material.dart';
import 'package:test/pages/organizer/create_new_event.dart';
import 'package:test/pages/organizer/check_existing_events.dart';
import 'package:test/pages/organizer/inquiry.dart';
import 'package:test/util/navigate.dart';


class OrganizerHomePage extends StatefulWidget {
  const OrganizerHomePage({super.key});

  @override
  State<OrganizerHomePage> createState() => _OrganizerHomePageState();
}

class _OrganizerHomePageState extends State<OrganizerHomePage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text('Home (Organizer)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 0.7 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const CreateNewEventPage()),                
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text("Create New Event",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.05 * screenWidth,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenWidth * 0.03),

            SizedBox(
              width: 0.7 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const CheckExistingEventsPage()),               
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF04724D)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text("Check Existing Events",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.05 * screenWidth,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenWidth * 0.03),

            SizedBox(
              width: 0.7 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const InquiryPage()),                
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text("Inquiry",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.05 * screenWidth,
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
}