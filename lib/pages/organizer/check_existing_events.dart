import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:test/backend/local_functions/deprecated_event.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/util/user_type.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:test/cloud_functions/test_firestore.dart';

class CheckExistingEventsPage extends StatefulWidget {
  const CheckExistingEventsPage({super.key});

  @override
  State<CheckExistingEventsPage> createState() =>
      _CheckExistingEventsPageState();
}

class _CheckExistingEventsPageState extends State<CheckExistingEventsPage> {
  List _eventData = [];

  @override
  void initState() {
    super.initState();
    loadEventListFromFile();
  }

  void loadEventListFromFile() {
    getListFromLocalFile(UserType.organizer, FileType.event).then((value) {
      setState(() {
        _eventData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Existing Events"),
      ),
      body: Scrollbar(
        thickness: 15,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _eventData.length,
          itemBuilder: (context, index) {
            final String eventName = _eventData[index]['eventName'];
            final String eventCode = _eventData[index]['eventCode'];
            return Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 100),
              // child: ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10)),
              //   ),
              child: ListTile(
                title: Text(eventName),
                subtitle: Text(eventCode),
                tileColor: Colors.lightGreen,
                trailing: ElevatedButton(
                  child: const Text("Copy Event Code"),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: eventCode));
                  },
                ),
              ),
              // ),
            );
          }
        ),
      )
    );
  }
}
