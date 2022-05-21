import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../business_logic/cubit/azan_time/azan_time_cubit.dart';
import '../business_logic/cubit/quran/quran_cubit.dart';
import '../business_logic/cubit/radios/radio_cubit.dart';
import '../data/data_provider/remote/quran_api_services.dart';
import '../data/data_provider/remote/radios_api_services.dart';
import '../data/repository/quran_repository.dart';
import '../data/repository/radios_repository.dart';
import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/strings_manager.dart';
import '../presentation/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();
  static const MyApp instance = MyApp._internal();
  factory MyApp() => instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => QuranRepository(
            quranApiServices: QuranApiServices(),
          ),
        ),
        RepositoryProvider(
          create: (context) => RadiosRepository(
            radiosApiServices: RadiosApiServices(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
            BlocProvider<QuranCubit>(
              create: (context) => QuranCubit(
                quranRepository: context.read<QuranRepository>(),
              ),
            ),
            BlocProvider<RadioCubit>(
              create: (context) => RadioCubit(
                radiosRepository: context.read<RadiosRepository>(),
              ),
            ),
       
            BlocProvider<AzanTimeCubit>(
              create: (context) => AzanTimeCubit(),
            ),
          ],
        child: MaterialApp(
          title: AppStrings.titleApp,
          debugShowCheckedModeBanner: false,
          theme: getApplicationTheme(),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: Routes.mainRoute,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale(AppStrings.languageCode, AppStrings.countryCode),
          ],
        ),
      ),
    );
  }
}
