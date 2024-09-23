import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/image_list.dart';
import 'package:provider_app/image_list_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Grid View',
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: ImageGrid(),
    );
  }
}
