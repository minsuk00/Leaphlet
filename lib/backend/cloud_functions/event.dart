import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<String?> createNewEvent(
    String eventName, String startDate, String endDate) async {
  // TODO: create new event and return eventCode

  //return eventCode
  return null;
}