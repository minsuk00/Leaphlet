// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:test/backend/cloud_functions/event.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart' as util;
import 'package:test/pages/exhibitor/confirmation.dart';
import 'package:test/util/navigate.dart';
import 'package:test/backend/cloud_functions/pamphlets.dart';
import 'package:test/util/user_type.dart';

class UploadPamphletPage extends StatefulWidget {
  const UploadPamphletPage({super.key});

  @override
  State<UploadPamphletPage> createState() => _UploadPamphletPageState();
}

class _UploadPamphletPageState extends State<UploadPamphletPage> {
  TextEditingController eventCodeInput = TextEditingController();
  TextEditingController boothNumberInput = TextEditingController();
  TextEditingController orgNameInput = TextEditingController();
  TextEditingController yourNameInput = TextEditingController();
  TextEditingController emailAddressInput = TextEditingController();
  TextEditingController phoneNumberInput = TextEditingController();
  TextEditingController pamphletInput = TextEditingController();
  late String boothCode;
  late String eventName;
  late String _selectedFilePath = '';
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add a form key

  @override
  void initState() {
    boothCode = generateBoothCode();
    super.initState();
  }

  Widget buildPamphletUploadWidget(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        if (result != null) {
          String filePath = result.files.single.path!;
          setState(() {
            _selectedFilePath = filePath;
            pamphletInput.text =
                filePath.substring(filePath.lastIndexOf("/") + 1);
          });
          print('###### Selected file: $filePath');
          // if (kDebugMode) {
          //   print('Selected file: $filePath');
          // }
        }
      },
      child: Container(
        width: 0.6 * screenWidth,
        height: 0.12 * screenWidth,
        decoration: BoxDecoration(
          color: const Color(0xFFECE2D8),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          border: Border.all(color: Colors.grey),
        ),
        padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.015, horizontal: screenWidth * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.cloud_upload,
              color: const Color(0xFF766561),
              size: screenWidth * 0.05,
            ),
            SizedBox(width: screenWidth * 0.015),
            Expanded(
              child: Text(
                _selectedFilePath.isNotEmpty
                    ? pamphletInput.text
                    : 'Upload Pamphlet',
                style: TextStyle(
                  fontSize: screenWidth * 0.025,
                  fontFamily: 'Roboto',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the pop-up dialog
  void showEventCodeDialog(BuildContext context, eventInfo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (eventInfo == null) {
            return AlertDialog(
              title: const Text('EVENT CODE NOT FOUND'),
              //content: const Text('Your event code was not found.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          } else {
            eventName = eventInfo['eventName'];
            return AlertDialog(
              title: const Text('SUCCESS'),
              //content: const Text('Your event code was not found.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          }
        });

    // return AlertDialog(
    //   title: const Text('pending'),
    //   //content: const Text('Your event code was not found.'),
    //   actions: <Widget>[
    //     TextButton(
    //       onPressed: () {
    //         Navigator.of(context).pop(); // Close the dialog
    //       },
    //       child: const Text('Close'),
    //     ),
    //   ],
    // );
    // },
    // );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xFFC2D3CD),
        appBar: AppBar(
          backgroundColor: const Color(0xFFC2D3CD),
          leading: const BackButton(),
          title: const Text("Upload Pamphlet"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey, // Set the key to the form
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      SizedBox(height: screenWidth * 0.1),

                      SizedBox(
                        width: 0.6 * screenWidth,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: eventCodeInput,
                              autofocus: false,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                ),
                                labelText: 'Event Code',
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the event code';
                                }
                                return null;
                              },
                            ),
                            Positioned(
                              right: screenWidth * 0.02,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () async {
                                    final eventInfo =
                                        await getEventInfo(eventCodeInput.text);
                                    showEventCodeDialog(context, eventInfo);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF766561)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  child: const Text('Confirm Event'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.01),

                      SizedBox(
                        width: 0.6 * screenWidth,
                        child: TextFormField(
                          controller: boothNumberInput,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            labelText: 'Booth Number',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the booth number';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.01),

                      SizedBox(
                        width: 0.6 * screenWidth,
                        child: TextFormField(
                          controller: orgNameInput,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            labelText: 'Organization Name',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the organization name';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.01),

                      SizedBox(
                        width: 0.6 * screenWidth,
                        child: TextFormField(
                          controller: yourNameInput,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            labelText: 'Name',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.01),

                      SizedBox(
                        width: 0.6 * screenWidth, // Adjust the width as needed
                        child: TextFormField(
                          controller: emailAddressInput,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the email address';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.01),

                      SizedBox(
                        width: 0.6 * screenWidth, // Adjust the width as needed
                        child: TextField(
                          controller: phoneNumberInput,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            labelText: 'Phone (optional)',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.03),

                      // TextFormField(
                      //   readOnly: true,
                      //   controller: pamphletInput,
                      //   onTap: () async {
                      //     FilePickerResult? result =
                      //         await FilePicker.platform.pickFiles(
                      //       type: FileType.custom,
                      //       allowedExtensions: ['pdf'],
                      //     );
                      //     if (result != null) {
                      //       String filePath = result.files.single.path!;
                      //       _selectedFilePath = filePath;
                      //       pamphletInput.text = filePath.substring(filePath.lastIndexOf("/")+1);
                      //       if (kDebugMode) {
                      //         print('Selected file: $filePath');
                      //       }
                      //     }
                      //   },
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'Upload Pamphlet',
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please upload the pamphlet';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      buildPamphletUploadWidget(context),

                      SizedBox(height: screenWidth * 0.05),

                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await uploadPamphlet(
                                _selectedFilePath,
                                pamphletInput.text,
                                eventCodeInput.text,
                                boothNumberInput.text,
                                orgNameInput.text,
                                yourNameInput.text,
                                emailAddressInput.text,
                                phoneNumberInput.text,
                                boothCode);
                            if (mounted) {
                              final newBoothItem = {
                                "boothCode": boothCode,
                                "eventCode": eventCodeInput.text,
                                "eventName": eventName,
                                "boothNumber": boothNumberInput.text,
                                "orgName": orgNameInput.text,
                                "name": yourNameInput.text,
                                "email": emailAddressInput.text,
                                "phone": phoneNumberInput.text,
                              };
                              saveToLocalFile(newBoothItem, UserType.exhibitor,
                                  util.FileType.booth);
                              moveToPage(
                                  context,
                                  ConfirmationPage(
                                    boothInfo: newBoothItem,
                                  ));
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF3E885E)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                vertical: 0.01 * screenHeight,
                                horizontal: 0.06 * screenWidth),
                          ),
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Color(0xFF04724D)),
                          ),
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 0.04 * screenWidth,
                          ),
                        ),
                      ),
                    ])))));
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
}
