import 'dart:convert';

import 'package:test/backend/local_functions/util.dart';
import 'package:test/util/user_type.dart';

// TODO: Check if already registered?
Future<void> saveEventToLocalFile(
    Map<String, dynamic> newEventObject, UserType userType) async {
  //assign file according to user type
  String userTypeString = userType.name;
  final fileName = "event_info_$userTypeString";

  //get file content
  final List<dynamic> eventList = await getLocalFileContent(fileName);

  //append new item to json list
  eventList.add(newEventObject);

  print("########### WRITING TO FILE $eventList");
  //convert json to String and update file
  writeToLocalFile(fileName, jsonEncode(eventList));
}

Future<List<dynamic>> getEventListFromLocalFile(UserType userType) async {
  //assign file according to user type
  String userTypeString = userType.name;
  final fileName = "event_info_$userTypeString";
  return getLocalFileContent(fileName);
}

void resetLocalEventList(UserType userType) {
  String userTypeString = userType.name;
  final fileName = "event_info_$userTypeString";
  resetFile(fileName);
}
