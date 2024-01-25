import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

getEventInfo(String eventCode) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // search document based on given eventcode
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("registered_events")
        .where('eventCode', isEqualTo: eventCode)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first.data();
      return {
        'eventName': doc['eventName'] as String?,
        'startDate': doc['startDate'] as String?,
        'endDate': doc['endDate'] as String?
      };
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching event data: $e');
    return null;
  }
}

class GetEventListFromLocalFile {
  static Future<List> readJson() async {
    List eventData = [];
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/registered_events_by_visitors.json');

      if (!await file.exists()) {
        print("file not found");
        return eventData;
      }

      String content = await file.readAsString();
      final data = jsonDecode(content);
      eventData = data["events"] ?? [];
    } catch (e) {
      print("error occurred: $e");
    }
    return eventData;
  }
}