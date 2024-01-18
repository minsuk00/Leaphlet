// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:test/backend/local_functions/util.dart';
import 'package:test/util/user_type.dart';

const FILE_NAME_PREFIX_EVENT = "local_event_info_";
const FILE_NAME_PREFIX_BOOTH = "local_booth_info_";

// TODO: Check if already registered?
Future<void> saveToLocalFile(Map<String, dynamic> newDataObject,
    UserType userType, FileType fileType) async {
  //assign file according to user type & file type
  String userTypeString = userType.name;
  String prefix = getFileNamePrefix(fileType);
  final fileName = "$prefix$userTypeString";

  //get file content
  final List<dynamic> list = await getLocalFileContent(fileName);

  //append new item to json list
  list.add(newDataObject);

  // print("########### WRITING TO FILE $list");
  //convert json to String and update file
  writeToLocalFile(fileName, jsonEncode(list));
}

Future<List<dynamic>> getListFromLocalFile(
    UserType userType, FileType fileType) async {
  //assign file according to user type
  String userTypeString = userType.name;
  String prefix = getFileNamePrefix(fileType);
  final fileName = "$prefix$userTypeString";
  return getLocalFileContent(fileName);
}

void resetLocalListFile(UserType userType, FileType fileType) {
  String userTypeString = userType.name;
  String prefix = getFileNamePrefix(fileType);
  final fileName = "$prefix$userTypeString";
  resetFile(fileName);
}

Future<void> deleteItemFromLocalFile(
    String targetItemCode, UserType userType, FileType fileType) async {
  String userTypeString = userType.name;
  String prefix = getFileNamePrefix(fileType);
  final fileName = "$prefix$userTypeString";

  //get file content
  List<dynamic> list = await getLocalFileContent(fileName);

  //delete target item from json list
  String targetCode = fileType == FileType.event ? "eventCode" : "boothCode";
  list =
      list.where((element) => element[targetCode] != targetItemCode).toList();
  // list.add(newDataObject);

  // print("########### WRITING TO FILE $list");
  //convert json to String and update file
  writeToLocalFile(fileName, jsonEncode(list));
}

String getFileNamePrefix(FileType fileType) {
  if (fileType == FileType.event) {
    return FILE_NAME_PREFIX_EVENT;
  } else if (fileType == FileType.booth) {
    return FILE_NAME_PREFIX_BOOTH;
  } else {
    Exception("Error. Check file name prefix");
    return "";
  }
}
