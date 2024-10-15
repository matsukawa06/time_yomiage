import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_yomiage/common/shared_preferences.dart';
import 'package:time_yomiage/presentation/controller/tts_controller.dart';

///
/// テーマ変更用の状態クラス
///
final themeController = ChangeNotifierProvider<ThemeController>(
  (ref) => ThemeController(ref),
);

class ThemeController extends ChangeNotifier {
  // コンストラクタ
  ThemeController(this.ref) {
    _getShaed();
  }
  final Ref ref;
  // SharedPreferences用のキー文字列
  final String _keyIsDark = 'isDark';
  final String _keyVolume = 'volume';
  final String _keySpeechRate = 'speechRate';
  final String _keyPitch = 'pitch';
  // final String _keyMainColor = 'mainColor';

  // ダークモード関連
  ThemeMode mode = ThemeMode.light;
  bool isDark = false;
  // 読み上げ共通設定関連
  double volume = 1.0;
  double speechRate = 1.0;
  double pitch = 1.0;
  // List voiceName = [];

  // 端末保存情報の取得
  Future _getShaed() async {
    var prefs = await SharedPreferences.getInstance();
    // ダークモード
    isDark = prefs.getBool(_keyIsDark) ?? false;
    _lightOrDarkSetting();

    // ボリューム
    var prefsVolume = prefs.getDouble(_keyVolume);
    if (prefsVolume != null) {
      changeVolumeSlider(prefsVolume);
    }
    // 速度
    var prefsSpeechRate = prefs.getDouble(_keySpeechRate);
    if (prefsSpeechRate != null) {
      changeSpeechRateSlider(prefsSpeechRate);
    }
    // ピッチ
    var prefsPitch = prefs.getDouble(_keyPitch);
    if (prefsPitch != null) {
      changePitchSlider(prefsPitch);
    }

    notifyListeners();
  }

  // トグルでダークモードを切り替える関数を定義する
  brightnessToggle() {
    isDark = !isDark;
    _lightOrDarkSetting();
    // SharedPreferencesに保存
    Shared().saveBoolValue(_keyIsDark, isDark);
    notifyListeners();
  }

  // ダークモードでの設定内容
  _lightOrDarkSetting() {
    mode = isDark ? ThemeMode.dark : ThemeMode.light;
    // fontColor = isDark ? Colors.white : Colors.black;
  }

  // ボリュームスライダー変更
  changeVolumeSlider(double e) {
    ref.read(ttsController).changeVolume(e);
    volume = e;
    Shared().saveDoubleValue(_keyVolume, e);
    notifyListeners();
  }

  // 速度スライダー変更
  changeSpeechRateSlider(double e) {
    ref.read(ttsController).changeSpeechRate(e);
    speechRate = e;
    Shared().saveDoubleValue(_keySpeechRate, e);
    notifyListeners();
  }

  // ピッチスライダー変更
  changePitchSlider(double e) {
    ref.read(ttsController).changePitch(e);
    pitch = e;
    Shared().saveDoubleValue(_keyPitch, e);
    notifyListeners();
  }

  // // 声リスト作成
  // setVoicesList(FlutterTts e) async {
  //   List voices = await e.getVoices;
  //   for (var item in voices) {
  //     var map = item as Map<Object?, Object?>;
  //     if (map["locale"].toString().toLowerCase().contains("ja")) {
  //       voiceName.add(map["name"]);
  //     }
  //   }
  // }
}
