import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/helpers/locales.dart';
import 'package:great_quran/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.grey,
    ),
  );
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        AppLocales.arabic,
      ],
      child: ProviderScope(child: MyApp()),
    ),
  );
}
