import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_maker/PROVIDERS/login_auth_provider.dart';
import 'package:money_maker/PROVIDERS/policy_status_pvovider.dart';
import 'package:money_maker/SCREENS/AUTH/login_screen.dart';
import 'package:money_maker/SCREENS/home_screen.dart';
import 'package:money_maker/SECURITY/storage_manager.dart';
import 'package:money_maker/THEMES/app_theme.dart';
import 'package:money_maker/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Future<InitializationStatus> initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }
  MobileAds.instance.updateRequestConfiguration(
  RequestConfiguration(testDeviceIds: ["49B6711069FA474969F3BDCDD9B913A4"]),
);


  await initGoogleMobileAds();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => PolicyStatusProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LoginAuthProvider(),
      ),
    ],
    child: const MyApp(),
  ));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(0, 0, 0, 0),
      statusBarIconBrightness: Brightness.light,
      // statusBarBrightness: Brightness.dark
    ),
  );
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: PerfectTeme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkAuthState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error occurred"));
          }
          log("Status : ${snapshot.data}");
          if (snapshot.data == true) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }

  static Future<bool> checkAuthState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    return isAuthenticated;
  }
}
