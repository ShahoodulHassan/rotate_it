import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rotate_it/pages/home_page.dart';
import 'package:rotate_it/providers/AppLifecycleViewModel.dart';
import 'package:rotate_it/providers/main_view_model.dart';

import 'app_lifecycle_manager.dart';
import 'generic_functions.dart';

final navigatorKey = GlobalKey<NavigatorState>();
var appContext = navigatorKey.currentState!.overlay!.context;

bool get isPortrait => ScreenUtil().orientation == Orientation.portrait;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AppLifecycleViewModel()),
    ChangeNotifierProvider(create: (_) => MainViewModel()..generateData()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget with GenericFunctions {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
    var primaryColor = Colors.blue;
    var appBarItemColor = Colors.blueGrey.shade700;
    var fontFamily = GoogleFonts.poppins().fontFamily;
    return AppLifecycleManager(
      child: ScreenUtilInit(
        designSize: const Size(393, 830),
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'Rotate it',
          theme: ThemeData(
            colorSchemeSeed: primaryColor,
            highlightColor: primaryColor.withOpacity(0.10),
            splashColor: primaryColor.withOpacity(0.10),
            useMaterial3: true,
            fontFamily: fontFamily,
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                color: appBarItemColor,
                fontSize: 20,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          builder: (ctx, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
          home: const HomePage(),
        ),
      ),
    );
  }
}
