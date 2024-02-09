// import 'dart:convert';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
// import 'package:test/backend/local_functions/deprecated_event.dart';
import 'package:test/util/navigate.dart';
import 'package:test/backend/cloud_functions/event.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:test/util/user_type.dart';
import 'package:test/pages/common/info.dart';
import 'package:marquee/marquee.dart';

class RegisterNewEventPage extends StatefulWidget {
  const RegisterNewEventPage({super.key});

  @override
  State<RegisterNewEventPage> createState() => _RegisterNewEventPageState();
}

class _RegisterNewEventPageState extends State<RegisterNewEventPage> {
  final TextEditingController _eventCodeInputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Register New Event"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.3),
              child: TextFormField(
                controller: _eventCodeInputController,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  labelText: 'Event Code',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event code';
                  }
                  return null;
                },
              ),
            ),

            SizedBox(height: screenWidth * 0.02),
            
            ElevatedButton(
              onPressed: () => registerButtonPressed(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(vertical: 0.01 * screenHeight, horizontal: 0.05 * screenWidth),
                ),
                side: MaterialStateProperty.all<BorderSide>(
                  const BorderSide(color: Color(0xFF04724D)),
                ),
              ),
              child: const Text(
                "Register",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Marquee(
                  text: "Join the eco-friendly movement! 🌿 Let's cut down on paper waste together to protect our planet.",
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
              ElevatedButton(
                onPressed: () => moveToPage(context, const InfoPage()),
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
            ],
          ),
        ),
      ),
    );
  }

// void main() async {
//   String? eventName = await getEventNameByCode("KAHVXKT");
//   if (eventName != null) {
//     print("Event Name: $eventName");
//   } else {
//     print("Event not found or error occurred.");
//   }
// }
  Future<void> registerButtonPressed(BuildContext context) async {
    String eventCode = _eventCodeInputController.text;
    if (_formKey.currentState!.validate()) {
      var eventDetails = await getEventInfo(eventCode);
      bool isEventCodeValid =
          // eventCode == "logic";
          eventDetails != null; //TODO: check if event code is valid
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            if (isEventCodeValid) {
              // String? eventName = eventDetails['eventName'];
              // String? startDate = eventDetails['startDate'];
              // String? endDate = eventDetails['endDate'];
              //KAHVXKT
              // debugPrint('################${eventDetails.runtimeType}');
              return AlertDialog(
                title: const Text("success"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        // popNTimes(context, 2);
                        // Map<String, dynamic> newEvent = {
                        //   "event_name": eventName,
                        //   "start_date": startDate,
                        //   "end_date": endDate,
                        // };
                        saveToLocalFile(eventDetails, UserType.visitor,
                                FileType.event)
                            .then(
                                (value) => popToPage(context, "EventsPage"));
                      },
                      child: const Text("ok"))
                ],
              );
            } else {
              return AlertDialog(
                title: const Text("invalid event code"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        popOnce(context);
                      },
                      child: const Text("ok"))
                ],
              );
            }
          }
        );
      }
    }
  }

  // Future<void> saveRegisteredEvent(
  //     String fileName, Map<String, dynamic> newEvent) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/$fileName');

  //   if (!await file.exists()) {
  //     debugPrint("file not found");
  //     await file.writeAsString(jsonEncode({"events": []})); // 新しいファイルを初期化
  //   }

  //   String content = await file.readAsString();
  //   Map<String, dynamic> json = jsonDecode(content);

  //   // add events to events page
  //   if (json['events'] is List) {
  //     (json['events'] as List).add(newEvent);

  //     // 更新されたjsonを文字列に変換
  //     String updatedContent = jsonEncode(json);

  //     // 更新された内容をファイルに書き込む
  //     await file.writeAsString(updatedContent);
  //   }
  // }
}