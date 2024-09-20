import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base/data_source/SharedPreferencesInstance.dart';
import '../base/notifiers/search_value_notifier.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController textController;
  final List<dynamic> _searchList = [];
  late SharedPreferencesInstance sPrefs;

  @override
  void initState() {
    textController = TextEditingController(text: '');
    sPrefs = context.read<SharedPreferencesInstance>();
    _getAllSearchStrings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: textController,
          autofocus: true,
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchSubmitted,
          onSuffixTap: _onClearTextTap,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: _onBackPressed,
        ),
      ),
      body: ListView.builder(
        itemCount: _searchList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              _onSearchSubmitted(_searchList[index]);
            },
            child: ListTile(
              leading: const Icon(Icons.search),
              title: Text(_searchList[index]),
            ),
          );
        },
      ),
    );
  }

  // On back arrow press
  void _onBackPressed() {
    if(SearchValueProvider().textSearchValue.isNotEmpty) _setSearchString();
    SearchValueProvider().notify();
    Navigator.pop(context);
  }

  void _onSearchChanged(String value) {
    SearchValueProvider().textSearchValue = value;
  }

  void _onSearchSubmitted(String value) {
    SearchValueProvider().textSearchValue = value;
    _onBackPressed();
  }

  // Clears text in search field
  void _onClearTextTap() {
    SearchValueProvider().clearText();
    textController.clear();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Get all previous searches from preferences
  Future<void> _getAllSearchStrings() async {
    List<String> sList = await sPrefs.getSearchStrings();
    setState(() {
      _searchList.addAll(sList.reversed.toList());
    });
  }
  // Sets string to preferences
  Future<void> _setSearchString() async {
    await sPrefs.setSearchString(SearchValueProvider().textSearchValue);
  }
}