import 'package:flutter/material.dart';

Future<dynamic> moveToPage(BuildContext context, Widget targetPage) async {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => targetPage,
        settings: RouteSettings(name: targetPage.toString()),
      ));
}

void popNTimes(BuildContext context, int nTimes) {
  int cnt = nTimes;
  Navigator.popUntil(context, (_) => cnt-- <= 0);
}

// don't use. doesn't work on build
void popToPage(BuildContext context, String targetPageName) {
  Navigator.popUntil(context, (route) => route.settings.name == targetPageName);
}

void popOnce(BuildContext context) {
  Navigator.pop(context);
}
