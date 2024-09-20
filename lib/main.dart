import 'package:flutter/material.dart';
import 'package:plm_image_app/base/dependencies_wrapper.dart';
import 'package:plm_image_app/views/home_page.dart';
import 'package:provider/provider.dart';
import 'base/http_client/http_client.dart';

void main() {
  runApp(const MyImageApp());
}

class MyImageApp extends StatelessWidget {
  const MyImageApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const DependenciesWrapper(
        child: _MaterialApp(),
      );
}

// Wrapper around the MaterialApp widget to provide additional functionality
class _MaterialApp extends StatefulWidget {
  const _MaterialApp();

  @override
  __MaterialAppState createState() => __MaterialAppState();
}

class __MaterialAppState extends State<_MaterialApp> {
  @override
  void initState() {
    _configureInterceptors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final materialApp = _buildMaterialApp(context);

    return materialApp;
  }

  Widget _buildMaterialApp(BuildContext context) => MaterialApp(
        title: 'My image app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(title: 'title app'),
      );

  void _configureInterceptors() {
    context.read<HttpClient>().configureInterceptors();
  }
}
