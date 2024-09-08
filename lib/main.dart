import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/image_list.dart';
import 'package:provider_app/image_list_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageListViewModel>(
        create: (context) => ImageListViewModel(),
        child: const MaterialApp(
          title: 'Grid View',
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: ImageGrid(),
        ));
  }
}
