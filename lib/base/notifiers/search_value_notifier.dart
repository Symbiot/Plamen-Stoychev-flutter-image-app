import 'package:flutter/material.dart';

class SearchValueProvider extends ChangeNotifier {
  static SearchValueProvider? _instance;

  factory SearchValueProvider() {
    _instance ??= SearchValueProvider._();
    return _instance!;
  }

  SearchValueProvider._();

  String textSearchValue = '';

  String get searchValue => textSearchValue;

  void clearText() => textSearchValue = '';

  void notify() {
    notifyListeners();
  }
}
