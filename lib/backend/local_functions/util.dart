import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getLocalDirPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> getLocalFile(String fileName) async {
  final path = await getLocalDirPath();
  // print("##### DIRECTORY: $path");
  final File file = File('$path/$fileName');

  //If file doesn't exist, create and initialize it
  if (!file.existsSync()) {
    debugPrint(
        "##### $fileName not found. Creating and initializing new file...");

    final File file = await File('$path/$fileName').create(recursive: true);
    file.writeAsStringSync(jsonEncode([])); // 新しいファイルを初期化
  }

  return file;
}

Future<List<dynamic>> getLocalFileContent(String fileName) async {
  try {
    File localFile = await getLocalFile(fileName);
    final stringContent = await localFile.readAsString();
    return jsonDecode(stringContent);
  } catch (e) {
    debugPrint('##### Error occurred while loading local file. $e');
  }
  return [];
}

Future<void> writeToLocalFile(String fileName, String content) async {
  try {
    File targetFile = await getLocalFile(fileName);
    //If content is json format, encode before writing to the file
    // final stringContent = jsonEncode(jsonContent);
    // return targetFile.writeAsString(content,mode: FileMode.append);
    targetFile.writeAsStringSync(content);
  } catch (e) {
    debugPrint('##### Error ocurred while writing to local file. $e');
  }
}

Future<void> resetFile(String fileName) async {
  try {
    File targetFile = await getLocalFile(fileName);
    targetFile.writeAsStringSync(jsonEncode([])); // 新しいファイルを初期化
  } catch (e) {
    debugPrint('##### Could not reset file. $e');
  }
}

enum FileType { event, booth, pamphlet }
