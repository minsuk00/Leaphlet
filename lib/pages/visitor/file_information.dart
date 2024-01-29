import 'package:flutter/material.dart';
import 'package:test/backend/cloud_functions/pamphlets.dart'; // このパスは適宜修正してください。
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test/pages/visitor/pdf_view.dart';
import 'dart:io';

import 'package:test/util/navigate.dart';

class FileInformationPage extends StatefulWidget {
  // const FileInformationPage({Key? key, required this.orgName, required this.boothNumber, required this.yourName, required this.emailAddress, required this.phoneNumber, required this.boothCode}) : super(key: key);
  // final String orgName;
  // final String boothNumber;
  // final String yourName;
  // final String emailAddress;
  // final String phoneNumber;
  // final String boothCode;
  final Map<String, String?> fileInfo;
  const FileInformationPage({Key? key, required this.fileInfo})
      : super(key: key);

  @override
  State<FileInformationPage> createState() => _FileInformationPageState();
}

class _FileInformationPageState extends State<FileInformationPage> {
  final TextStyle myTextStyle = const TextStyle(fontSize: 25);
  // String? localPath;
  Map<String, String> boothInfo = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    // var pdfData = await getPamphletPdf(widget.boothCode);
    // if (pdfData != null && pdfData.isNotEmpty) {
    //   downloadFile(pdfData["pamphletURL"]);
    // }
    // downloadFile(widget.fileInfo['pamphletURL']!);

    getBoothInfo(widget.fileInfo['boothCode']!).then((value) {
      setState(() {
        // print("###################### $value");
        boothInfo = value!;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text("${boothInfo['boothNumber']} (${boothInfo['orgName']})"),
      ),
      body: SingleChildScrollView(
        // PDF表示を含むコンテンツが縦に長くなる可能性があるため、SingleChildScrollViewを使用
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Name: ${boothInfo['yourName']}",
              style: myTextStyle,
            ),
            Text(
              "Contact: ${boothInfo['emailAddress']} (${boothInfo['phoneNumber']})",
              style: myTextStyle,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => moveToPage(
                    context, PdfViewPage(url: boothInfo['pamphletURL'])),
                child: const Text("View PDF"))
            // localPath != null
            //     ? Expanded(
            //         child: PDFView(
            //           filePath: localPath,
            //         ),
            //       )
            //     : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
