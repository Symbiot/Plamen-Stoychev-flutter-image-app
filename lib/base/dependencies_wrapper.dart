import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'data_source/SharedPreferencesInstance.dart';
import 'http_client/http_client.dart';
import 'notifiers/search_value_notifier.dart';

class DependenciesWrapper extends StatefulWidget {
  const DependenciesWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<DependenciesWrapper> createState() =>
      _DependenciesWrapperState();
}

class _DependenciesWrapperState extends State<DependenciesWrapper> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)  => MultiProvider(
    // List of providers used throughout the app
    providers: [
      _httpClient,
      _searchValueProvider,
      _dataStorage,
    ],
    child: widget.child,
  );

  Provider get _httpClient =>
    Provider<HttpClient>(
      create: (context) {
        final client = HttpClient();
        return client;
      },
    );

  ChangeNotifierProvider get _searchValueProvider =>
      ChangeNotifierProvider<SearchValueProvider>(
        create: (context) {
          final client = SearchValueProvider();
          return client;
        },
      );

  SingleChildWidget get _dataStorage =>
    Provider<SharedPreferencesInstance>(
        create: (context) => SharedPreferencesInstance());

}