import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_qiita_client/dependency.dart';
import 'package:flutter_qiita_client/search/search_page.dart';

Future<void> main() async {
  await dotenv.load();
  Dependency.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Qiita Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'NotoSansCJK'
      ),
      home: const SearchPage(),
    );
  }
}
