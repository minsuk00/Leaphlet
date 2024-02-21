import 'dart:convert';

import 'package:leaphlet/backend/local_functions/util.dart';
import 'package:leaphlet/util/user_type.dart';

// ignore: constant_identifier_names
const FILE_NAME_PREFIX = "local_event_info_";

// TODO: Check if already registered?
Future<void> saveEventToLocalFile(
    Map<String, dynamic> newEventObject, UserType userType) async {
  //assign file according to user type
  String userTypeString = userType.name;
  final fileName = "$FILE_NAME_PREFIX$userTypeString";

  //get file content
  final List<dynamic> eventList = await getLocalFileContent(fileName);

  //append new item to json list
  eventList.add(newEventObject);

  // print("########### WRITING TO FILE $eventList");
  //convert json to String and update file
  writeToLocalFile(fileName, jsonEncode(eventList));
}

Future<List<dynamic>> getEventListFromLocalFile(UserType userType) async {
  //assign file according to user type
  String userTypeString = userType.name;
  final fileName = "$FILE_NAME_PREFIX$userTypeString";
  return getLocalFileContent(fileName);
}

void resetLocalEventList(UserType userType) {
  String userTypeString = userType.name;
  final fileName = "$FILE_NAME_PREFIX$userTypeString";
  resetFile(fileName);
}
