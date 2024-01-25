import 'package:flutter/material.dart';
import 'package:test/cloud_functions/pamphlets.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/visitor/file_information.dart';

class EventViewPage extends StatefulWidget {
  // const EventViewPage({super.key});
  const EventViewPage({Key? key, required this.eventName, required this.startDate, required this.endDate, required this.eventCode}) : super(key: key);
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
    _pamphletData = await getAllBoothInfoForAnEvent(widget.eventCode);
    setState(() {});
  }

  Padding getSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SearchAnchor(
        isFullScreen: false,
        // viewLeading: const Icon(null),
        viewLeading: IconButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(_pamphletData.length, (index) {
            final String orgName = _pamphletData[index]['orgName'];
            return ListTile(
                title: Text(orgName),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    controller.closeView(orgName);
                  });
                });
          });
        },
      ),
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
            Text(
              "Start Date: ${widget.startDate}",
              style: myTextStyle,
            ),
            Text(
              "End Date: ${widget.endDate}",
              style: myTextStyle,
            ),
            // getAllBoothInfoForAnEvent(widget.eventCode)
            getSearchBar(context),
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
                    final String boothNumber = _pamphletData[index]['boothNumber'];
                    final String orgName = _pamphletData[index]['orgName'];

                    final String yourName = _pamphletData[index]['yourName'];
                    final String emailAddress = _pamphletData[index]['emailAddress'];
                    final String phoneNumber = _pamphletData[index]['phoneNumber'];

                    final String boothCode = _pamphletData[index]['boothCode'];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 100),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        // TODO: query event by event code
                        onPressed: () => moveToPage(context, FileInformationPage(
                            orgName: orgName,
                            boothNumber: boothNumber,
                            yourName: yourName, 
                            emailAddress: emailAddress, 
                            phoneNumber: phoneNumber, 
                            boothCode: boothCode,
                        )),
                        child: ListTile(
                          title: Text("$boothNumber ($orgName)"),
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
