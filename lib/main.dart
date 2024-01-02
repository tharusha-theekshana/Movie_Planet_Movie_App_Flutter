import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/pages/main_page.dart';
import 'package:movie_app/pages/splash_page.dart';

void main() {
  runApp(
      SplashPage(key: UniqueKey(), onInitializationComplete: () =>
          runApp(
             ProviderScope(child: MyApp())
          ),
      ));
  }

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frame Rate Movie App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => MainPage(),
      },
    );
  }
}




