import 'package:flutter/material.dart';
import 'package:test/backend/cloud_functions/pamphlets.dart'; // このパスは適宜修正してください。
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/common/info.dart';
import 'package:marquee/marquee.dart';
import 'dart:io';

class FileInformationPage extends StatefulWidget {
  const FileInformationPage({Key? key, required this.orgName, required this.boothNumber, required this.yourName, required this.emailAddress, required this.phoneNumber, required this.boothCode}) : super(key: key);
  final String orgName;
  final String boothNumber;
  final String yourName;
  final String emailAddress;
  final String phoneNumber;
  final String boothCode;

  @override
  State<FileInformationPage> createState() => _FileInformationPageState();
}

class _FileInformationPageState extends State<FileInformationPage> {
  final TextStyle myTextStyle = const TextStyle(fontSize: 25);
  String? localPath;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var pdfData = await getPamphletPdf(widget.boothCode);
    if (pdfData != null && pdfData.isNotEmpty) {
      downloadFile(pdfData["pamphletURL"]);
    }
  }

  Future<void> downloadFile(String url) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(url);
      final bytes = await ref.getData();

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${widget.boothCode}.pdf');

      await file.writeAsBytes(bytes!, flush: true);

      setState(() {
        localPath = file.path;
      });
    } catch (e) {
    print('error: $e');
   }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: Text("${widget.boothNumber} (${widget.orgName})"),
      ),
      body: SingleChildScrollView( // PDF表示を含むコンテンツが縦に長くなる可能性があるため、SingleChildScrollViewを使用
        child: Column(
          children: [
            Text(
              "Name: ${widget.yourName}",
              style: myTextStyle,
            ),
            Text(
              "Contact: ${widget.emailAddress} (${widget.phoneNumber})",
              style: myTextStyle,
            ),
            const SizedBox(height: 20),
            localPath != null
              ? Expanded(
                  child: PDFView(
                    filePath: localPath,
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Marquee(
                  text: "Join the eco-friendly movement! 🌿 Let's cut down on paper waste together to protect our planet.",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  scrollAxis: Axis.horizontal,
                  blankSpace: 20.0,
                  velocity: 100.0,
                ),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () => moveToPage(context, const InfoPage()),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF766561)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  ),
                ),
                child: const Text("VIEW MORE"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
