import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/common/ad_bar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:test/backend/cloud_functions/pamphlets.dart';
// import 'package:test/backend/cloud_functions/pamphlets.dart'; // このパスは適宜修正してください。
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:test/pages/visitor/pdf_view.dart';
// import 'package:test/util/logging.dart';
// import 'dart:io';
import 'package:test/util/user_type.dart';

import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class FileInformationPage extends StatefulWidget {
  // const FileInformationPage({Key? key, required this.orgName, required this.boothNumber, required this.yourName, required this.emailAddress, required this.phoneNumber, required this.boothCode}) : super(key: key);
  // final String orgName;
  // final String boothNumber;
  // final String yourName;
  // final String emailAddress;
  // final String phoneNumber;
  // final String boothCode;
  final Map<String, dynamic> fileInfo;
  const FileInformationPage({Key? key, required this.fileInfo}) : super(key: key);

  @override
  State<FileInformationPage> createState() => _FileInformationPageState();
}

class _FileInformationPageState extends State<FileInformationPage> {
  final TextStyle myTextStyle = const TextStyle(fontSize: 25);
  // String? localPath;
  Map<String, dynamic> boothInfo = {};
  bool isSaved = false;
  List<dynamic> _savedBoothsList = [];
  double? _progress;

  @override
  void initState() {
    super.initState();
    boothInfo = widget.fileInfo;
    loadData();
  }

  void loadData() async {
    // var pdfData = await getPamphletPdf(widget.boothCode);
    // if (pdfData != null && pdfData.isNotEmpty) {
    //   downloadFile(pdfData["pamphletURL"]);
    // }
    // downloadFile(widget.fileInfo['pamphletURL']!);

    // getBoothInfo(widget.fileInfo['boothCode']!).then((value) {
    //   setState(() {
    //     // print("###################### $value");
    //     boothInfo = value!;
    //   });
    //   print("boothinfo: $boothInfo");
    //   print("fileinfo ${widget.fileInfo}");
    // });

    _savedBoothsList = await getListFromLocalFile(UserType.visitor, FileType.booth);
    for (var savedBooth in _savedBoothsList) {
      if (savedBooth['boothCode'] == boothInfo['boothCode']) {
        setState(() {
          isSaved = true;
        });
        break;
      }
    }

    // pprint(_savedBoothsList);
    // print(_savedBoothsList);
  }

  toggleIsSaved() {
    setState(() {
      if (isSaved) {
        isSaved = false;
        deleteItemFromLocalFile(boothInfo['boothCode']!, UserType.visitor, FileType.booth);
      } else {
        isSaved = true;
        saveToLocalFile(boothInfo, UserType.visitor, FileType.booth);
      }
    });
  }

