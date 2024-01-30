import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:test/backend/cloud_functions/event.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/util/user_type.dart';

uploadPamphlet(
    String filePath,
    String fileName,
    String eventCode,
    String boothNumber,
    String orgName,
    String yourName,
    String emailAddress,
    String phoneNumber,
    String boothCode) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  File file = File(filePath);
  try {
    await storage.ref('uploaded_pdfs/$fileName').putFile(file);
    print('###################  Upload PDF to Firebase Storage!');
    // upload pdf to Firebase Storage
    // TaskSnapshot snapshot =
        // await storage.ref('uploaded_pdfs/$fileName').putFile(file);
    // get URL
    // String fileUrl = await snapshot.ref.getDownloadURL();
    // Use relative path directly
    String fileUrl = 'uploaded_pdfs/$fileName';

    // save pamphlet information to Firestore
    var eventDetails = await getEventInfo(eventCode);
    bool isEventCodeValid = eventDetails != null;
    if (isEventCodeValid) {
      String? eventName = eventDetails['eventName'];
      print('################### Get Event Details!');
      await firestore.collection("uploaded_pamphlets").add({
        'eventCode': eventCode,
        'eventName': eventName,
        'boothNumber': boothNumber,
        'orgName': orgName,
        'yourName': yourName,
        'emailAddress': emailAddress,
        'phoneNumber': phoneNumber,
        'boothCode': boothCode,
        'pamphletURL': fileUrl,
      });
    }
    print('File Uploaded');
  } catch (e) {
    print('Error. Failed to upload: $e');
  }
}

Future<Map<String, String>?> getBoothInfo(String boothCode) async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    // search document based on given eventcode
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("uploaded_pamphlets")
        .where('boothCode', isEqualTo: boothCode)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first.data();
      return {
        'eventCode': doc['eventCode'] as String,
        'eventName': doc['eventName'] as String,
        'boothNumber': doc['boothNumber'] as String,
        'orgName': doc['orgName'] as String,
        'yourName': doc['yourName'] as String,
        'emailAddress': doc['emailAddress'] as String,
        'phoneNumber': doc['phoneNumber'] as String,
        'boothCode': doc['boothCode'] as String,
        'pamphletURL': doc['pamphletURL'] as String,
      };
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching event data: $e');
    return null;
  }
}

// ======== Changed getPamphletPdf function to get actual pdf not just url
// getPamphletPdf(String boothCode) async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
// //   // String downloadUrl = await storage.ref('uploaded_pdfs/$fileId').getDownloadURL();
//   try {
//     // search document based on given eventcode
//     QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
//         .collection("uploaded_pamphlets")
//         .where('boothCode', isEqualTo: boothCode)
//         .get();

//     if (snapshot.docs.isNotEmpty) {
//       var doc = snapshot.docs.first.data();
//       return {
//           'pamphletURL': doc['pamphletURL'] as String?,
//       };
//     } else {
//       return null;
//     }
//   } catch (e) {
//     print('Error fetching event data: $e');
//     return null;
//   }
// }

// returns local path to downloaded pdf
Future<String?> getPamphletPdf(String url) async {
  try {
    final String localPath;
    List<dynamic> localPamphletList =
        await getListFromLocalFile(UserType.all, FileType.pamphlet);
    Iterable<dynamic> localCache =
        localPamphletList.where((element) => element.url == url);

    if (localCache.isNotEmpty) {
      //get from local cache if already cached
      localPath = localCache.first.localPath;
      print('################### PDF found from local cache');
      print('###################$localPath');
    } else {
      //download from firebase if not cached
      print('################### Downloading Pdf from Firebase Storage...');
      final ref = FirebaseStorage.instance.ref().child(url);
      final bytes = await ref.getData();
      print('################### Download Complete!');

      //cache locally
      // final file = await getLocalFile('$url.pdf');
      final file = await getLocalFile(url);
      await file.writeAsBytes(bytes!, flush: true);
      localPath = file.path;

      print('################### Saving Pdf to local cache');
      Map<String, String> newCacheObject = {"url": url, "localPath": localPath};
      saveToLocalFile(newCacheObject, UserType.all, FileType.pamphlet);
    }
    return localPath;
  } catch (e) {
    print('error: $e');
  }
  return null;
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
      List<Map<String, dynamic>> boothsInfo = snapshot.docs
          .map((doc) => {
                'eventCode': doc['eventCode'] as String?,
                'eventName': doc['eventName'] as String?,
                'boothNumber': doc['boothNumber'] as String?,
                'orgName': doc['orgName'] as String?,
                'yourName': doc['yourName'] as String?,
                'emailAddress': doc['emailAddress'] as String?,
                'phoneNumber': doc['phoneNumber'] as String?,
                'boothCode': doc['boothCode'] as String?,
                // 'pamphletURL': doc['pamphletURL'] as String?,
              })
          .toList();

      return boothsInfo;
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching event data: $e');
    return null;
  }
}
