import 'package:flutter/material.dart';

void moveToPage(BuildContext context, Widget targetPage) {
  Navigator.push(
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

void popToPage(BuildContext context, String targetPageName) {
  Navigator.popUntil(context, (route) => route.settings.name == targetPageName);
}

void popOnce(BuildContext context) {
  Navigator.pop(context);
}
