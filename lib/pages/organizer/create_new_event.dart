import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaphlet/util/navigate.dart';
import 'package:leaphlet/backend/cloud_functions/event.dart';

class CreateNewEventPage extends StatefulWidget {
  const CreateNewEventPage({super.key});

  @override
  State<CreateNewEventPage> createState() => _CreateNewEventPageState();
}

class _CreateNewEventPageState extends State<CreateNewEventPage> {
  TextEditingController startDateInput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  TextEditingController eventNameInput = TextEditingController();
  late final String eventCode; // Variable to store the generated event code
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final FirebaseFirestore _firestore =
  //     FirebaseFirestore.instance; // Add a form key

  @override
  void initState() {
    startDateInput.text = "";
    endDateInput.text = "";
    eventCode = generateEventCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingValue = screenWidth * 0.2;
    return Scaffold(
        backgroundColor: const Color(0xFFC2D3CD),
        appBar: AppBar(
          backgroundColor: const Color(0xFFC2D3CD),
          leading: const BackButton(),
          title: const Text("Create New Event"),
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(paddingValue),
                    child: Form(
                        key: _formKey, // Set the key to the form
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          TextFormField(
                            controller: eventNameInput,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              ),
                              labelText: 'Event Name',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an event name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          TextFormField(
                            controller: startDateInput,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              ),
                              icon: const Icon(Icons.calendar_today),
                              labelText: "Start Date",
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                                if (endDateInput.text.isNotEmpty && pickedDate.isAfter(DateTime.parse(endDateInput.text))) {
                                  // Selected start date is after the end date
                                  // Show error message
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Start date should be before end date!"),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    startDateInput.text = formattedDate;
                                  });
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a start date';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          TextFormField(
                            controller: endDateInput,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              ),
                              icon: const Icon(Icons.calendar_today),
                              labelText: "End Date",
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                                if (startDateInput.text.isNotEmpty && pickedDate.isBefore(DateTime.parse(startDateInput.text))) {
                                  // Selected end date is before the start date
                                  // Show error message
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("End date should be after start date!"),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    endDateInput.text = formattedDate;
                                  });
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an end date';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          SizedBox(
                            width: 0.3 * screenWidth,
                            height: 0.05 * screenHeight,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await createNewEvent(eventNameInput.text, startDateInput.text, endDateInput.text, eventCode);
                                    if (mounted) {
                                      showEventCodeDialog(context);
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                                  elevation: MaterialStateProperty.all<double>(0), // Set elevation to 0 because it's handled by BoxDecoration
                                  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent), // Set shadow color to transparent
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Submit Event',
                                    style: TextStyle(
                                      fontSize: 0.03 * screenWidth, // Adjust the font size as desired
                                      color: Colors.white, // Set the text color to white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]))))));
  }

  // Future<void> saveEventData() async {
  //   try {
  //     Map<String, String> newEventData = {
  //       'eventName': eventNameInput.text,
  //       'startDate': startDateInput.text,
  //       'endDate': endDateInput.text,
  //       'eventCode': eventCode,
  //     };
  //     // Firestoreにイベントデータを保存
  //     await _firestore.collection("registered_events").add(newEventData);
  //     saveToLocalFile(newEventData, UserType.organizer, FileType.event);
  //     // 保存後の処理（例：メッセージ表示、画面遷移など）をここに記述
  //   } catch (e) {
  //     // エラーハンドリング
  //     debugPrint('Error saving event data: $e');
  //   }
  // }

  void showEventCodeDialog(BuildContext context) {
    // Show the event code in a pop-up message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Event Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your event code is: $eventCode'),
              ElevatedButton(
                onPressed: () {
                  copyToClipboard(eventCode);
                  // popToPage(context, "OrganizerHomePage");
                  popNTimes(context, 2);
                },
                child: const Text('Copy'),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          actions: [
            TextButton(
              onPressed: () {
                // popToPage(context, "OrganizerHomePage");
                popNTimes(context, 2);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  String generateEventCode() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random rnd = Random();
    String code = '';
    for (int i = 0; i < 7; i++) {
      code += chars[rnd.nextInt(chars.length)];
    }
    return code;
  }
}
