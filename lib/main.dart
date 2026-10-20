import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_quran/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.grey,
    ),
  );
  runApp(
    ProviderScope(child: MyApp()),
  );
}
