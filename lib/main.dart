import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page/loading.dart';
import 'page/login.dart';
import 'page/merchant/merchant_page.dart';

Future<void> main() async {
  statusBarColor();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(color: Colors.black),
            iconTheme: IconThemeData(color: Colors.orange), //
          ),
          primarySwatch: Colors.red,
          inputDecorationTheme: InputDecorationTheme(
            focusColor: Colors.black,
            labelStyle: TextStyle(
              color: Colors.black54,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.redAccent,
                width: 2.0,
              ),
            ),
          )),
      routes: {'/': (context) => LoadingPage(), '/login': (context) => LoginPage(), '/merchant': (context) => MerchantPage(query: '',)},
    );
  }
}

statusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // status bar color
    statusBarBrightness: Brightness.dark, //status bar brigtness
    statusBarIconBrightness: Brightness.dark,
  ));
}
