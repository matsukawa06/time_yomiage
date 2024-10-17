import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_yomiage/common/common_const.dart';
import 'package:time_yomiage/presentation/controller/tts_controller.dart';

final homePageProvider = ChangeNotifierProvider(
  (ref) => HomePageProvider(ref),
);

class HomePageProvider extends ChangeNotifier {
  HomePageProvider(this.ref);
  final Ref ref;

  // 読み上げするか
  bool isSpeechPlay = false;
  // 秒読み上げするか
  bool isSecondSwitch = true;
  // 読み上げ回数
  int hourTimes = 1;

  // 初期化処理
  init() {
    // 端末設定の呼び出し
    // int prefsHourTimes =
    _getShaed();
    // ttsの初期化を呼び出す
    ref.read(ttsController).initTts();
  }

  // 端末保存情報の取得
  Future _getShaed() async {
    var prefs = await SharedPreferences.getInstance();
    // 秒読み上げするか
    isSecondSwitch = prefs.getBool(keyIsSecondSwitch) ?? true;
    // 読み上げ回数
    var prefsHourTimes = prefs.getInt(keyHourTimes);
    if (prefsHourTimes != null) {
      hourTimes = prefsHourTimes;
    }
    notifyListeners();
  }

  // ttsのspeakを呼び出す
  speakTts(String p) {
    ref.read(ttsController).speakTts(p);
  }

  // 音声再生・停止ボタンクリック処理
  clickSpeakButton() {
    isSpeechPlay = !isSpeechPlay;
    notifyListeners();
  }

  // 時間読み上げ繰り返しリスト変更
  changeHourTimesList(int e) {
    hourTimes = e;
    notifyListeners();
  }

  // 秒読み上げスイッチ変更
  changeSecondSwitch() {
    isSecondSwitch = !isSecondSwitch;
  }
}
