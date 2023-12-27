import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class VisitorHomePage extends StatefulWidget {
  const VisitorHomePage({super.key});

  @override
  State<VisitorHomePage> createState() => _VisitorHomePageState();
}

class _VisitorHomePageState extends State<VisitorHomePage> {
  List _eventData = [];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/dummy_event.json');
    final data = await json.decode(response);
    setState(() {
      _eventData = data["events"];
    });
    debugPrint(_eventData.toString());
  }

  @override
  void initState() {
    readJson();
    super.initState();
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
          return List<ListTile>.generate(_eventData.length, (index) {
            final String eventName = _eventData[index]['event_name'];
            return ListTile(
                title: Text(eventName),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    controller.closeView(eventName);
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
        scrolledUnderElevation: 0.0,
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          getSearchBar(context),
          // const Flexible(
          //   child: FractionallySizedBox(
          //     heightFactor: 0.08,
          //   ),
          // ),
          // const Spacer(flex: 1),
          const SizedBox(
            height: 20,
          ),
          OutlinedButton(
            onPressed: () => debugPrint('register new event'),
            child: const Text("register new event"),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            // flex: 100,
            child: Scrollbar(
              thickness: 15,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _eventData.length,
                  itemBuilder: (context, index) {
                    final String name = _eventData[index]['event_name'];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 100),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => debugPrint(name),
                        child: ListTile(
                          title: Text(name),
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
