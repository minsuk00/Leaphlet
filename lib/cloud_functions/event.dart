import 'package:cloud_firestore/cloud_firestore.dart';

// fsGetEventName() async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   QuerySnapshot<Map<String, dynamic>> snapshot =
//       await firestore.collection("registered_event").get();
//   return snapshot.docs.map((e) => e.data()).toList();
// }

getEventNameByCode(String eventCode) async {
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
