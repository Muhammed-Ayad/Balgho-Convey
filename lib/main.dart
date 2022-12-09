import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_quran/ui/app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.grey,
    ),
  );
  runApp(MyApp());
}
