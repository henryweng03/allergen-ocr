import 'package:flutter/material.dart';
import 'package:allergyapp/pages/allergen_list.dart';
import 'package:allergyapp/pages/scan.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => AllergenList(allergenList: [], compList: [],),
      "/scan": (context) => Scan(),
    },
  ));
}
