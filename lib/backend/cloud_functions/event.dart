import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaphlet/backend/local_functions/local_file_io.dart';
import 'package:leaphlet/backend/local_functions/util.dart';
import 'package:leaphlet/util/user_type.dart';

Future<Map<String, String?>?> getEventInfo(String eventCode) async {
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
        'endDate': doc['endDate'] as String?,
        'eventCode': eventCode,
      };
    } else {
      return null;
    }
  } catch (e) {
    log('Error fetching event data: $e');
    return null;
  }
}

createNewEvent(
    String eventName, String startDate, String endDate, String eventCode) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    print('$eventName, $startDate, $endDate, $eventCode');
    Map<String, String> newEventData = {
      'eventName': eventName,
      'startDate': startDate,
      'endDate': endDate,
      'eventCode': eventCode,   
    };
    await firestore.collection("registered_events").add(newEventData);
    saveToLocalFile(newEventData, UserType.organizer, FileType.event);
    print('#####Event informatin Uploaded');
  } catch (e) {
    print('#####Error. Failed to upload: $e');
  }
}
