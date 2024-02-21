import 'dart:math';

import 'package:flutter/material.dart';
import 'package:leaphlet/backend/cloud_functions/pamphlets.dart';
import 'package:leaphlet/backend/local_functions/local_file_io.dart';
// import 'package:leaphlet/pages/exhibitor/home_exhibitor.dart';
import 'package:leaphlet/util/navigate.dart';
import 'package:leaphlet/util/user_type.dart';
import 'package:leaphlet/backend/local_functions/util.dart' as util;

class ConfirmationPage extends StatefulWidget {
  final Map<String, String> boothInfo;
  final String filePath;
  final String pamphletName;
  const ConfirmationPage({
    Key? key,
    required this.filePath,
    required this.boothInfo,
    required this.pamphletName,
  }) : super(key: key);

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void showSuccessDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Complete!'),
              // content: const Text('You must log in to use this feature.'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    popToPage(context, "ExhibitorHomePage");
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }

    void uploadButtonPressed() async {
      setState(() {
        isUploading = true;
      });
      widget.boothInfo['boothCode'] = generateBoothCode();
      uploadPamphlet(
        widget.filePath,
        widget.pamphletName,
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
        saveToLocalFile(widget.boothInfo, UserType.exhibitor, util.FileType.booth);
        showSuccessDialog();
        print("======UPLOAD COMPLETE!======");
      }).catchError((_) {
        if (mounted) {
          setState(() {
            isUploading = false;
          });
          print("======ERROR!! COULD NOT UPLOAD FILE TO FIREBASE!======");
        }
      });
    }

    SizedBox makeContentWidget(String category, String content) {
      TextEditingController controller = TextEditingController();
      controller.text = content == "" ? "-" : content;
      return SizedBox(
        width: 0.6 * screenWidth, // Adjust the width as needed
        child: Column(
          children: [
            TextField(
              controller: controller,
              // enabled: false,
              keyboardType: TextInputType.none,
              readOnly: true,
              autofocus: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
                labelText: category,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
          ],
        ),
      );
    }

    SizedBox getUploadButton() {
      return SizedBox(
        width: 0.3 * screenWidth,
        height: 0.05 * screenHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: uploadButtonPressed,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFF3E885E),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 0.003 * screenHeight, horizontal: 0.01 * screenWidth),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(color: Color(0xFF04724D)),
              ),
            ),
            child: Text(
              "Upload",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 0.04 * screenWidth,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Confirmation"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            makeContentWidget("Event Name", widget.boothInfo['eventName']!),
            makeContentWidget("Booth Number", widget.boothInfo['boothNumber']!),
            makeContentWidget("Organization Name", widget.boothInfo['orgName']!),
            makeContentWidget("Name", widget.boothInfo['name']!),
            makeContentWidget("Email", widget.boothInfo['email']!),
            makeContentWidget("Phone", widget.boothInfo['phone']!),
            makeContentWidget("pdf", widget.pamphletName),
            SizedBox(height: screenWidth * 0.02),
            isUploading ? const CircularProgressIndicator() : getUploadButton()
          ],
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
