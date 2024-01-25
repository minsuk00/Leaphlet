import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

getPamphletPdf(String boothCode) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
//   // String downloadUrl = await storage.ref('uploaded_pdfs/$fileId').getDownloadURL();
  try {
    // search document based on given eventcode
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("uploaded_pamphlets")
        .where('boothCode', isEqualTo: boothCode)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first.data();
      return {
          'pamphletURL': doc['pamphletURL'] as String?,
      };
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching event data: $e');
    return null;
  }
}

getBoothInfo(String boothCode) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // search document based on given eventcode
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("uploaded_pamphlets")
        .where('boothCode', isEqualTo: boothCode)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first.data();
      return {
          'eventCode': doc['eventCode'] as String?,
          'eventName': doc['eventName'] as String?,
          'boothNumber': doc['boothNumber'] as String?,
          'orgName': doc['orgName'] as String?,
          'yourName': doc['yourName'] as String?,
          'emailAddress': doc['emailAddressInput'] as String?,
          'phoneNumber': doc['phoneNumber'] as String?,
          'boothCode': doc['boothCode'] as String?,
          // 'pamphletURL': doc['pamphletURL'] as String?,
      };
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching event data: $e');
    return null;
  }
}

getAllBoothInfoForAnEvent(String eventCode) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // search document based on given eventcode
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("uploaded_pamphlets")
        .where('eventCode', isEqualTo: eventCode)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // add all boot information to list
      List<Map<String, dynamic>> boothsInfo = snapshot.docs.map((doc) => {
        'eventCode': doc['eventCode'] as String?,
        'eventName': doc['eventName'] as String?,
        'boothNumber': doc['boothNumber'] as String?,
        'orgName': doc['orgName'] as String?,
        'yourName': doc['yourName'] as String?,
        'emailAddress': doc['emailAddress'] as String?,
        'phoneNumber': doc['phoneNumber'] as String?,
        'boothCode': doc['boothCode'] as String?,
        // 'pamphletURL': doc['pamphletURL'] as String?,
      }).toList();

      return boothsInfo;
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching event data: $e');
    return null;
  }
}
