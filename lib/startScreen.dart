import 'dart:async';
import 'package:app_weather/background/backgroundProvider.dart';
import 'package:app_weather/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartScreen extends ConsumerWidget {
   StartScreen({Key? key}) : super(key: key);

   void backgroundSetting(WidgetRef ref) {
     ref.read(backgroundRiverpodProvider.notifier).backgroundSetting();
   }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    backgroundSetting(ref);
    Timer(
        Duration(seconds: 7),
            () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Weather()));}
    );
    return Scaffold(
      backgroundColor: Color(0xff000000),
      body: Container(
          child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                  ),//Icon
                ), //Positioned
                Positioned(
                  top: 150,
                  child: Image.asset('images/logo1_dowload.gif'),
                ),
                Positioned(
                  bottom: 40,
                  height: 230,
                  width: 700,
                  child: Image.asset('images/logo3_dowload.gif'),
                ),
              ]
          )
      ),
    );
  }
}