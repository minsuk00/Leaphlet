import 'package:flutter/material.dart';
import 'package:test/backend/cloud_functions/pamphlets.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/pages/common/search_anchor_widget.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/visitor/file_information.dart';

class EventViewPage extends StatefulWidget {
  // const EventViewPage({super.key});
  const EventViewPage(
      {Key? key,
      required this.eventName,
      required this.startDate,
      required this.endDate,
      required this.eventCode})
      : super(key: key);
  final String eventName;
  final String startDate;
  final String endDate;
  final String eventCode;
  @override
  State<EventViewPage> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  final TextStyle myTextStyle = const TextStyle(fontSize: 25);

  List _pamphletData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    getAllBoothInfoForAnEvent(widget.eventCode).then((value) {
      // debugPrint('############### INIT EVENTS PAGE ##################');
      // debugPrint('$value');
      setState(() {
        _pamphletData = value;
      });
    });
  }

  Padding getSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      // child: getSearchAnchor(context, _pamphletData, FileType.booth, setState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.eventName),
      ),
      body: Center(
        child: Column(
          children: [
            getSearchBar(context),
            // Text(
            //   "Start Date: ${widget.startDate}",
            //   style: myTextStyle,
            // ),
            // Text(
            //   "End Date: ${widget.endDate}",
            //   style: myTextStyle,
            // ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              // flex: 100,
              child: Scrollbar(
                thickness: 15,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _pamphletData.length,
                    itemBuilder: (context, index) {
                      // final String boothNumber =
                      //     _pamphletData[index]['boothNumber'];
                      // final String orgName = _pamphletData[index]['orgName'];

                      // final String yourName = _pamphletData[index]['yourName'];
                      // final String emailAddress =
                      //     _pamphletData[index]['emailAddress'];
                      // final String phoneNumber =
                      //     _pamphletData[index]['phoneNumber'];

                      // final String boothCode =
                      //     _pamphletData[index]['boothCode'];
                      final fileInfo = _pamphletData[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 100),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          // TODO: query event by event code
                          onPressed: () => moveToPage(
                            context,
                            FileInformationPage(fileInfo: fileInfo),
                          ),
                          // FileInformationPage(
                          //   orgName: orgName,
                          //   boothNumber: boothNumber,
                          //   yourName: yourName,
                          //   emailAddress: emailAddress,
                          //   phoneNumber: phoneNumber,
                          //   boothCode: boothCode,
                          // )),
                          child: ListTile(
                            title: Text(
                                "${fileInfo['boothNumber']} (${fileInfo['orgName']})"),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
