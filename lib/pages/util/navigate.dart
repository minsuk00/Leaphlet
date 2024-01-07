
import 'package:flutter/material.dart';

void moveToPage(BuildContext context, Widget targetPage) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
}
