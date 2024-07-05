import 'package:flutter/material.dart';

import 'package:carkapp/whell.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Çark Uygulaması',
      home: WheelWidget(),
    );
  }
}

AppBar topbar(BuildContext context,
    {String yazi = "Ana Sayfa", int size = 20}) {
  return AppBar(
    title: Text(
      yazi,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.amber,
  );
}
