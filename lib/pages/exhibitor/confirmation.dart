import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test/backend/cloud_functions/pamphlets.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/pages/exhibitor/home_exhibitor.dart';
import 'package:test/util/navigate.dart';
import 'package:test/util/user_type.dart';
import 'package:test/backend/local_functions/util.dart' as util;

class ConfirmationPage extends StatefulWidget {
  final Map<String, String> boothInfo;
  final String filePath;
  const ConfirmationPage(
      {Key? key, required this.filePath, required this.boothInfo})
      : super(key: key);

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Confirmation"),
      ),
      body: Center(
        child: ElevatedButton(
          // style: ButtonStyle(backgroundColor: ),
          onPressed: () async {
            setState(() {
              isUploading = true;
            });
            widget.boothInfo['boothCode'] = generateBoothCode();
            uploadPamphlet(
              widget.filePath,
              widget.filePath.substring(widget.filePath.lastIndexOf("/") + 1),
              widget.boothInfo['eventCode']!,
              widget.boothInfo['boothNumber']!,
              widget.boothInfo['orgName']!,
              widget.boothInfo['name']!,
              widget.boothInfo['email']!,
              widget.boothInfo['phone']!,
              widget.boothInfo['boothCode']!,
            ).then((_) {
              if (mounted) {
                setState(() {
                  isUploading = false;
                });
              }
              saveToLocalFile(
                  widget.boothInfo, UserType.exhibitor, util.FileType.booth);
              moveToPage(context, const ExhibitorHomePage());
              print("======UPLOAD COMPLETE!======");
            }).catchError((_) {
              if (mounted) {
                setState(() {
                  isUploading = false;
                });
                print("======ERROR!! COULD NOT UPLOAD FILE TO FIREBASE!======");
              }
            });
          },
          child: isUploading
              ? const CircularProgressIndicator()
              : const Text('Upload'),
        ),
      ),
    );
  }
}

String generateBoothCode() {
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final Random rnd = Random();
  String code = '';
  for (int i = 0; i < 7; i++) {
    code += chars[rnd.nextInt(chars.length)];
  }
  return code;
}
