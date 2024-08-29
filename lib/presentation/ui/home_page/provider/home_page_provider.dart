import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageProvider = ChangeNotifierProvider(
  (ref) => HomePageProvider(ref),
);

class HomePageProvider extends ChangeNotifier {
  HomePageProvider(this.ref);
  final Ref ref;

  bool isSpeechPlay = false;
  bool isSecondSwitch = true;

  // 音声再生・停止ボタンクリック処理
  clickSpeakButton() {
    isSpeechPlay = !isSpeechPlay;
    notifyListeners();
  }

  // 秒読み上げスイッチ変更
  changeSecondSwitch() {
    isSecondSwitch = !isSecondSwitch;
  }
}
