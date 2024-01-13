import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test/util/navigate.dart';
import 'package:test/backend/cloud_functions/event.dart';
import 'package:path_provider/path_provider.dart';

class RegisterNewEventPage extends StatefulWidget {
  const RegisterNewEventPage({super.key});

  @override
  State<RegisterNewEventPage> createState() => _RegisterNewEventPageState();
}

class _RegisterNewEventPageState extends State<RegisterNewEventPage> {
  final TextEditingController _eventCodeInputController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Register New Event"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 300),
              child: TextFormField(
                controller: _eventCodeInputController,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Event Code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event code';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => registerButtonPressed(context),
              child: const Text('Register'),
            )
          ],
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
    var eventDetails = await getEventNameByCode(eventCode); 
    bool isEventCodeValid =
        // eventCode == "logic"; 
        eventDetails != null; //TODO: check if event code is valid
    if (_formKey.currentState!.validate()) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            if (isEventCodeValid) {
              String? eventName = eventDetails['eventName'];
              String? startDate = eventDetails['startDate'];
              String? endDate = eventDetails['endDate'];
              return AlertDialog(
                title: const Text("success"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        // popNTimes(context, 2);
                        Map<String, dynamic> newEvent = {
                          "event_name": eventName,
                          "start_date": startDate,
                          "end_date": endDate,
                        };
                        saveRegisteredEvent("save_registered_event_by_visitors.json", newEvent);
                        popToPage(context, "EventsPage");
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
                        Navigator.pop(context);
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
  Future<void> saveRegisteredEvent(String fileName, Map<String, dynamic> newEvent) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    if (!await file.exists()) {
      print("file not found");
      await file.writeAsString(jsonEncode({"events": []})); // 新しいファイルを初期化
    }

    String content = await file.readAsString();
    Map<String, dynamic> json = jsonDecode(content);

    // add events to events page
    if (json['events'] is List) {
      (json['events'] as List).add(newEvent);

      // 更新されたjsonを文字列に変換
      String updatedContent = jsonEncode(json);

      // 更新された内容をファイルに書き込む
      await file.writeAsString(updatedContent);
    }
  }
}
