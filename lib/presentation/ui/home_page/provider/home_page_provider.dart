import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageProvider = ChangeNotifierProvider(
  (ref) => HomePageProvider(ref),
);

class HomePageProvider extends ChangeNotifier {
  HomePageProvider(this.ref);
  final Ref ref;

  int counter = 0;

  incrementCounter() {
    counter++;
    notifyListeners();
  }
}