  ElevatedButton getStarWidget() {
    return ElevatedButton(
      onPressed: toggleIsSaved,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF04724D)),
        iconColor: MaterialStateProperty.all<Color>(Colors.yellow),
      ),
      child: Icon(isSaved ? Icons.star : Icons.star_border),
    );
  }

  Future<String> getPdfDownloadURL(String filename) async {
    final storageRef = FirebaseStorage.instance.ref();
    String url = await storageRef.child(filename).getDownloadURL();
    return url;
  }

  // Future<void> downloadFile(String url) async {
  //   try {
  //     final ref = FirebaseStorage.instance.ref().child(url);
  //     final bytes = await ref.getData();

  //     final dir = await getApplicationDocumentsDirectory();
  //     final file = File('${dir.path}/${widget.fileInfo['boothCode']}.pdf');

  //     await file.writeAsBytes(bytes!, flush: true);

  //     setState(() {
  //       localPath = file.path;
  //     });
  //   } catch (e) {
  //     print('error: $e');
  //   }
  // }

  Future download(String url, String filename) async {
    void showDownloadProgress(received, total) {
      if (total != -1) {
        debugPrint((received / total * 100).toStringAsFixed(0) + '%');
      }
    }

    var savePath = '/storage/emulated/0/Download/$filename';
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      // var status = await Permission.manageExternalStorage.status;
      // if (!status.isGranted) {
      //   print("#### PERMISSION NOT GRANTED YET. WAITING FOR PERMISSION...");
      //   print(await Permission.manageExternalStorage.request());
      //   print(await openAppSettings());
      // } else {
      //   print("#### PERMISSION GRANTED : $status");
      // }

      if (await Permission.manageExternalStorage.request().isGranted) {
        var response = await dio.get(
          url,
          onReceiveProgress: showDownloadProgress,
          //Received data with List<int>
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: Duration.zero,
          ),
        );

        var file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        raf.writeFromSync(response.data);
        await raf.close();
      } else {
        print("###ERROR... PERMISSION NOT GRANTED");
      }
    } catch (e) {
      debugPrint("ERROR: ${e.toString()}");
    }
  }

  download1(String url, String pdfName) async {
    // getPamphletPdf(boothInfo['pamphletURL']!);
    FileDownloader.downloadFile(
      name: pdfName,
      url: url,
      onProgress: (name, progress) {
        // print("name: $name");
        setState(() {
          _progress = progress;
        });
      },
      onDownloadCompleted: (value) {
        print('path  $value ');
        setState(() {
          _progress = null;
        });
      },
      notificationType: NotificationType.all,
      // headers: {"Content-Type": "application/pdf"},
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String? pdfName = boothInfo['pamphletURL']?.substring(14);
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: Text("${boothInfo['orgName']} (${boothInfo['boothNumber']})"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: screenWidth * 0.04),

            Center(
              child: SizedBox(
                width: 0.8 * screenWidth,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EED4),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Booth Number: ${boothInfo['boothNumber']}",
                        style: TextStyle(color: const Color(0xFF04724D), fontSize: screenWidth * 0.05),
                      ),
                      getStarWidget(),
                    ],
                  ),
                ),
              ),
            ),

            //SizedBox(height: screenWidth * 0.005),

            Center(
              child: SizedBox(
                width: 0.8 * screenWidth,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EED4),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Organization: ${boothInfo['orgName']}",
                        style: TextStyle(color: const Color(0xFF04724D), fontSize: screenWidth * 0.05),
                      ),
                      Text(
                        "Name: ${boothInfo['yourName']}",
                        style: TextStyle(color: const Color(0xFF04724D), fontSize: screenWidth * 0.05),
                      ),
                      Text(
                        "Email: ${boothInfo['emailAddress']}",
                        style: TextStyle(color: const Color(0xFF04724D), fontSize: screenWidth * 0.05),
                      ),
                      Text(
                        "Phone: ${boothInfo['phoneNumber']}",
                        style: TextStyle(color: const Color(0xFF04724D), fontSize: screenWidth * 0.05),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: screenWidth * 0.05),

            Column(
              children: [
                SizedBox(
                  width: 0.8 * screenWidth,
                  height: 0.1 * screenHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
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
                      onPressed: () => moveToPage(context, PdfViewPage(url: boothInfo['pamphletURL']!)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF04724D)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                        ),
                      ),
                      child: Text(
                        "View PDF: $pdfName",
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                if (_progress != null) const CircularProgressIndicator(),
                if (_progress == null)
                  SizedBox(
                    width: 0.8 * screenWidth,
                    height: 0.1 * screenHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
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
                        onPressed: () async {
                          String url = await getPdfDownloadURL(boothInfo['pamphletURL']!);
                          download(url, pdfName!);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF04724D)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            ),
                          ),
                        ),
                        child: Text(
                          "Download PDF",
                          style: TextStyle(fontSize: screenWidth * 0.05),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdBar(
        onUpdate: () {},
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     String? pdfName = boothInfo['pamphletURL']?.substring(14);

//     return Scaffold(
//       backgroundColor: const Color(0xFFC2D3CD),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFC2D3CD),
//         leading: const BackButton(),
//         title: Text("${boothInfo['orgName']} (${boothInfo['boothNumber']})"),
//       ),
//       body: SingleChildScrollView(
//         // PDF表示を含むコンテンツが縦に長くなる可能性があるため、SingleChildScrollViewを使用
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: toggleIsSaved,
//                 child: Icon(isSaved ? Icons.star : Icons.star_border)),
//             Text(
//               "Event: ${boothInfo['eventName']}",
//               style: myTextStyle,
//             ),
//             Text(
//               "Booth Number: ${boothInfo['boothNumber']}",
//               style: myTextStyle,
//             ),
//             Text(
//               "Organization: ${boothInfo['orgName']}",
//               style: myTextStyle,
//             ),
//             Text(
//               "Name: ${boothInfo['yourName']}",
//               style: myTextStyle,
//             ),
//             Text(
//               "Email: ${boothInfo['emailAddress']}",
//               style: myTextStyle,
//             ),
//             Text(
//               "Phone: ${boothInfo['phoneNumber']}",
//               style: myTextStyle,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => moveToPage(
//                   context, PdfViewPage(url: boothInfo['pamphletURL']!)),
//               child: Text("View PDF: $pdfName"),
//             ),
//             _progress != null
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: () async {
//                       // download1(pdfName!);
//                       String url =
//                           await getPdfDownloadURL(boothInfo['pamphletURL']!);
//                       download(url, pdfName!);
//                     },
//                     child: const Text("Download PDF"),
//                   ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: AdBar(
//         onUpdate: () {
//         },
//       ),
//     );
//   }
// }
