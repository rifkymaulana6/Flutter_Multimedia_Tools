import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multimedia_tools/home_page.dart';
import 'package:multimedia_tools/kompresi_audio_page.dart';
import 'package:multimedia_tools/kompresi_gambar_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multimedia Tools',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/kompresi_gambar': (context) => KompresiGambarPage(),
        '/kompresi_audio': (context) => KompresiAudioPage(),
      },
    );
  }
}
