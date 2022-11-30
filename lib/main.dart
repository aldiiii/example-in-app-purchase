import 'package:flutter/material.dart';

import 'configure_dependencies.dart';
import 'product_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ProductsPage(title: 'Flutter Demo purchase Page'),
    );
  }
}
