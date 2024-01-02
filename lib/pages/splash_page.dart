import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:get_it/get_it.dart';
import 'package:movie_app/models/app_config.dart';
import 'package:movie_app/service/movie_service.dart';

import '../service/http_service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({required this.onInitializationComplete, required UniqueKey key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late double _deviceWidth, _deviceHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 10)).then((value) =>
        _setup(context).then((value) => widget.onInitializationComplete()));
  }

  Future<void> _setup(BuildContext buildContext) async {
    final getIt = GetIt.instance;
    final configFile = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(configFile);

    getIt.registerSingleton<AppConfig>(AppConfig(configData["BASE_API_URL"],
        configData["BASE_IMAGE_API_URL"], configData["API_KEY"]));

    getIt.registerSingleton<HTTPService>(
      HTTPService(),
    );

    getIt.registerSingleton<MovieService>(
      MovieService(),
    );
  }


  @override
  Widget build(BuildContext context) {
    _deviceWidth = ui.window.physicalSize.width;
    _deviceHeight = ui.window.physicalSize.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frame Rate Movie App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Stack(children: [
        Container(
          height: _deviceHeight,
          width: _deviceWidth,
          color: Colors.white,
        ),
        Center(
          child: Container(
            height: _deviceHeight * 0.2,
            width: _deviceWidth * 0.2,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/logo.png'))),
          ),
        ),
      ]),
    );
  }
}
