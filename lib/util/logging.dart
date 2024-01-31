import 'dart:convert';

pprint(json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(json);
  print(prettyprint);
}
