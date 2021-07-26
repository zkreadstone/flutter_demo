import 'package:flutter/material.dart';

import 'package:flutter_demo/router.dart' as router;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: Locale('en-US'),
      onGenerateRoute: router.generateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: 'homepage -测试',
    );
  }
}
 